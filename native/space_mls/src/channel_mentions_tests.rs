use super::*;
use crate::SpaceDevice;

#[test]
fn malformed_authenticated_mentions_do_not_consume_receive_ratchet()
-> std::result::Result<(), Box<dyn std::error::Error>> {
    let scope = |id: &str| SpaceDevice {
        server_id: "server".into(),
        principal_id: id.into(),
        grant_id: format!("grant_{id}"),
        public_key: [7; 32],
    };
    let mut alice = Device::for_space(&scope("alice"))?;
    let mut bob = Device::for_space(&scope("bob"))?;
    let mut sender = ClosedChannel::create(&mut alice, b"private")?;
    let invite = sender.invite(&mut alice, &bob.key_package()?, &bob.trusted_identity())?;
    sender.confirm_commit(&mut alice)?;
    let roster = [alice.trusted_identity(), bob.trusted_identity()];
    let mut receiver = ClosedChannel::join(&mut bob, b"private", &invite.welcome, &roster)?;
    let body = serde_json::to_vec(&serde_json::json!({
        "version":2, "id":vec![1;16], "text":"🚀 @Боб", "files":[],
        "mentions":[{"principal_id":"bob", "display_name":"Боб", "start":1,"length":4}]
    }))?;
    // Имитируем подписанный вредоносным участником JSON в обход проверки отправителя.
    let ciphertext = sender
        .group
        .create_message(&alice.provider, &alice.signer, &body)?
        .tls_serialize_detached()?;
    for _ in 0..2 {
        assert!(matches!(
            receiver.decrypt(&mut bob, &ciphertext),
            Err(Error::InvalidInput)
        ));
    }
    let message = Message::new([2; 16], "Правильное сообщение".into(), vec![])?;
    let ciphertext = sender.encrypt(&mut alice, &message)?;
    assert_eq!(
        receiver.decrypt(&mut bob, &ciphertext)?.message.text,
        message.text
    );
    Ok(())
}
