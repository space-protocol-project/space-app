use serde::Deserialize;
use space_mls::{ClosedChannel, Device, DeviceBinding, Message};

const GROUP: &[u8] = b"space/legacy-mls-provider/migration-v1";

#[derive(Deserialize)]
struct Fixture {
    alice: DeviceBinding,
    bob: DeviceBinding,
    alice_state: Vec<u8>,
    bob_state: Vec<u8>,
    old_reply: Vec<u8>,
}

#[test]
fn old_rustcrypto_checkpoint_and_messages_survive_provider_upgrade()
-> Result<(), Box<dyn std::error::Error>> {
    let fixture: Fixture =
        serde_json::from_str(include_str!("fixtures/openmls-0.9.1-rustcrypto.json"))?;
    let mut alice = Device::open_state(
        &fixture.alice,
        &fixture.alice.device,
        &[42; 32],
        7,
        &fixture.alice_state,
    )?;
    let mut bob = Device::open_state(
        &fixture.bob,
        &fixture.bob.device,
        &[42; 32],
        8,
        &fixture.bob_state,
    )?;
    assert_eq!(alice.pending.len(), 1);
    assert!(alice.device.trusted_identity() == fixture.alice.verify(&fixture.alice.device)?);
    let mut a = ClosedChannel::restore(&mut alice.device, GROUP)?;
    let mut b = ClosedChannel::restore(&mut bob.device, GROUP)?;
    assert_eq!(
        b.decrypt(&mut bob.device, &alice.pending[0].ciphertext)?
            .message
            .text,
        "Перед обновлением"
    );
    assert_eq!(
        a.decrypt(&mut alice.device, &fixture.old_reply)?
            .message
            .text,
        "Старый ответ"
    );
    let next = a.encrypt(
        &mut alice.device,
        &Message::new([3; 16], "После обновления".into(), vec![])?,
    )?;
    assert_eq!(
        b.decrypt(&mut bob.device, &next)?.message.text,
        "После обновления"
    );
    let checkpoint = alice.device.seal_state(&fixture.alice, &[42; 32], 8, &[])?;
    let restored = Device::open_state(
        &fixture.alice,
        &fixture.alice.device,
        &[42; 32],
        8,
        &checkpoint,
    )?;
    assert!(restored.pending.is_empty());
    if let Some(path) = std::env::var_os("SPACE_MLS_MIGRATION_OUTPUT") {
        std::fs::write(path, next)?;
    }
    Ok(())
}
