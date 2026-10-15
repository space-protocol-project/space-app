use base64::{Engine, engine::general_purpose::STANDARD};
use serde::Deserialize;
use serde_json::{Value, json};
use space_mls::{ClosedChannel, Device, DeviceBinding, Error, Message, SpaceDevice, TrustedDevice};

type Result<T> = std::result::Result<T, Error>;

#[derive(Deserialize)]
#[serde(deny_unknown_fields)]
struct Request {
    op: String,
    scope: SpaceDevice,
    key: [u8; 32],
    revision: u64,
    binding: Option<DeviceBinding>,
    snapshot: Option<String>,
    args: Value,
}

pub fn execute(input: &[u8]) -> Result<Value> {
    let mut request: Request = serde_json::from_slice(input).map_err(|_| Error::InvalidInput)?;
    if request.op == "new" {
        return create(request);
    }
    let binding = request.binding.take().ok_or(Error::InvalidInput)?;
    let snapshot = STANDARD
        .decode(request.snapshot.as_deref().ok_or(Error::InvalidInput)?)
        .map_err(|_| Error::InvalidInput)?;
    let mut state = Device::open_state(
        &binding,
        &request.scope,
        &request.key,
        request.revision,
        &snapshot,
    )?;
    let result = operate(&request, &mut state.device)?;
    let revision = request.revision.checked_add(1).ok_or(Error::InvalidState)?;
    let snapshot = state
        .device
        .seal_state(&binding, &request.key, revision, &state.pending)?;
    Ok(
        json!({"result":result,"snapshot":STANDARD.encode(snapshot),"revision":revision,"binding":binding}),
    )
}

fn create(request: Request) -> Result<Value> {
    let seed: [u8; 32] = serde_json::from_value(request.args["device_seed"].clone())
        .map_err(|_| Error::InvalidInput)?;
    let device = Device::for_space(&request.scope)?;
    let binding = DeviceBinding::sign(&device, request.scope, &seed)?;
    let snapshot = device.seal_state(&binding, &request.key, 0, &[])?;
    Ok(json!({"result":{},"snapshot":STANDARD.encode(snapshot),"revision":0,"binding":binding}))
}

fn operate(request: &Request, device: &mut Device) -> Result<Value> {
    match request.op.as_str() {
        "key_package" => Ok(json!({"key_package":STANDARD.encode(device.key_package()?)})),
        "create_group" => {
            let group = ClosedChannel::create(device, &bytes(&request.args, "group_id")?)?;
            Ok(json!({"epoch":group.epoch()}))
        }
        "join" => join(request, device),
        "seal_file" => seal_file(request),
        "open_file" => open_file(request),
        _ => group_operation(request, device),
    }
}

fn group_operation(request: &Request, device: &mut Device) -> Result<Value> {
    let mut group = ClosedChannel::restore(device, &bytes(&request.args, "group_id")?)?;
    match request.op.as_str() {
        "group_code" => Ok(json!({"epoch":group.epoch(),
            "authenticator":STANDARD.encode(group.epoch_authenticator())})),
        "self_update" => {
            let commit = group.self_update(device)?;
            Ok(json!({"commit":STANDARD.encode(commit),"epoch":group.epoch()}))
        }
        "invite" => invite(request, device, &mut group),
        "confirm_commit" => {
            group.confirm_commit(device)?;
            group.verify_members(&roster(&request.args["roster"])?)?;
            Ok(json!({"epoch":group.epoch()}))
        }
        "discard_commit" => {
            group.discard_pending_commit(device)?;
            Ok(json!({"epoch":group.epoch()}))
        }
        "apply_commit" => apply_commit(request, device, &mut group),
        "encrypt" => {
            let message: Message = serde_json::from_value(request.args["message"].clone())
                .map_err(|_| Error::InvalidInput)?;
            let ciphertext = group.encrypt(device, &message)?;
            Ok(json!({"ciphertext":STANDARD.encode(ciphertext),"epoch":group.epoch()}))
        }
        "decrypt" => {
            let received = group.decrypt(device, &bytes(&request.args, "ciphertext")?)?;
            Ok(json!({"message":received.message,"sender":STANDARD.encode(received.sender)}))
        }
        "remove" => {
            let peer = binding(&request.args["peer"])?;
            let commit = group.remove(device, &peer)?;
            Ok(json!({"commit":STANDARD.encode(commit),"epoch":group.epoch()}))
        }
        _ => Err(Error::InvalidInput),
    }
}

