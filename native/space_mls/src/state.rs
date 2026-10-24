use chacha20poly1305::{
    XChaCha20Poly1305,
    aead::{Aead, KeyInit, Payload},
};
use openmls::prelude::*;
use serde::{Deserialize, Serialize};
use zeroize::{Zeroize, Zeroizing};

use crate::{
    Device, DeviceBinding, Error, Result, SpaceDevice,
    crypto::{DeviceSigner, Provider},
};

const MAX_STATE_SIZE: usize = 64 * 1024 * 1024;
// Это идентификатор сохранённого формата, а не текущая версия библиотеки.
const STATE_FORMAT: &str = "space/mls/state/openmls-0.9.1/v1";

#[derive(Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct PendingDelivery {
    pub id: [u8; 16],
    pub group_id: Vec<u8>,
    pub epoch: u64,
    pub ciphertext: Vec<u8>,
}

pub struct RestoredState {
    pub device: Device,
    pub pending: Vec<PendingDelivery>,
}

#[derive(Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
struct StoredState {
    format: String,
    credential: CredentialWithKey,
    signer: DeviceSigner,
    entries: Vec<(Vec<u8>, Vec<u8>)>,
    pending: Vec<PendingDelivery>,
}

impl Drop for StoredState {
    fn drop(&mut self) {
        for (key, value) in &mut self.entries {
            key.zeroize();
            value.zeroize();
        }
    }
}

impl Device {
    // Сохранять snapshot и revision нужно одной атомарной записью хранилища ОС.
    // expected_revision при чтении берётся из доверенного локального checkpoint.
    pub fn seal_state(
        &self,
        binding: &DeviceBinding,
        key: &[u8; 32],
        revision: u64,
        pending: &[PendingDelivery],
    ) -> Result<Vec<u8>> {
        let trusted = binding.verify(&binding.device)?;
        if trusted != self.trusted_identity() {
            return Err(Error::UntrustedDevice);
        }
        validate_pending(pending)?;
        let values = self
            .provider
            .storage()
            .values
            .read()
            .map_err(|_| Error::InvalidState)?;
        let entries: Vec<_> = values.iter().collect();
        let plaintext = Zeroizing::new(
            serde_json::to_vec(&(
                STATE_FORMAT,
                &self.credential,
                &self.signer,
                entries,
                pending,
            ))
            .map_err(|_| Error::InvalidState)?,
        );
        if plaintext.len() > MAX_STATE_SIZE {
            return Err(Error::InvalidState);
        }
        let mut nonce = [0u8; 24];
        getrandom::fill(&mut nonce).map_err(|_| Error::InvalidState)?;
        let aad = state_aad(binding, revision)?;
        let ciphertext = XChaCha20Poly1305::new(key.into())
            .encrypt(
                (&nonce).into(),
                Payload {
                    msg: &plaintext,
                    aad: &aad,
                },
            )
            .map_err(|_| Error::InvalidState)?;
        let mut result = nonce.to_vec();
        result.extend(ciphertext);
        Ok(result)
    }

    pub fn open_state(
        binding: &DeviceBinding,
        verified_device: &SpaceDevice,
        key: &[u8; 32],
        expected_revision: u64,
        snapshot: &[u8],
    ) -> Result<RestoredState> {
        let trusted = binding.verify(verified_device)?;
        if snapshot.len() < 40 || snapshot.len() > MAX_STATE_SIZE + 40 {
            return Err(Error::InvalidState);
        }
        let aad = state_aad(binding, expected_revision)?;
        let nonce: &[u8; 24] = snapshot[..24].try_into().map_err(|_| Error::InvalidState)?;
        let plaintext = Zeroizing::new(
            XChaCha20Poly1305::new(key.into())
                .decrypt(
                    nonce.into(),
                    Payload {
                        msg: &snapshot[24..],
                        aad: &aad,
                    },
                )
                .map_err(|_| Error::InvalidState)?,
        );
        // Кортеж исключает зависимость формата хранения от порядка полей JSON.
        let (format, credential, signer, entries, pending) =
            serde_json::from_slice(&plaintext).map_err(|_| Error::InvalidState)?;
        let mut stored = StoredState {
            format,
            credential,
            signer,
            entries,
            pending,
        };
        validate_stored(&stored, &trusted)?;
        let provider = Provider::new().map_err(|_| Error::InvalidState)?;
        let mut values = provider
            .storage()
            .values
            .write()
            .map_err(|_| Error::InvalidState)?;
        for (key, value) in stored.entries.drain(..) {
            if values.insert(key, value).is_some() {
                return Err(Error::InvalidState);
            }
        }
        drop(values);
        // Секретный ключ переносим через защищённое сериализованное представление.
        let signer_bytes =
            Zeroizing::new(serde_json::to_vec(&stored.signer).map_err(|_| Error::InvalidState)?);
        let signer = serde_json::from_slice(&signer_bytes).map_err(|_| Error::InvalidState)?;
        let device = Device {
            provider,
            signer,
            credential: stored.credential.clone(),
        };
        Ok(RestoredState {
            device,
            pending: std::mem::take(&mut stored.pending),
        })
    }
}

fn state_aad(binding: &DeviceBinding, revision: u64) -> Result<Vec<u8>> {
    serde_json::to_vec(&("space/mls/state/v1", binding, revision)).map_err(|_| Error::InvalidState)
}

fn validate_stored(stored: &StoredState, trusted: &crate::TrustedDevice) -> Result<()> {
    stored.signer.validate()?;
    if stored.format != STATE_FORMAT
        || stored.entries.len() > 65536
        || stored.credential.credential.serialized_content() != trusted.identity
        || stored.credential.signature_key.as_slice() != trusted.signature_key
        || stored.signer.to_public_vec() != trusted.signature_key
    {
        return Err(Error::InvalidState);
    }
    validate_pending(&stored.pending)
}

fn validate_pending(pending: &[PendingDelivery]) -> Result<()> {
    if pending.len() > 1000 {
        return Err(Error::InvalidState);
    }
    let mut ids = std::collections::HashSet::new();
    for item in pending {
        if item.group_id.is_empty()
            || item.group_id.len() > 256
            || item.ciphertext.len() > crate::MAX_HANDSHAKE_SIZE
            || item.ciphertext.is_empty()
            || !ids.insert(item.id)
        {
            return Err(Error::InvalidState);
        }
    }
    Ok(())
}
