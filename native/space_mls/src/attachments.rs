use chacha20poly1305::{
    XChaCha20Poly1305, XNonce,
    aead::{Aead, KeyInit, OsRng, Payload, rand_core::RngCore},
};
use serde::{Deserialize, Serialize};
use zeroize::{Zeroize, ZeroizeOnDrop};

use crate::{Error, MAX_FILE_SIZE, Result};

// Не реализует Debug; ключ стирается при освобождении дескриптора.
#[derive(Serialize, Deserialize, Zeroize, ZeroizeOnDrop)]
#[serde(deny_unknown_fields)]
pub struct FileDescriptor {
    pub id: [u8; 16],
    pub message_id: [u8; 16],
    pub name: String,
    pub size: usize,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub asset_id: Option<String>,
    key: [u8; 32],
    nonce: [u8; 24],
}

pub struct SealedFile {
    // Для загрузки серверу используется только ciphertext, без дескриптора.
    pub ciphertext: Vec<u8>,
    pub descriptor: FileDescriptor,
}

impl FileDescriptor {
    pub(crate) fn validate(&self) -> Result<()> {
        if self.size == 0
            || self.size > MAX_FILE_SIZE
            || self.name.is_empty()
            || self.name.len() > 255
        {
            return Err(Error::InvalidInput);
        }
        if self
            .name
            .chars()
            .any(|c| c.is_control() || c == '/' || c == '\\')
        {
            return Err(Error::InvalidInput);
        }
        Ok(())
    }

    fn aad(&self, group_id: &[u8]) -> Result<Vec<u8>> {
        serde_json::to_vec(&(
            "space/mls/file/v1",
            group_id,
            self.message_id,
            self.id,
            &self.name,
            self.size,
        ))
        .map_err(|_| Error::InvalidInput)
    }
}

pub fn seal_file(
    group_id: &[u8],
    message_id: [u8; 16],
    name: String,
    plaintext: &[u8],
) -> Result<SealedFile> {
    let mut descriptor = FileDescriptor {
        id: [0; 16],
        message_id,
        name,
        size: plaintext.len(),
        asset_id: None,
        key: [0; 32],
        nonce: [0; 24],
    };
    descriptor.validate()?;
    validate_group(group_id)?;
    OsRng
        .try_fill_bytes(&mut descriptor.id)
        .map_err(|_| Error::InvalidFile)?;
    OsRng
        .try_fill_bytes(&mut descriptor.key)
        .map_err(|_| Error::InvalidFile)?;
    OsRng
        .try_fill_bytes(&mut descriptor.nonce)
        .map_err(|_| Error::InvalidFile)?;
    let aad = descriptor.aad(group_id)?;
    let cipher = XChaCha20Poly1305::new((&descriptor.key).into());
    let ciphertext = cipher
        .encrypt(
            XNonce::from_slice(&descriptor.nonce),
            Payload {
                msg: plaintext,
                aad: &aad,
            },
        )
        .map_err(|_| Error::InvalidFile)?;
    Ok(SealedFile {
        ciphertext,
        descriptor,
    })
}

pub fn open_file(
    group_id: &[u8],
    message_id: [u8; 16],
    descriptor: &FileDescriptor,
    ciphertext: &[u8],
) -> Result<Vec<u8>> {
    descriptor.validate()?;
    validate_group(group_id)?;
    if descriptor.message_id != message_id || ciphertext.len() != descriptor.size + 16 {
        return Err(Error::InvalidFile);
    }
    let aad = descriptor.aad(group_id)?;
    let cipher = XChaCha20Poly1305::new((&descriptor.key).into());
    cipher
        .decrypt(
            XNonce::from_slice(&descriptor.nonce),
            Payload {
                msg: ciphertext,
                aad: &aad,
            },
        )
        .map_err(|_| Error::InvalidFile)
}

fn validate_group(group_id: &[u8]) -> Result<()> {
    if group_id.is_empty() || group_id.len() > 256 {
        return Err(Error::InvalidInput);
    }
    Ok(())
}
