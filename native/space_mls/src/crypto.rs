use ed25519_dalek::{Signer as _, SigningKey};
use openmls_traits::{
    signatures::{Signer, SignerError},
    types::SignatureScheme,
};
use serde::{Deserialize, Serialize};
use zeroize::Zeroizing;

use crate::{Error, Result};

pub(crate) use openmls_libcrux_crypto::Provider;

// Поля сохраняют формат прежнего openmls_basic_credential::SignatureKeyPair.
// Адаптер ограничен Ed25519; криптографические операции выполняет dalek.
#[derive(Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub(crate) struct DeviceSigner {
    private: Zeroizing<Vec<u8>>,
    public: Vec<u8>,
    signature_scheme: SignatureScheme,
}

impl DeviceSigner {
    pub fn generate() -> Result<Self> {
        let mut private = Zeroizing::new(vec![0; 32]);
        getrandom::fill(&mut private).map_err(|_| Error::Mls)?;
        let key = private.as_slice().try_into().map_err(|_| Error::Mls)?;
        let signing = SigningKey::from_bytes(key);
        Ok(Self {
            private,
            public: signing.verifying_key().to_bytes().to_vec(),
            signature_scheme: SignatureScheme::ED25519,
        })
    }

    pub fn to_public_vec(&self) -> Vec<u8> {
        self.public.clone()
    }

    pub fn validate(&self) -> Result<()> {
        self.signing_key().map(drop)
    }

    fn signing_key(&self) -> Result<SigningKey> {
        let key = self
            .private
            .as_slice()
            .try_into()
            .map_err(|_| Error::InvalidState)?;
        let signing = SigningKey::from_bytes(key);
        if self.signature_scheme != SignatureScheme::ED25519
            || signing.verifying_key().as_bytes().as_slice() != self.public
        {
            return Err(Error::InvalidState);
        }
        Ok(signing)
    }
}

impl Signer for DeviceSigner {
    fn sign(&self, payload: &[u8]) -> std::result::Result<Vec<u8>, SignerError> {
        let signing = self.signing_key().map_err(|_| SignerError::SigningError)?;
        Ok(signing.sign(payload).to_bytes().to_vec())
    }

    fn signature_scheme(&self) -> SignatureScheme {
        self.signature_scheme
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use ed25519_dalek::{Signature, VerifyingKey};

    #[test]
    fn serialized_signer_preserves_ed25519_key_and_signature()
    -> std::result::Result<(), Box<dyn std::error::Error>> {
        let signer = DeviceSigner::generate()?;
        let encoded = serde_json::to_vec(&signer)?;
        let restored: DeviceSigner = serde_json::from_slice(&encoded)?;
        restored.validate()?;
        assert_eq!(signer.to_public_vec(), restored.to_public_vec());
        let signature = restored.sign(b"migration").map_err(|_| Error::Mls)?;
        let public: [u8; 32] = restored
            .to_public_vec()
            .try_into()
            .map_err(|_| Error::Mls)?;
        VerifyingKey::from_bytes(&public)?
            .verify_strict(b"migration", &Signature::from_slice(&signature)?)?;
        Ok(())
    }

    #[test]
    fn corrupt_key_or_other_signature_scheme_is_rejected() -> Result<()> {
        let mut signer = DeviceSigner::generate()?;
        signer.public[0] ^= 1;
        assert!(signer.validate().is_err());
        assert!(signer.sign(b"payload").is_err());
        signer.public[0] ^= 1;
        signer.signature_scheme = SignatureScheme::ECDSA_SECP256R1_SHA256;
        assert!(signer.validate().is_err());
        assert!(signer.sign(b"payload").is_err());
        Ok(())
    }
}
