use openmls::prelude::*;
use openmls_basic_credential::SignatureKeyPair;
use openmls_rust_crypto::OpenMlsRustCrypto;
use tls_codec::Serialize;

use crate::{Error, Result, SUITE};

// Доверие должно быть подтверждено вне сервера доставки, например проверкой QR.
#[derive(Clone, PartialEq, Eq)]
pub struct TrustedDevice {
    pub identity: Vec<u8>,
    pub signature_key: Vec<u8>,
}

pub struct Device {
    pub(crate) provider: OpenMlsRustCrypto,
    pub(crate) signer: SignatureKeyPair,
    pub(crate) credential: CredentialWithKey,
}

impl Device {
    pub fn for_space(scope: &crate::SpaceDevice) -> Result<Self> {
        Self::generate(&scope.identity()?)
    }
    // Пока только временное состояние: дисковое хранение будет отдельным этапом.
    pub fn generate(identity: &[u8]) -> Result<Self> {
        if identity.is_empty() || identity.len() > 1024 {
            return Err(Error::InvalidInput);
        }
        let signer = SignatureKeyPair::new(SUITE.signature_algorithm()).map_err(|_| Error::Mls)?;
        let credential = CredentialWithKey {
            credential: BasicCredential::new(identity.to_vec()).into(),
            signature_key: signer.to_public_vec().into(),
        };
        Ok(Self {
            provider: OpenMlsRustCrypto::default(),
            signer,
            credential,
        })
    }

    pub fn trusted_identity(&self) -> TrustedDevice {
        TrustedDevice {
            identity: self.credential.credential.serialized_content().to_vec(),
            signature_key: self.signer.to_public_vec(),
        }
    }

    pub fn key_package(&mut self) -> Result<Vec<u8>> {
        let bundle = KeyPackage::builder()
            .build(SUITE, &self.provider, &self.signer, self.credential.clone())
            .map_err(|_| Error::Mls)?;
        bundle
            .key_package()
            .tls_serialize_detached()
            .map_err(|_| Error::Mls)
    }
}
