use ed25519_dalek::{Signature, Signer, SigningKey, VerifyingKey};
use serde::{Deserialize, Serialize};

use crate::{Device, Error, Result, TrustedDevice};

// Ключ должен быть получен из проверенного root/device grant, а не из имени.
#[derive(Clone, PartialEq, Eq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct SpaceDevice {
    pub server_id: String,
    pub principal_id: String,
    pub grant_id: String,
    pub public_key: [u8; 32],
}

impl SpaceDevice {
    pub fn identity(&self) -> Result<Vec<u8>> {
        for value in [&self.server_id, &self.principal_id, &self.grant_id] {
            if value.is_empty()
                || value.len() > 128
                || !value.is_ascii()
                || value.chars().any(char::is_control)
            {
                return Err(Error::InvalidInput);
            }
        }
        serde_json::to_vec(&("space/mls/device/v1", self)).map_err(|_| Error::InvalidInput)
    }
}

#[derive(Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct DeviceBinding {
    pub device: SpaceDevice,
    pub mls_public_key: [u8; 32],
    pub signature: Vec<u8>,
}

impl DeviceBinding {
    pub fn sign(device: &Device, scope: SpaceDevice, space_device_seed: &[u8; 32]) -> Result<Self> {
        if device.trusted_identity().identity != scope.identity()? {
            return Err(Error::UntrustedDevice);
        }
        let signing = SigningKey::from_bytes(space_device_seed);
        if signing.verifying_key().to_bytes() != scope.public_key {
            return Err(Error::UntrustedDevice);
        }
        let mut binding = Self {
            device: scope,
            mls_public_key: device
                .signer
                .to_public_vec()
                .try_into()
                .map_err(|_| Error::Mls)?,
            signature: Vec::new(),
        };
        binding.signature = signing.sign(&binding.signing_bytes()?).to_bytes().to_vec();
        Ok(binding)
    }

    pub fn verify(&self, verified_device: &SpaceDevice) -> Result<TrustedDevice> {
        if &self.device != verified_device {
            return Err(Error::UntrustedDevice);
        }
        let identity = self.device.identity()?;
        let signature =
            Signature::from_slice(&self.signature).map_err(|_| Error::UntrustedDevice)?;
        VerifyingKey::from_bytes(&verified_device.public_key)
            .map_err(|_| Error::UntrustedDevice)?
            .verify_strict(&self.signing_bytes()?, &signature)
            .map_err(|_| Error::UntrustedDevice)?;
        Ok(TrustedDevice {
            identity,
            signature_key: self.mls_public_key.to_vec(),
        })
    }

    fn signing_bytes(&self) -> Result<Vec<u8>> {
        serde_json::to_vec(&("space/mls/binding/v1", &self.device, self.mls_public_key))
            .map_err(|_| Error::InvalidInput)
    }
}