fn invite(request: &Request, device: &mut Device, group: &mut ClosedChannel) -> Result<Value> {
    let peer = binding(&request.args["peer"])?;
    let invitation = group.invite(device, &bytes(&request.args, "key_package")?, &peer)?;
    Ok(
        json!({"commit":STANDARD.encode(invitation.commit),"welcome":STANDARD.encode(invitation.welcome),"epoch":group.epoch()}),
    )
}

fn join(request: &Request, device: &mut Device) -> Result<Value> {
    let roster = roster(&request.args["roster"])?;
    let (group, sender) = ClosedChannel::join_with_sender(
        device,
        &bytes(&request.args, "group_id")?,
        &bytes(&request.args, "welcome")?,
        &roster,
    )?;
    Ok(json!({"epoch":group.epoch(),"sender":STANDARD.encode(sender)}))
}

fn apply_commit(
    request: &Request,
    device: &mut Device,
    group: &mut ClosedChannel,
) -> Result<Value> {
    // Состояние этого вызова — отдельный кандидат. При отказе Commit
    // исходный snapshot с pending Commit остаётся неизменным.
    group.discard_pending_commit(device)?;
    group.apply_commit(
        device,
        &bytes(&request.args, "commit")?,
        &binding(&request.args["committer"])?,
        &roster(&request.args["roster"])?,
    )?;
    Ok(json!({"epoch":group.epoch()}))
}

fn seal_file(request: &Request) -> Result<Value> {
    let id = serde_json::from_value(request.args["message_id"].clone())
        .map_err(|_| Error::InvalidInput)?;
    let name = request.args["name"]
        .as_str()
        .ok_or(Error::InvalidInput)?
        .to_owned();
    let sealed = space_mls::seal_file(
        &bytes(&request.args, "group_id")?,
        id,
        name,
        &bytes(&request.args, "plaintext")?,
    )?;
    Ok(json!({"ciphertext":STANDARD.encode(sealed.ciphertext),"descriptor":sealed.descriptor}))
}

fn open_file(request: &Request) -> Result<Value> {
    let id = serde_json::from_value(request.args["message_id"].clone())
        .map_err(|_| Error::InvalidInput)?;
    let descriptor = serde_json::from_value(request.args["descriptor"].clone())
        .map_err(|_| Error::InvalidInput)?;
    let plaintext = space_mls::open_file(
        &bytes(&request.args, "group_id")?,
        id,
        &descriptor,
        &bytes(&request.args, "ciphertext")?,
    )?;
    Ok(json!({"plaintext":STANDARD.encode(plaintext)}))
}

fn binding(value: &Value) -> Result<TrustedDevice> {
    let binding: DeviceBinding =
        serde_json::from_value(value.clone()).map_err(|_| Error::InvalidInput)?;
    // Вызывающая сторона обязана сверить эти ключи со своим хранилищем доверия.
    binding.verify(&binding.device)
}

fn roster(value: &Value) -> Result<Vec<TrustedDevice>> {
    value
        .as_array()
        .ok_or(Error::InvalidInput)?
        .iter()
        .map(binding)
        .collect()
}

fn bytes(value: &Value, name: &str) -> Result<Vec<u8>> {
    STANDARD
        .decode(value[name].as_str().ok_or(Error::InvalidInput)?)
        .map_err(|_| Error::InvalidInput)
}
