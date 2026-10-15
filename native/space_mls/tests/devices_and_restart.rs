use ed25519_dalek::SigningKey;
use space_mls::{
    ClosedChannel, Device, DeviceBinding, Error, Message, PendingDelivery, SpaceDevice,
};

type TestResult = Result<(), Box<dyn std::error::Error>>;
const GROUP: &[u8] = b"server/channel/random-mls-group";

struct Peer {
    device: Device,
    binding: DeviceBinding,
}

fn peer(number: u8) -> Result<Peer, Error> {
    let seed = [number; 32];
    let scope = SpaceDevice {
        server_id: "test-server".into(),
        principal_id: format!("participant-{number}"),
        grant_id: format!("grant-{number}"),
        public_key: SigningKey::from_bytes(&seed).verifying_key().to_bytes(),
    };
    let device = Device::for_space(&scope)?;
    let binding = DeviceBinding::sign(&device, scope, &seed)?;
    Ok(Peer { device, binding })
}

fn message(text: &str) -> Result<Message, Error> {
    Message::new([1; 16], text.into(), vec![])
}

#[test]
fn four_devices_join_exchange_and_remove_member() -> TestResult {
    let mut alice = peer(1)?;
    let mut bob = peer(2)?;
    let mut charlie = peer(3)?;
    let mut diana = peer(4)?;
    let mut a = ClosedChannel::create(&mut alice.device, GROUP)?;
    let first = a.invite(
        &mut alice.device,
        &bob.device.key_package()?,
        &bob.device.trusted_identity(),
    )?;
    a.confirm_commit(&mut alice.device)?;
    let mut b = ClosedChannel::join(&mut bob.device, GROUP, &first.welcome, &a.members())?;
    let next = a.invite(
        &mut alice.device,
        &charlie.device.key_package()?,
        &charlie.device.trusted_identity(),
    )?;
    a.confirm_commit(&mut alice.device)?;
    b.apply_commit(
        &mut bob.device,
        &next.commit,
        &alice.device.trusted_identity(),
        &a.members(),
    )?;
    let (mut c, inviter) =
        ClosedChannel::join_with_sender(&mut charlie.device, GROUP, &next.welcome, &a.members())?;
    assert_eq!(inviter, alice.device.trusted_identity().identity);
    let last = a.invite(
        &mut alice.device,
        &diana.device.key_package()?,
        &diana.device.trusted_identity(),
    )?;
    a.confirm_commit(&mut alice.device)?;
    b.apply_commit(
        &mut bob.device,
        &last.commit,
        &alice.device.trusted_identity(),
        &a.members(),
    )?;
    c.apply_commit(
        &mut charlie.device,
        &last.commit,
        &alice.device.trusted_identity(),
        &a.members(),
    )?;
    let mut d = ClosedChannel::join(&mut diana.device, GROUP, &last.welcome, &a.members())?;
    let encrypted = d.encrypt(&mut diana.device, &message("Для четырёх устройств")?)?;
    for (channel, device) in [
        (&mut a, &mut alice.device),
        (&mut b, &mut bob.device),
        (&mut c, &mut charlie.device),
    ] {
        assert_eq!(
            channel.decrypt(device, &encrypted)?.message.text,
            "Для четырёх устройств"
        );
    }
    let remove = a.remove(&mut alice.device, &bob.device.trusted_identity())?;
    a.confirm_commit(&mut alice.device)?;
    c.apply_commit(
        &mut charlie.device,
        &remove,
        &alice.device.trusted_identity(),
        &a.members(),
    )?;
    d.apply_commit(
        &mut diana.device,
        &remove,
        &alice.device.trusted_identity(),
        &a.members(),
    )?;
    let encrypted = c.encrypt(&mut charlie.device, &message("После исключения")?)?;
    assert!(b.decrypt(&mut bob.device, &encrypted).is_err());
    d.decrypt(&mut diana.device, &encrypted)?;
    a.decrypt(&mut alice.device, &encrypted)?;
    Ok(())
}

