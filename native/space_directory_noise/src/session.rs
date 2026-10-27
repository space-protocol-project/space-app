use snow::{Builder, HandshakeState, TransportState};
use subtle::ConstantTimeEq;
use zeroize::Zeroizing;

pub const PROFILE: &str = "Noise_XX_25519_ChaChaPoly_SHA256";
pub type Result<T> = std::result::Result<T, &'static str>;
pub const MAX_PLAIN: usize = 4 * 1024 * 1024;
pub const CHUNK: usize = 60 * 1024;
const CONFIRM: &[u8] = b"space/directory/confirm/v1\0";
const RECEIPT: &[u8] = b"space/directory/received/v1\0";

pub struct Session {
    handshake: Option<HandshakeState>,
    transport: Option<TransportState>,
    pub initiator: bool,
    expected: Option<Vec<u8>>,
    hash: Vec<u8>,
    pub sas: String,
    approved: bool,
    peer_confirmed: bool,
    released: bool,
    received: bool,
    receipt_sent: bool,
}

impl Session {
    pub fn new(
        initiator: bool,
        context: &[u8],
        expected: Option<Vec<u8>>,
    ) -> Result<(Self, Vec<u8>)> {
        if context.is_empty()
            || context.len() > 4096
            || (!initiator && expected.as_ref().is_none_or(|k| k.len() != 32))
        {
            return Err("context");
        }
        let params = PROFILE.parse().map_err(|_| "profile")?;
        let builder = Builder::new(params);
        let keys = builder.generate_keypair().map_err(|_| "keyGeneration")?;
        let secret = Zeroizing::new(keys.private);
        let builder = builder
            .local_private_key(&secret)
            .map_err(|_| "key")?
            .prologue(context)
            .map_err(|_| "context")?;
        let handshake = if initiator {
            builder.build_initiator()
        } else {
            builder.build_responder()
        }
        .map_err(|_| "handshake")?;
        Ok((
            Self {
                handshake: Some(handshake),
                transport: None,
                initiator,
                expected,
                hash: Vec::new(),
                sas: String::new(),
                approved: false,
                peer_confirmed: false,
                released: false,
                received: false,
                receipt_sent: false,
            },
            keys.public,
        ))
    }

    fn ready(&mut self) -> Result<()> {
        let Some(handshake) = self.handshake.as_ref() else {
            return Ok(());
        };
        if !handshake.is_handshake_finished() {
            return Ok(());
        }
        if let Some(expected) = &self.expected {
            let remote = handshake.get_remote_static().ok_or("peer")?;
            if !bool::from(remote.ct_eq(expected)) {
                return Err("peer");
            }
        }
        self.hash = handshake.get_handshake_hash().to_vec();
        let digits: String = self.hash[..10].iter().map(|v| format!("{v:02X}")).collect();
        self.sas = digits
            .as_bytes()
            .chunks(4)
            .map(|p| String::from_utf8_lossy(p).into_owned())
            .collect::<Vec<_>>()
            .join("-");
        self.transport = Some(
            self.handshake
                .take()
                .ok_or("state")?
                .into_transport_mode()
                .map_err(|_| "transport")?,
        );
        Ok(())
    }

    pub fn write_handshake(&mut self) -> Result<Vec<u8>> {
        let mut out = vec![0; 512];
        let size = self
            .handshake
            .as_mut()
            .ok_or("state")?
            .write_message(&[], &mut out)
            .map_err(|_| "handshake")?;
        out.truncate(size);
        self.ready()?;
        Ok(out)
    }

    pub fn read_handshake(&mut self, message: &[u8]) -> Result<()> {
        if message.is_empty() || message.len() > 512 {
            return Err("handshakeLength");
        }
        let mut plain = Zeroizing::new(vec![0; 512]);
        let size = self
            .handshake
            .as_mut()
            .ok_or("state")?
            .read_message(message, &mut plain)
            .map_err(|_| "handshake")?;
        if size != 0 {
            return Err("handshakePayload");
        }
        self.ready()
    }

    pub fn confirm(&mut self, entered: &str) -> Result<()> {
        if self.transport.is_none() || self.approved || entered.len() > 100 {
            return Err("state");
        }
        let expected = self.sas.replace('-', "");
        let normalized: String = entered
            .chars()
            .filter(|c| !c.is_whitespace() && *c != '-')
            .flat_map(char::to_uppercase)
            .collect();
        if !bool::from(expected.as_bytes().ct_eq(normalized.as_bytes())) {
            return Err("sas");
        }
        self.approved = true;
        Ok(())
    }

