use mls_rs::{
    CipherSuite, CipherSuiteProvider, Client, CryptoProvider, MlsMessage,
    identity::{
        SigningIdentity,
        basic::{BasicCredential, BasicIdentityProvider},
    },
};
use mls_rs_crypto_awslc::AwsLcCryptoProvider;
use space_mls::{ClosedChannel, Device, Message, TrustedDevice};

#[test]
fn openmls_and_mls_rs_exchange_and_update() -> Result<(), Box<dyn std::error::Error>> {
    let provider = AwsLcCryptoProvider::default();
    let suite = provider
        .cipher_suite_provider(CipherSuite::CURVE25519_AES128)
        .ok_or("Нет suite")?;
    let (secret, public) = suite.signature_key_generate()?;
    let bob_identity = b"interop-bob".to_vec();
    let trusted_bob = TrustedDevice {
        identity: bob_identity.clone(),
        signature_key: public.to_vec(),
    };
    let bob = Client::builder()
        .mls_rules(
            mls_rs::group::mls_rules::DefaultMlsRules::new().with_encryption_options(
                mls_rs::group::mls_rules::EncryptionOptions::new(true, Default::default()),
            ),
        )
        .crypto_provider(provider)
        .identity_provider(BasicIdentityProvider::new())
        .signing_identity(
            SigningIdentity::new(BasicCredential::new(bob_identity).into_credential(), public),
            secret,
            CipherSuite::CURVE25519_AES128,
        )
        .build();
    let package = bob
        .generate_key_package_message(Default::default(), Default::default(), None)?
        .to_bytes()?;
    let mut alice = Device::generate(b"interop-alice")?;
    let mut group = ClosedChannel::create(&mut alice, b"interop-group")?;
    // MLSMessage содержит version и wire_format перед KeyPackage.
    let invitation = group.invite(
        &mut alice,
        package.get(4..).ok_or("Нет KeyPackage")?,
        &trusted_bob,
    )?;
    group.confirm_commit(&mut alice)?;
    let (mut bob_group, _) =
        bob.join_group(None, &MlsMessage::from_bytes(&invitation.welcome)?, None)?;
    let message = Message::new([1; 16], "Секрет".into(), vec![])?;
    let encrypted = group.encrypt(&mut alice, &message)?;
    let received = bob_group.process_incoming_message(MlsMessage::from_bytes(&encrypted)?)?;
    assert!(matches!(
        received,
        mls_rs::group::ReceivedMessage::ApplicationMessage(_)
    ));
    let reply = bob_group
        .encrypt_application_message(&serde_json::to_vec(&message)?, Default::default())?;
    assert_eq!(
        group.decrypt(&mut alice, &reply.to_bytes()?)?.message.text,
        "Секрет"
    );
    let bob_update = bob_group.commit_builder().build()?;
    bob_group.apply_pending_commit()?;
    let trusted_alice = alice.trusted_identity();
    group.apply_commit(
        &mut alice,
        &bob_update.commit_message.to_bytes()?,
        &trusted_bob,
        &[trusted_alice, trusted_bob.clone()],
    )?;
    let update = group.self_update(&mut alice)?;
    group.confirm_commit(&mut alice)?;
    bob_group.process_incoming_message(MlsMessage::from_bytes(&update)?)?;
    let reply = bob_group
        .encrypt_application_message(&serde_json::to_vec(&message)?, Default::default())?;
    assert_eq!(
        group.decrypt(&mut alice, &reply.to_bytes()?)?.message.text,
        "Секрет"
    );
    let remove = group.remove(&mut alice, &trusted_bob)?;
    group.confirm_commit(&mut alice)?;
    bob_group.process_incoming_message(MlsMessage::from_bytes(&remove)?)?;
    let after_remove = group.encrypt(&mut alice, &message)?;
    assert!(
        bob_group
            .process_incoming_message(MlsMessage::from_bytes(&after_remove)?)
            .is_err()
    );
    let stale = bob_group
        .encrypt_application_message(&serde_json::to_vec(&message)?, Default::default())?;
    assert!(group.decrypt(&mut alice, &stale.to_bytes()?).is_err());
    Ok(())
}
