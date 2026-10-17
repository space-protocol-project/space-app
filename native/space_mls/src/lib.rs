//! Экспериментальное клиентское ядро MLS для закрытых каналов Space.

mod attachments;
mod binding;
mod channel;
mod device;
mod state;
mod transaction;

pub use attachments::{FileDescriptor, SealedFile, open_file, seal_file};
pub use binding::{DeviceBinding, SpaceDevice};
pub use channel::{ClosedChannel, Invitation, ReceivedMessage};
pub use device::{Device, TrustedDevice};
use openmls::prelude::Ciphersuite;
use serde::{Deserialize, Serialize};
pub use state::{PendingDelivery, RestoredState};

const SUITE: Ciphersuite = Ciphersuite::MLS_128_DHKEMX25519_AES128GCM_SHA256_Ed25519;
pub const MAX_FILE_SIZE: usize = 20 * 1024 * 1024;
pub const MAX_FILES: usize = 5;
pub const MAX_TEXT_SIZE: usize = 8192;
const MAX_MESSAGE_SIZE: usize = 64 * 1024;
pub const MAX_GROUP_DEVICES: usize = 256;
const MAX_HANDSHAKE_SIZE: usize = 4 * 1024 * 1024;

#[derive(Debug, thiserror::Error, PartialEq, Eq)]
pub enum Error {
    #[error("Некорректные данные или превышен предел размера")]
    InvalidInput,
    #[error("Устройство или состав группы не подтверждены")]
    UntrustedDevice,
    #[error("Ошибка проверки или обработки MLS")]
    Mls,
    #[error("Ожидалось сообщение приложения")]
    UnexpectedMessage,
    #[error("Файл повреждён или относится к другому сообщению")]
    InvalidFile,
    #[error("Состояние повреждено, принадлежит другому устройству или было откачено")]
    InvalidState,
}

pub type Result<T> = std::result::Result<T, Error>;

// Содержимое этого объекта допустимо передавать только внутри MLS ciphertext.
#[derive(Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct Message {
    version: u8,
    pub id: [u8; 16],
    pub text: String,
    pub files: Vec<FileDescriptor>,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub manager: Option<String>,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub reaction: Option<Reaction>,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub reply: Option<Reply>,
}

#[derive(Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct Reply {
    pub message_id: [u8; 16],
    pub grant_id: String,
}

#[derive(Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct Reaction {
    pub message_id: [u8; 16],
    pub grant_id: String,
    pub emoji: String,
    pub active: bool,
}

impl Message {
    pub fn new(id: [u8; 16], text: String, files: Vec<FileDescriptor>) -> Result<Self> {
        let message = Self {
            version: 1,
            id,
            text,
            files,
            manager: None,
            reaction: None,
            reply: None,
        };
        message.validate()?;
        Ok(message)
    }

    fn validate(&self) -> Result<()> {
        if self.version != 1 || self.text.len() > MAX_TEXT_SIZE || self.files.len() > MAX_FILES {
            return Err(Error::InvalidInput);
        }
        if let Some(reply) = &self.reply
            && (self.manager.is_some()
                || self.reaction.is_some()
                || reply.grant_id.is_empty()
                || reply.grant_id.len() > 128
                || !reply.grant_id.is_ascii()
                || reply.grant_id.chars().any(char::is_control))
        {
            return Err(Error::InvalidInput);
        }
        if let Some(reaction) = &self.reaction {
            return if self.manager.is_none()
                && self.text.is_empty()
                && self.files.is_empty()
                && !reaction.grant_id.is_empty()
                && reaction.grant_id.len() <= 128
                && reaction.grant_id.is_ascii()
                && !reaction.grant_id.chars().any(char::is_control)
                && include_str!("emoji.txt")
                    .lines()
                    .any(|emoji| emoji == reaction.emoji)
            {
                Ok(())
            } else {
                Err(Error::InvalidInput)
            };
        }
        if let Some(manager) = &self.manager {
            return if !manager.is_empty()
                && manager.len() <= 128
                && manager.is_ascii()
                && !manager.chars().any(char::is_control)
                && self.text.is_empty()
                && self.files.is_empty()
            {
                Ok(())
            } else {
                Err(Error::InvalidInput)
            };
        }
        if self.text.is_empty() && self.files.is_empty() {
            return Err(Error::InvalidInput);
        }
        for file in &self.files {
            file.validate()?;
            if file.message_id != self.id {
                return Err(Error::InvalidInput);
            }
        }
        for (index, file) in self.files.iter().enumerate() {
            if self.files[..index]
                .iter()
                .any(|previous| previous.id == file.id)
            {
                return Err(Error::InvalidInput);
            }
        }
        Ok(())
    }
}