    fn marker(&self, prefix: &[u8]) -> Vec<u8> {
        [prefix, self.hash.as_slice()].concat()
    }

    pub fn confirmation(&mut self) -> Result<Vec<u8>> {
        if !self.initiator || !self.approved || self.released {
            return Err("confirmation");
        }
        self.released = true;
        self.encrypt(&self.marker(CONFIRM))
    }

    pub fn receive_confirmation(&mut self, data: &[u8]) -> Result<()> {
        if self.initiator || !self.approved || self.peer_confirmed {
            return Err("confirmation");
        }
        if !bool::from(self.decrypt(data)?.ct_eq(&self.marker(CONFIRM))) {
            return Err("confirmation");
        }
        self.peer_confirmed = true;
        Ok(())
    }

    pub fn encrypt(&mut self, data: &[u8]) -> Result<Vec<u8>> {
        if data.len() > CHUNK {
            return Err("length");
        }
        let mut out = vec![0; data.len() + 16];
        let size = self
            .transport
            .as_mut()
            .ok_or("state")?
            .write_message(data, &mut out)
            .map_err(|_| "authentication")?;
        out.truncate(size);
        Ok(out)
    }

    pub fn decrypt(&mut self, data: &[u8]) -> Result<Zeroizing<Vec<u8>>> {
        if data.len() < 16 || data.len() > CHUNK + 16 {
            return Err("length");
        }
        let mut out = Zeroizing::new(vec![0; data.len()]);
        let size = self
            .transport
            .as_mut()
            .ok_or("state")?
            .read_message(data, &mut out)
            .map_err(|_| "authentication")?;
        out.truncate(size);
        Ok(out)
    }

    pub fn seal(&mut self, plain: &[u8]) -> Result<Vec<Vec<u8>>> {
        if self.initiator || !self.approved || !self.peer_confirmed || self.released {
            return Err("confirmation");
        }
        if plain.is_empty() || plain.len() > MAX_PLAIN {
            return Err("length");
        }
        self.released = true;
        let header = [
            b"space/directory/data/v1\0".as_slice(),
            &(plain.len() as u32).to_be_bytes(),
        ]
        .concat();
        let mut frames = vec![self.encrypt(&header)?];
        for chunk in plain.chunks(CHUNK) {
            frames.push(self.encrypt(chunk)?)
        }
        let end = [
            b"space/directory/end/v1\0".as_slice(),
            &(plain.len() as u32).to_be_bytes(),
        ]
        .concat();
        frames.push(self.encrypt(&end)?);
        Ok(frames)
    }

    pub fn open(&mut self, frames: &[Vec<u8>]) -> Result<Zeroizing<Vec<u8>>> {
        if !self.initiator || !self.approved || !self.released || self.received {
            return Err("confirmation");
        }
        if frames.len() < 3 || frames.len() > 71 {
            return Err("length");
        }
        let header = self.decrypt(&frames[0])?;
        let prefix = b"space/directory/data/v1\0";
        if header.len() != prefix.len() + 4 || !header.starts_with(prefix) {
            return Err("header");
        }
        let count =
            u32::from_be_bytes(header[prefix.len()..].try_into().map_err(|_| "header")?) as usize;
        if count == 0 || count > MAX_PLAIN || frames.len() != count.div_ceil(CHUNK) + 2 {
            return Err("length");
        }
        let mut plain = Zeroizing::new(Vec::with_capacity(count));
        for frame in &frames[1..frames.len() - 1] {
            let chunk = self.decrypt(frame)?;
            if chunk.len() != std::cmp::min(CHUNK, count - plain.len()) {
                return Err("length");
            }
            plain.extend_from_slice(&chunk);
        }
        let end = self.decrypt(&frames[frames.len() - 1])?;
        let expected = [
            b"space/directory/end/v1\0".as_slice(),
            &(count as u32).to_be_bytes(),
        ]
        .concat();
        if plain.len() != count || !bool::from(end.ct_eq(&expected)) {
            return Err("length");
        }
        self.received = true;
        Ok(plain)
    }

    pub fn receipt(&mut self) -> Result<Vec<u8>> {
        if !self.initiator || !self.received || self.receipt_sent {
            return Err("receipt");
        }
        self.receipt_sent = true;
        self.encrypt(&self.marker(RECEIPT))
    }

    pub fn receive_receipt(&mut self, data: &[u8]) -> Result<()> {
        if self.initiator || !self.released || self.received {
            return Err("receipt");
        }
        if !bool::from(self.decrypt(data)?.ct_eq(&self.marker(RECEIPT))) {
            return Err("receipt");
        }
        self.received = true;
        Ok(())
    }
}
