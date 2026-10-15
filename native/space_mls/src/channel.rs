use openmls::prelude::*;
use tls_codec::{Deserialize, Serialize};

use crate::{
    Device, Error, MAX_GROUP_DEVICES, MAX_HANDSHAKE_SIZE, MAX_MESSAGE_SIZE, Message, Result, SUITE,
    TrustedDevice,
};

pub struct ClosedChannel {
    group: MlsGroup,
    owner: TrustedDevice,
}

pub struct Invitation {
    pub commit: Vec<u8>,
    pub welcome: Vec<u8>,
}

pub struct ReceivedMessage {
    pub sender: Vec<u8>,
    pub message: Message,
}

impl ClosedChannel {
    pub fn create(device: &mut Device, group_id: &[u8]) -> Result<Self> {
        valid_group_id(group_id)?;
        let config = MlsGroupCreateConfig::builder()
            .ciphersuite(SUITE)
            .use_ratchet_tree_extension(true)
            .wire_format_policy(PURE_CIPHERTEXT_WIRE_FORMAT_POLICY)
            .build();
        let group = MlsGroup::new_with_group_id(
            &device.provider,
            &device.signer,
            &config,
            GroupId::from_slice(group_id),
            device.credential.clone(),
        )
        .map_err(|_| Error::Mls)?;
        Ok(Self {
            group,
            owner: device.trusted_identity(),
        })
    }

    // Commit подтверждается отдельно после надёжного принятия сервером.
    pub fn invite(
        &mut self,
        device: &mut Device,
        key_package: &[u8],
        trusted: &TrustedDevice,
    ) -> Result<Invitation> {
        self.require_owner(device)?;
        if self.group.members().count() >= MAX_GROUP_DEVICES || key_package.len() > MAX_MESSAGE_SIZE
        {
            return Err(Error::InvalidInput);
        }
        let package = KeyPackageIn::tls_deserialize_exact(key_package)
            .map_err(|_| Error::InvalidInput)?
            .validate(device.provider.crypto(), ProtocolVersion::Mls10)
            .map_err(|_| Error::Mls)?;
        let leaf = package.leaf_node();
        require_trusted(leaf.credential(), leaf.signature_key().as_slice(), trusted)?;
        let (commit, welcome, _) = self
            .group
            .add_members(&device.provider, &device.signer, &[package])
            .map_err(|_| Error::Mls)?;
        Ok(Invitation {
            commit: commit.tls_serialize_detached().map_err(|_| Error::Mls)?,
            welcome: welcome.tls_serialize_detached().map_err(|_| Error::Mls)?,
        })
    }

    // Вызывать только после надёжного принятия Commit сервером доставки.
    pub fn confirm_commit(&mut self, device: &mut Device) -> Result<()> {
        self.require_owner(device)?;
        self.group
            .merge_pending_commit(&device.provider)
            .map_err(|_| Error::Mls)
    }

    pub fn discard_pending_commit(&mut self, device: &mut Device) -> Result<()> {
        self.require_owner(device)?;
        self.group
            .clear_pending_commit(device.provider.storage())
            .map_err(|_| Error::Mls)
    }

    pub fn join(
        device: &mut Device,
        group_id: &[u8],
        welcome: &[u8],
        roster: &[TrustedDevice],
    ) -> Result<Self> {
        Self::join_with_sender(device, group_id, welcome, roster).map(|(group, _)| group)
    }

    pub fn join_with_sender(
        device: &mut Device,
        group_id: &[u8],
        welcome: &[u8],
        roster: &[TrustedDevice],
    ) -> Result<(Self, Vec<u8>)> {
        valid_group_id(group_id)?;
        if welcome.len() > MAX_HANDSHAKE_SIZE
            || roster.is_empty()
            || roster.len() > MAX_GROUP_DEVICES
        {
            return Err(Error::InvalidInput);
        }
        let input =
            MlsMessageIn::tls_deserialize_exact(welcome).map_err(|_| Error::InvalidInput)?;
        let MlsMessageBodyIn::Welcome(welcome) = input.extract() else {
            return Err(Error::UnexpectedMessage);
        };
        let config = MlsGroupJoinConfig::builder()
            .wire_format_policy(PURE_CIPHERTEXT_WIRE_FORMAT_POLICY)
            .build();
        let candidate = crate::transaction::Candidate::new(&device.provider)?;
        let staged = StagedWelcome::new_from_welcome(candidate.provider(), &config, welcome, None)
            .map_err(|_| Error::Mls)?;
        // Проверки выполняются до принятия группы и записи её состояния.
        if staged.group_context().group_id().as_slice() != group_id
            || staged.group_context().ciphersuite() != SUITE
        {
            return Err(Error::UntrustedDevice);
        }
        let members: Vec<_> = staged.members().collect();
        verify_roster(&members, roster)?;
        let sender = staged
            .welcome_sender()
            .map_err(|_| Error::Mls)?
            .credential()
            .serialized_content()
            .to_vec();
        let group = staged
            .into_group(candidate.provider())
            .map_err(|_| Error::Mls)?;
        candidate.commit(&device.provider)?;
        Ok((
            Self {
                group,
                owner: device.trusted_identity(),
            },
            sender,
        ))
    }

