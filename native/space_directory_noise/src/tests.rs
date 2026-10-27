// Copyright Space contributors. SPDX-License-Identifier: MIT
use super::*;
use session::Session;

fn pair() -> Result<(Session, Session)> {
    let (mut a, key) = Session::new(true, b"space-test-v1", None)?;
    let (mut b, _) = Session::new(false, b"space-test-v1", Some(key))?;
    b.read_handshake(&a.write_handshake()?)?;
    a.read_handshake(&b.write_handshake()?)?;
    b.read_handshake(&a.write_handshake()?)?;
    assert_eq!(a.sas, b.sas);
    Ok((a, b))
}

fn confirmed() -> Result<(Session, Session)> {
    let (mut a, mut b) = pair()?;
    a.confirm(&a.sas.clone())?;
    b.confirm(&b.sas.clone())?;
    b.receive_confirmation(&a.confirmation()?)?;
    Ok((a, b))
}

#[test]
fn catalogue_roundtrip_and_receipt() -> Result<()> {
    let (mut a, mut b) = confirmed()?;
    let plain = vec![77; session::MAX_PLAIN];
    let frames = b.seal(&plain)?;
    assert_eq!(frames.len(), 71);
    assert_eq!(a.open(&frames)?.as_slice(), plain);
    b.receive_receipt(&a.receipt()?)?;
    assert!(b.seal(b"again").is_err());
    assert!(a.receipt().is_err());
    Ok(())
}

#[test]
fn catalogue_never_released_without_both_confirmations() -> Result<()> {
    let (mut a, mut b) = pair()?;
    assert!(b.seal(b"secret catalogue").is_err());
    b.confirm(&b.sas.clone())?;
    assert!(b.seal(b"secret catalogue").is_err());
    assert!(a.confirmation().is_err());
    assert!(a.confirm("0000-0000-0000-0000-0000").is_err());
    Ok(())
}

#[test]
fn mutation_reordering_truncation_and_replay_fail() -> Result<()> {
    for variant in 0..4 {
        let (mut a, mut b) = confirmed()?;
        let mut frames = b.seal(&vec![1; session::CHUNK + 1])?;
        match variant {
            0 => {
                frames[1][0] ^= 1;
            }
            1 => {
                frames.swap(1, 2);
            }
            2 => {
                frames.pop();
            }
            _ => {
                frames[2] = frames[1].clone();
            }
        }
        assert!(a.open(&frames).is_err());
    }
    Ok(())
}

#[test]
fn prologue_and_qr_static_are_bound() -> Result<()> {
    let (mut a, key) = Session::new(true, b"right context", None)?;
    let (mut b, _) = Session::new(false, b"wrong context", Some(key))?;
    b.read_handshake(&a.write_handshake()?)?;
    assert!(a.read_handshake(&b.write_handshake()?).is_err());
    let (mut a, _) = Session::new(true, b"same context", None)?;
    let (mut b, _) = Session::new(false, b"same context", Some(vec![9; 32]))?;
    b.read_handshake(&a.write_handshake()?)?;
    a.read_handshake(&b.write_handshake()?)?;
    assert!(b.read_handshake(&a.write_handshake()?).is_err());
    Ok(())
}

#[test]
fn invalid_tag_does_not_advance_snow_nonce() -> Result<()> {
    let (mut a, mut b) = confirmed()?;
    let valid = b.encrypt(b"canary")?;
    let mut invalid = valid.clone();
    invalid[0] ^= 1;
    assert!(a.decrypt(&invalid).is_err());
    assert_eq!(a.decrypt(&valid)?.as_slice(), b"canary");
    assert!(a.decrypt(&valid).is_err());
    Ok(())
}

#[test]
fn fresh_attempts_have_distinct_sas() -> Result<()> {
    let (a, _) = pair()?;
    let (b, _) = pair()?;
    assert_ne!(a.sas, b.sas);
    Ok(())
}

#[test]
fn ffi_registry_expires_and_drops_failed_channels() -> Result<()> {
    let created =
        execute(br#"{"op":"create","initiator":true,"context":"bounded","expected":null}"#)?;
    let handle = created["handle"].as_u64().ok_or("handle")?;
    let bad = json!({"op":"confirm","handle":handle,"sas":"bad"}).to_string();
    assert!(execute(bad.as_bytes()).is_err());
    let close = json!({"op":"close","handle":handle}).to_string();
    assert!(execute(close.as_bytes()).is_err());
    let created =
        execute(br#"{"op":"create","initiator":true,"context":"bounded","expected":null}"#)?;
    let handle = created["handle"].as_u64().ok_or("handle")?;
    {
        let mut registry = REGISTRY
            .get()
            .ok_or("registry")?
            .lock()
            .map_err(|_| "registry")?;
        registry.entries.get_mut(&handle).ok_or("entry")?.created =
            Instant::now() - Duration::from_secs(301);
    }
    let request = json!({"op":"write_handshake","handle":handle}).to_string();
    assert_eq!(execute(request.as_bytes()), Err("expired"));
    assert!(execute(br#"{"op":"create","initiator":true,"context":"x","expected":null,"secret":"unexpected"}"#).is_err());
    Ok(())
}
