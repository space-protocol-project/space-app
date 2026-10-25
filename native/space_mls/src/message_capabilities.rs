use std::collections::HashSet;

use openmls::prelude::*;
use serde::Serialize;

use crate::{Error, Message, Result, SUITE, SpaceDevice};

// Private use, не GREASE: объявление поддержки прикладного формата Space v2.
pub const MENTIONS_EXTENSION: ExtensionType = ExtensionType::Unknown(0xF053);

#[derive(Clone, Copy, Debug, PartialEq, Eq, Serialize)]
pub struct MessageFeatures {
    pub format: u8,
    pub own_mentions: bool,
    pub all_mentions: bool,
}

pub(crate) fn capabilities() -> Capabilities {
    Capabilities::new(
        None,
        Some(&[SUITE]),
        Some(&[MENTIONS_EXTENSION]),
        None,
        None,
    )
}

fn supported(leaf: &LeafNode) -> bool {
    leaf.capabilities()
        .extensions()
        .contains(&MENTIONS_EXTENSION)
}

pub(crate) fn features(group: &MlsGroup) -> MessageFeatures {
    let own_mentions = group.own_leaf_node().is_some_and(supported);
    let all_mentions = own_mentions && group.export_ratchet_tree().leaves().all(supported);
    MessageFeatures {
        format: 2,
        own_mentions,
        all_mentions,
    }
}

fn scope(identity: &[u8]) -> Result<SpaceDevice> {
    let (tag, scope): (String, SpaceDevice) =
        serde_json::from_slice(identity).map_err(|_| Error::UntrustedDevice)?;
    if tag != "space/mls/device/v1" {
        return Err(Error::UntrustedDevice);
    }
    scope.identity()?;
    Ok(scope)
}

pub(crate) fn require_recipients(group: &MlsGroup, message: &Message) -> Result<()> {
    let Some(mentions) = &message.mentions else {
        return Ok(());
    };
    if !features(group).all_mentions {
        return Err(Error::UnsupportedMessageFormat);
    }
    let own = group.own_leaf_node().ok_or(Error::InvalidState)?;
    let server = scope(own.credential().serialized_content())?.server_id;
    let recipients: HashSet<_> = group
        .members()
        .filter_map(|member| scope(member.credential.serialized_content()).ok())
        .filter(|member| member.server_id == server)
        .map(|member| member.principal_id)
        .collect();
    if mentions
        .iter()
        .any(|mention| !recipients.contains(&mention.principal_id))
    {
        return Err(Error::UntrustedDevice);
    }
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::{ClosedChannel, Device, Mention};
    use tls_codec::Serialize;

    type TestResult = std::result::Result<(), Box<dyn std::error::Error>>;
    const GROUP: &[u8] = b"space-mentions-test/private";

    fn device(id: &str) -> Result<Device> {
        Device::for_space(&SpaceDevice {
            server_id: "srv_mentions".into(),
            principal_id: id.into(),
            grant_id: format!("grant_{id}"),
            public_key: [7; 32],
        })
    }

    fn legacy_package(device: &mut Device) -> Result<Vec<u8>> {
        KeyPackage::builder()
            .build(
                SUITE,
                &device.provider,
                &device.signer,
                device.credential.clone(),
            )
            .map_err(|_| Error::Mls)?
            .key_package()
            .tls_serialize_detached()
            .map_err(|_| Error::Mls)
    }

    fn mentioned(id: &str) -> Result<Message> {
        Message::new([9; 16], "🚀 @Боб".into(), vec![])?.with_mentions(vec![Mention {
            principal_id: id.into(),
            display_name: "Боб".into(),
            start: 3,
            length: 4,
        }])
    }

    #[test]
    fn new_members_exchange_private_structured_mentions() -> TestResult {
        let mut alice = device("u_alice")?;
        let mut bob = device("u_bob")?;
        let mut sender = ClosedChannel::create(&mut alice, GROUP)?;
        let invite = sender.invite(&mut alice, &bob.key_package()?, &bob.trusted_identity())?;
        sender.confirm_commit(&mut alice)?;
        let roster = [alice.trusted_identity(), bob.trusted_identity()];
        let mut receiver = ClosedChannel::join(&mut bob, GROUP, &invite.welcome, &roster)?;
        assert!(sender.message_features().all_mentions);
        let ciphertext = sender.encrypt(&mut alice, &mentioned("u_bob")?)?;
        assert!(!ciphertext.windows(5).any(|part| part == b"u_bob"));
        let received = receiver.decrypt(&mut bob, &ciphertext)?;
        assert_eq!(received.message.mentions, mentioned("u_bob")?.mentions);
        assert!(matches!(
            sender.encrypt(&mut alice, &mentioned("u_foreign")?),
            Err(Error::UntrustedDevice)
        ));
        Ok(())
    }

    #[test]
    fn mixed_group_requires_legacy_text_until_leaf_update() -> TestResult {
        let mut alice = device("u_alice")?;
        let mut bob = device("u_bob")?;
        let mut sender = ClosedChannel::create(&mut alice, GROUP)?;
        let invite = sender.invite(
            &mut alice,
            &legacy_package(&mut bob)?,
            &bob.trusted_identity(),
        )?;
        sender.confirm_commit(&mut alice)?;
        let roster = [alice.trusted_identity(), bob.trusted_identity()];
        let mut receiver = ClosedChannel::join(&mut bob, GROUP, &invite.welcome, &roster)?;
        assert!(!sender.message_features().all_mentions);
        assert!(!receiver.message_features().own_mentions);
        assert!(matches!(
            sender.encrypt(&mut alice, &mentioned("u_bob")?),
            Err(Error::UnsupportedMessageFormat)
        ));
        let plain = Message::new([1; 16], "@Боб".into(), vec![])?;
        let ciphertext = sender.encrypt(&mut alice, &plain)?;
        assert!(
            receiver
                .decrypt(&mut bob, &ciphertext)?
                .message
                .mentions
                .is_none()
        );

        let commit = receiver.self_update(&mut bob)?;
        assert!(!receiver.message_features().own_mentions);
        receiver.confirm_commit(&mut bob)?;
        sender.apply_commit(&mut alice, &commit, &bob.trusted_identity(), &roster)?;
        assert!(sender.message_features().all_mentions);
        assert!(receiver.message_features().all_mentions);
        let ciphertext = sender.encrypt(&mut alice, &mentioned("u_bob")?)?;
        assert!(
            receiver
                .decrypt(&mut bob, &ciphertext)?
                .message
                .mentions
                .is_some()
        );
        Ok(())
    }
}