    pub fn encrypt(&mut self, device: &mut Device, message: &Message) -> Result<Vec<u8>> {
        self.require_owner(device)?;
        if self.group.pending_commit().is_some() {
            return Err(Error::Mls);
        }
        message.validate()?;
        let payload =
            zeroize::Zeroizing::new(serde_json::to_vec(message).map_err(|_| Error::InvalidInput)?);
        let encrypted = self
            .group
            .create_message(&device.provider, &device.signer, &payload)
            .map_err(|_| Error::Mls)?;
        encrypted.tls_serialize_detached().map_err(|_| Error::Mls)
    }

    pub fn decrypt(&mut self, device: &mut Device, ciphertext: &[u8]) -> Result<ReceivedMessage> {
        self.require_owner(device)?;
        if ciphertext.len() > MAX_MESSAGE_SIZE {
            return Err(Error::InvalidInput);
        }
        let input =
            MlsMessageIn::tls_deserialize_exact(ciphertext).map_err(|_| Error::InvalidInput)?;
        if input.wire_format() != WireFormat::PrivateMessage {
            return Err(Error::UnexpectedMessage);
        }
        let protocol = input
            .try_into_protocol_message()
            .map_err(|_| Error::UnexpectedMessage)?;
        if protocol.content_type() != ContentType::Application {
            return Err(Error::UnexpectedMessage);
        }
        // OpenMLS меняет ratchet до окончания проверки. Неудачная попытка
        // не должна расходовать ключ подлинного сообщения в основном состоянии.
        let candidate = crate::transaction::Candidate::new(&device.provider)?;
        let mut group = MlsGroup::load(candidate.provider().storage(), self.group.group_id())
            .map_err(|_| Error::Mls)?
            .ok_or(Error::Mls)?;
        let processed = group
            .process_message(candidate.provider(), protocol)
            .map_err(|_| Error::Mls)?;
        let sender = processed.credential().serialized_content().to_vec();
        let ProcessedMessageContent::ApplicationMessage(application) = processed.into_content()
        else {
            return Err(Error::UnexpectedMessage);
        };
        let plaintext = zeroize::Zeroizing::new(application.into_bytes());
        let message: Message =
            serde_json::from_slice(&plaintext).map_err(|_| Error::InvalidInput)?;
        message.validate()?;
        candidate.commit(&device.provider)?;
        self.group = group;
        Ok(ReceivedMessage { sender, message })
    }

    pub fn remove(&mut self, device: &mut Device, trusted: &TrustedDevice) -> Result<Vec<u8>> {
        self.require_owner(device)?;
        let member = self
            .group
            .members()
            .find(|member| {
                member.credential.serialized_content() == trusted.identity
                    && member.signature_key == trusted.signature_key
            })
            .ok_or(Error::UntrustedDevice)?;
        let (commit, _, _) = self
            .group
            .remove_members(&device.provider, &device.signer, &[member.index])
            .map_err(|_| Error::Mls)?;
        commit.tls_serialize_detached().map_err(|_| Error::Mls)
    }

    pub fn group_id(&self) -> &[u8] {
        self.group.group_id().as_slice()
    }

    pub fn epoch(&self) -> u64 {
        self.group.epoch().as_u64()
    }

    pub fn members(&self) -> Vec<TrustedDevice> {
        self.group
            .members()
            .map(|member| TrustedDevice {
                identity: member.credential.serialized_content().to_vec(),
                signature_key: member.signature_key,
            })
            .collect()
    }