#[test]
fn unauthorized_roster_or_committer_does_not_advance_epoch() -> TestResult {
    let mut alice = peer(1)?;
    let mut bob = peer(2)?;
    let mut charlie = peer(3)?;
    let mut a = ClosedChannel::create(&mut alice.device, GROUP)?;
    let first = a.invite(
        &mut alice.device,
        &bob.device.key_package()?,
        &bob.device.trusted_identity(),
    )?;
    a.confirm_commit(&mut alice.device)?;
    let mut b = ClosedChannel::join(&mut bob.device, GROUP, &first.welcome, &a.members())?;
    let old_epoch = b.epoch();
    let bob_identity = bob.device.trusted_identity();
    let next = a.invite(
        &mut alice.device,
        &charlie.device.key_package()?,
        &charlie.device.trusted_identity(),
    )?;
    a.confirm_commit(&mut alice.device)?;
    assert!(
        b.apply_commit(&mut bob.device, &next.commit, &bob_identity, &a.members())
            .is_err()
    );
    assert!(
        b.apply_commit(
            &mut bob.device,
            &next.commit,
            &alice.device.trusted_identity(),
            &b.members()
        )
        .is_err()
    );
    assert_eq!(b.epoch(), old_epoch);
    b.apply_commit(
        &mut bob.device,
        &next.commit,
        &alice.device.trusted_identity(),
        &a.members(),
    )?;
    assert_eq!(b.epoch(), a.epoch());
    assert!(
        b.apply_commit(
            &mut bob.device,
            &next.commit,
            &alice.device.trusted_identity(),
            &a.members()
        )
        .is_err()
    );
    Ok(())
}

#[test]
fn device_binding_checks_signature_and_scope() -> TestResult {
    let alice = peer(1)?;
    assert!(alice.binding.verify(&alice.binding.device).is_ok());
    let mut wrong = alice.binding.device.clone();
    wrong.server_id = "different-server".into();
    assert!(alice.binding.verify(&wrong).is_err());
    let mut binding: DeviceBinding = serde_json::from_slice(&serde_json::to_vec(&alice.binding)?)?;
    binding.mls_public_key[0] ^= 1;
    assert!(binding.verify(&binding.device).is_err());
    assert!(DeviceBinding::sign(&alice.device, alice.binding.device.clone(), &[99; 32]).is_err());
    Ok(())
}

#[test]
fn encrypted_restart_keeps_keys_epoch_and_exact_outbox() -> TestResult {
    let mut alice = peer(1)?;
    let mut bob = peer(2)?;
    let mut a = ClosedChannel::create(&mut alice.device, GROUP)?;
    let invite = a.invite(
        &mut alice.device,
        &bob.device.key_package()?,
        &bob.device.trusted_identity(),
    )?;
    a.confirm_commit(&mut alice.device)?;
    let mut b = ClosedChannel::join(&mut bob.device, GROUP, &invite.welcome, &a.members())?;
    let ciphertext = a.encrypt(&mut alice.device, &message("Перед перезапуском")?)?;
    let pending = vec![PendingDelivery {
        id: [1; 16],
        group_id: GROUP.to_vec(),
        epoch: a.epoch(),
        ciphertext: ciphertext.clone(),
    }];
    let checkpoint = alice
        .device
        .seal_state(&alice.binding, &[42; 32], 7, &pending)?;
    drop(a);
    drop(alice.device);
    let mut restored = Device::open_state(
        &alice.binding,
        &alice.binding.device,
        &[42; 32],
        7,
        &checkpoint,
    )?;
    assert_eq!(restored.pending[0].ciphertext, ciphertext);
    let mut a = ClosedChannel::restore(&mut restored.device, GROUP)?;
    b.decrypt(&mut bob.device, &restored.pending[0].ciphertext)?;
    let next = a.encrypt(&mut restored.device, &message("После перезапуска")?)?;
    assert_eq!(
        b.decrypt(&mut bob.device, &next)?.message.text,
        "После перезапуска"
    );
    let reply = b.encrypt(&mut bob.device, &message("Ответ после перезапуска")?)?;
    a.decrypt(&mut restored.device, &reply)?;
    Ok(())
}

