use openmls::prelude::OpenMlsProvider;
use openmls_rust_crypto::OpenMlsRustCrypto;
use zeroize::Zeroize;

use crate::{Error, Result};

// Только для временного прототипа. Рабочее хранилище получит настоящую
// транзакцию; эксклюзивный &mut Device исключает параллельные операции.
pub(crate) struct Candidate(OpenMlsRustCrypto);

impl Candidate {
    pub fn new(source: &OpenMlsRustCrypto) -> Result<Self> {
        let candidate = Self(OpenMlsRustCrypto::default());
        let values = source.storage().values.read().map_err(|_| Error::Mls)?;
        *candidate
            .0
            .storage()
            .values
            .write()
            .map_err(|_| Error::Mls)? = values.clone();
        Ok(candidate)
    }

    pub fn provider(&self) -> &OpenMlsRustCrypto {
        &self.0
    }

    pub fn commit(&self, target: &OpenMlsRustCrypto) -> Result<()> {
        let values = self.0.storage().values.read().map_err(|_| Error::Mls)?;
        let mut target = target.storage().values.write().map_err(|_| Error::Mls)?;
        for (mut key, mut value) in target.drain() {
            key.zeroize();
            value.zeroize();
        }
        *target = values.clone();
        Ok(())
    }
}

impl Drop for Candidate {
    fn drop(&mut self) {
        if let Ok(mut values) = self.0.storage().values.write() {
            for (mut key, mut value) in values.drain() {
                key.zeroize();
                value.zeroize();
            }
        }
    }
}