    pub fn verify_members(&self, roster: &[TrustedDevice]) -> Result<()> {
        verify_roster(&self.group.members().collect::<Vec<_>>(), roster)
    }

    pub fn restore(device: &mut Device, group_id: &[u8]) -> Result<Self> {
        valid_group_id(group_id)?;
        let group = MlsGroup::load(device.provider.storage(), &GroupId::from_slice(group_id))
            .map_err(|_| Error::InvalidState)?
            .ok_or(Error::InvalidState)?;
        let owner = device.trusted_identity();
        let local = group
            .members()
            .find(|member| member.index == group.own_leaf_index())
            .ok_or(Error::InvalidState)?;
        require_trusted(&local.credential, &local.signature_key, &owner)?;
        Ok(Self { group, owner })
    }

    // Состав и полномочия автора должны быть проверены вызывающей стороной.
    // Произвольный участник не становится администратором из-за наличия ключа MLS.
    pub fn apply_commit(
        &mut self,
        device: &mut Device,
        ciphertext: &[u8],
        committer: &TrustedDevice,
        expected_roster: &[TrustedDevice],
    ) -> Result<()> {
        self.require_owner(device)?;
        if ciphertext.len() > MAX_HANDSHAKE_SIZE || self.group.pending_commit().is_some() {
            return Err(Error::InvalidInput);
        }
        let member = self
            .group
            .members()
            .find(|m| m.credential.serialized_content() == committer.identity)
            .ok_or(Error::UntrustedDevice)?;
        require_trusted(&member.credential, &member.signature_key, committer)?;
        let input =
            MlsMessageIn::tls_deserialize_exact(ciphertext).map_err(|_| Error::InvalidInput)?;
        if input.wire_format() != WireFormat::PrivateMessage {
            return Err(Error::UnexpectedMessage);
        }
        let protocol = input
            .try_into_protocol_message()
            .map_err(|_| Error::UnexpectedMessage)?;
        if protocol.content_type() != ContentType::Commit {
            return Err(Error::UnexpectedMessage);
        }
        let candidate = crate::transaction::Candidate::new(&device.provider)?;
        let mut group = MlsGroup::load(candidate.provider().storage(), self.group.group_id())
            .map_err(|_| Error::Mls)?
            .ok_or(Error::Mls)?;
        let processed = group
            .process_message(candidate.provider(), protocol)
            .map_err(|_| Error::Mls)?;
        if processed.credential().serialized_content() != committer.identity {
            return Err(Error::UntrustedDevice);
        }
        let ProcessedMessageContent::StagedCommitMessage(staged) = processed.into_content() else {
            return Err(Error::UnexpectedMessage);
        };
        group
            .merge_staged_commit(candidate.provider(), *staged)
            .map_err(|_| Error::Mls)?;
        verify_roster(&group.members().collect::<Vec<_>>(), expected_roster)?;
        candidate.commit(&device.provider)?;
        self.group = group;
        Ok(())
    }

    fn require_owner(&self, device: &Device) -> Result<()> {
        if self.owner != device.trusted_identity() {
            return Err(Error::UntrustedDevice);
        }
        Ok(())
    }
}

fn valid_group_id(id: &[u8]) -> Result<()> {
    if id.is_empty() || id.len() > 256 {
        return Err(Error::InvalidInput);
    }
    Ok(())
}

fn require_trusted(credential: &Credential, key: &[u8], trusted: &TrustedDevice) -> Result<()> {
    if credential.credential_type() != CredentialType::Basic
        || credential.serialized_content() != trusted.identity
        || key != trusted.signature_key
    {
        return Err(Error::UntrustedDevice);
    }
    Ok(())
}

fn verify_roster(members: &[Member], roster: &[TrustedDevice]) -> Result<()> {
    if members.len() != roster.len() || roster.is_empty() || roster.len() > MAX_GROUP_DEVICES {
        return Err(Error::UntrustedDevice);
    }
    let mut identities = std::collections::HashSet::new();
    let mut keys = std::collections::HashSet::new();
    for trusted in roster {
        if !identities.insert(&trusted.identity) || !keys.insert(&trusted.signature_key) {
            return Err(Error::UntrustedDevice);
        }
    }
    for member in members {
        let trusted = roster
            .iter()
            .find(|trusted| trusted.identity == member.credential.serialized_content())
            .ok_or(Error::UntrustedDevice)?;
        require_trusted(&member.credential, &member.signature_key, trusted)?;
    }
    Ok(())
}