#[test]
fn wrong_key_device_revision_and_corruption_are_rejected() -> TestResult {
    let alice = peer(1)?;
    let bob = peer(2)?;
    let mut checkpoint = alice.device.seal_state(&alice.binding, &[42; 32], 7, &[])?;
    assert!(
        Device::open_state(
            &alice.binding,
            &alice.binding.device,
            &[43; 32],
            7,
            &checkpoint
        )
        .is_err()
    );
    assert!(
        Device::open_state(
            &alice.binding,
            &alice.binding.device,
            &[42; 32],
            8,
            &checkpoint
        )
        .is_err()
    );
    assert!(
        Device::open_state(&bob.binding, &bob.binding.device, &[42; 32], 7, &checkpoint).is_err()
    );
    checkpoint[25] ^= 1;
    assert!(
        Device::open_state(
            &alice.binding,
            &alice.binding.device,
            &[42; 32],
            7,
            &checkpoint
        )
        .is_err()
    );
    Ok(())
}

#[test]
fn restart_preserves_consumed_receive_keys() -> TestResult {
    let mut alice = peer(1)?;
    let mut bob = peer(2)?;
    let mut a = ClosedChannel::create(&mut alice.device, GROUP)?;
    let invite = a.invite(
        &mut alice.device,
        &bob.device.key_package()?,
        &bob.device.trusted_identity(),
    )?;
    a.confirm_commit(&mut alice.device)?;
    let mut b = ClosedChannel::join(&mut bob.device, GROUP, &invite.welcome, &a.members())?;
    let first = a.encrypt(&mut alice.device, &message("Уже прочитано")?)?;
    b.decrypt(&mut bob.device, &first)?;
    let snapshot = bob.device.seal_state(&bob.binding, &[12; 32], 1, &[])?;
    drop(b);
    drop(bob.device);
    let mut restored =
        Device::open_state(&bob.binding, &bob.binding.device, &[12; 32], 1, &snapshot)?;
    let mut b = ClosedChannel::restore(&mut restored.device, GROUP)?;
    assert!(b.decrypt(&mut restored.device, &first).is_err());
    let next = a.encrypt(&mut alice.device, &message("Новое")?)?;
    b.decrypt(&mut restored.device, &next)?;
    Ok(())
}

#[test]
fn restart_keeps_pending_commit_and_unused_key_package() -> TestResult {
    let mut alice = peer(1)?;
    let mut bob = peer(2)?;
    let mut a = ClosedChannel::create(&mut alice.device, GROUP)?;
    let package = bob.device.key_package()?;
    let bob_state = bob.device.seal_state(&bob.binding, &[12; 32], 1, &[])?;
    let invite = a.invite(&mut alice.device, &package, &bob.device.trusted_identity())?;
    let alice_state = alice.device.seal_state(&alice.binding, &[13; 32], 1, &[])?;
    drop(a);
    drop(alice.device);
    drop(bob.device);
    let mut alice_restored = Device::open_state(
        &alice.binding,
        &alice.binding.device,
        &[13; 32],
        1,
        &alice_state,
    )?;
    let mut bob_restored =
        Device::open_state(&bob.binding, &bob.binding.device, &[12; 32], 1, &bob_state)?;
    let mut a = ClosedChannel::restore(&mut alice_restored.device, GROUP)?;
    assert!(
        a.encrypt(&mut alice_restored.device, &message("Рано")?)
            .is_err()
    );
    a.confirm_commit(&mut alice_restored.device)?;
    let mut b = ClosedChannel::join(
        &mut bob_restored.device,
        GROUP,
        &invite.welcome,
        &a.members(),
    )?;
    let ciphertext = a.encrypt(&mut alice_restored.device, &message("После подтверждения")?)?;
    assert_eq!(
        b.decrypt(&mut bob_restored.device, &ciphertext)?
            .message
            .text,
        "После подтверждения"
    );
    Ok(())
}
