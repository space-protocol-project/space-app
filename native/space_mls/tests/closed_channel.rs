use space_mls::{ClosedChannel, Device, Error, MAX_FILE_SIZE, Message, open_file, seal_file};

type TestResult = Result<(), Box<dyn std::error::Error>>;
const GROUP: &[u8] = b"space-test-server/private-channel";
const MESSAGE: [u8; 16] = [7; 16];

struct Pair {
    alice: Device,
    bob: Device,
    sender: ClosedChannel,
    receiver: ClosedChannel,
}

impl Pair {
    fn new() -> Result<Self, Error> {
        let mut alice = Device::generate(b"principal-alice/device-desktop")?;
        let mut bob = Device::generate(b"principal-bob/device-phone")?;
        let mut sender = ClosedChannel::create(&mut alice, GROUP)?;
        let invite = sender.invite(&mut alice, &bob.key_package()?, &bob.trusted_identity())?;
        sender.confirm_commit(&mut alice)?;
        let roster = [alice.trusted_identity(), bob.trusted_identity()];
        let receiver = ClosedChannel::join(&mut bob, GROUP, &invite.welcome, &roster)?;
        Ok(Self {
            alice,
            bob,
            sender,
            receiver,
        })
    }
}

fn text(value: &str) -> Result<Message, Error> {
    Message::new(MESSAGE, value.to_owned(), vec![])
}

fn contains(haystack: &[u8], needle: &[u8]) -> bool {
    haystack
        .windows(needle.len())
        .any(|window| window == needle)
}

#[test]
fn two_devices_exchange_private_messages() -> TestResult {
    let mut pair = Pair::new()?;
    let ciphertext = pair
        .sender
        .encrypt(&mut pair.alice, &text("Секретное сообщение 秘密")?)?;
    assert!(!contains(&ciphertext, "Секретное сообщение".as_bytes()));
    let received = pair.receiver.decrypt(&mut pair.bob, &ciphertext)?;
    assert_eq!(received.sender, pair.alice.trusted_identity().identity);
    assert_eq!(received.message.text, "Секретное сообщение 秘密");
    let reply = pair.receiver.encrypt(&mut pair.bob, &text("Ответ")?)?;
    assert_eq!(
        pair.sender.decrypt(&mut pair.alice, &reply)?.message.text,
        "Ответ"
    );
    Ok(())
}

#[test]
fn reply_reference_is_authenticated_inside_ciphertext() -> TestResult {
    let mut pair = Pair::new()?;
    let mut message = text("Ответ с зашифрованной ссылкой")?;
    message.reply = Some(space_mls::Reply {
        message_id: [9; 16],
        grant_id: "original-device-grant".into(),
    });
    let ciphertext = pair.sender.encrypt(&mut pair.alice, &message)?;
    assert!(!contains(&ciphertext, b"original-device-grant"));
    let mut tampered = ciphertext.clone();
    let last = tampered.len() - 1;
    tampered[last] ^= 1;
    assert!(pair.receiver.decrypt(&mut pair.bob, &tampered).is_err());
    let received = pair.receiver.decrypt(&mut pair.bob, &ciphertext)?;
    let reference = received.message.reply.ok_or("Отсутствует ссылка ответа")?;
    assert_eq!(reference.message_id, [9; 16]);
    assert_eq!(reference.grant_id, "original-device-grant");
    Ok(())
}

#[test]
fn reply_cannot_be_disguised_as_control_message() -> TestResult {
    let mut pair = Pair::new()?;
    for grant in ["", "bad\ngrant", "не-ascii"] {
        let mut message = text("Ответ")?;
        message.reply = Some(space_mls::Reply {
            message_id: [9; 16],
            grant_id: grant.into(),
        });
        assert!(pair.sender.encrypt(&mut pair.alice, &message).is_err());
    }
    let mut message = text("Ответ")?;
    message.reply = Some(space_mls::Reply {
        message_id: [9; 16],
        grant_id: "grant".into(),
    });
    message.manager = Some("grant".into());
    assert!(pair.sender.encrypt(&mut pair.alice, &message).is_err());
    message.manager = None;
    message.text.clear();
    message.reaction = Some(space_mls::Reaction {
        message_id: [9; 16],
        grant_id: "grant".into(),
        emoji: "👍".into(),
        active: true,
    });
    assert!(pair.sender.encrypt(&mut pair.alice, &message).is_err());
    Ok(())
}

#[test]
fn encrypted_file_crosses_mls_without_exposing_name_or_key() -> TestResult {
    let mut pair = Pair::new()?;
    let bytes = vec![0x42; 256 * 1024 + 31];
    let sealed = seal_file(GROUP, MESSAGE, "личный-документ.txt".into(), &bytes)?;
    assert_eq!(sealed.ciphertext.len(), bytes.len() + 16);
    assert!(!contains(&sealed.ciphertext, b"BBBBBBBBBBBBBBBB"));
    let message = Message::new(MESSAGE, String::new(), vec![sealed.descriptor])?;
    let envelope = pair.sender.encrypt(&mut pair.alice, &message)?;
    assert!(!contains(&envelope, "личный-документ.txt".as_bytes()));
    let received = pair.receiver.decrypt(&mut pair.bob, &envelope)?;
    let file = &received.message.files[0];
    assert_eq!(file.name, "личный-документ.txt");
    assert_eq!(
        open_file(GROUP, received.message.id, file, &sealed.ciphertext)?,
        bytes
    );
    Ok(())
}

#[test]
fn replay_is_rejected() -> TestResult {
    let mut pair = Pair::new()?;
    let ciphertext = pair.sender.encrypt(&mut pair.alice, &text("Один раз")?)?;
    pair.receiver.decrypt(&mut pair.bob, &ciphertext)?;
    assert!(pair.receiver.decrypt(&mut pair.bob, &ciphertext).is_err());
    Ok(())
}

#[test]
fn tampered_message_is_rejected_without_losing_original() -> TestResult {
    let mut pair = Pair::new()?;
    let ciphertext = pair
        .sender
        .encrypt(&mut pair.alice, &text("Подлинное сообщение")?)?;
    let mut tampered = ciphertext.clone();
    let last = tampered.len() - 1;
    tampered[last] ^= 1;
    assert!(pair.receiver.decrypt(&mut pair.bob, &tampered).is_err());
    assert_eq!(
        pair.receiver
            .decrypt(&mut pair.bob, &ciphertext)?
            .message
            .text,
        "Подлинное сообщение"
    );
    Ok(())
}

#[test]
fn another_group_cannot_decrypt_message() -> TestResult {
    let mut pair = Pair::new()?;
    let mut outsider = Device::generate(b"another-device")?;
    let mut other = ClosedChannel::create(&mut outsider, b"other-channel")?;
    let ciphertext = pair.sender.encrypt(&mut pair.alice, &text("Закрыто")?)?;
    assert!(other.decrypt(&mut outsider, &ciphertext).is_err());
    Ok(())
}

#[test]
fn substituted_device_key_is_rejected() -> TestResult {
    let mut alice = Device::generate(b"alice")?;
    let mut bob = Device::generate(b"bob")?;
    let mut imposter = Device::generate(b"bob")?;
    let mut channel = ClosedChannel::create(&mut alice, GROUP)?;
    assert!(matches!(
        channel.invite(
            &mut alice,
            &imposter.key_package()?,
            &bob.trusted_identity()
        ),
        Err(Error::UntrustedDevice)
    ));
    channel.invite(&mut alice, &bob.key_package()?, &bob.trusted_identity())?;
    Ok(())
}

#[test]
fn welcome_checks_inviter_key_and_channel_id() -> TestResult {
    for wrong_group in [false, true] {
        let mut alice = Device::generate(b"alice")?;
        let mut bob = Device::generate(b"bob")?;
        let imposter = Device::generate(b"alice")?;
        let mut channel = ClosedChannel::create(&mut alice, GROUP)?;
        let invitation =
            channel.invite(&mut alice, &bob.key_package()?, &bob.trusted_identity())?;
        let inviter = if wrong_group {
            alice.trusted_identity()
        } else {
            imposter.trusted_identity()
        };
        let roster = [inviter, bob.trusted_identity()];
        let group = if wrong_group {
            b"different-channel".as_slice()
        } else {
            GROUP
        };
        assert!(matches!(
            ClosedChannel::join(&mut bob, group, &invitation.welcome, &roster),
            Err(Error::UntrustedDevice)
        ));
        let correct_roster = [alice.trusted_identity(), bob.trusted_identity()];
        ClosedChannel::join(&mut bob, GROUP, &invitation.welcome, &correct_roster)?;
    }
    Ok(())
}

#[test]
fn wrong_local_device_cannot_use_channel_state() -> TestResult {
    let mut pair = Pair::new()?;
    assert!(matches!(
        pair.sender.encrypt(&mut pair.bob, &text("Подмена")?),
        Err(Error::UntrustedDevice)
    ));
    let ciphertext = pair
        .sender
        .encrypt(&mut pair.alice, &text("Подлинный автор")?)?;
    assert!(matches!(
        pair.receiver.decrypt(&mut pair.alice, &ciphertext),
        Err(Error::UntrustedDevice)
    ));
    pair.receiver.decrypt(&mut pair.bob, &ciphertext)?;
    Ok(())
}

#[test]
fn excluded_device_cannot_read_next_epoch() -> TestResult {
    let mut pair = Pair::new()?;
    let _commit = pair
        .sender
        .remove(&mut pair.alice, &pair.bob.trusted_identity())?;
    pair.sender.confirm_commit(&mut pair.alice)?;
    let ciphertext = pair
        .sender
        .encrypt(&mut pair.alice, &text("После исключения")?)?;
    assert!(pair.receiver.decrypt(&mut pair.bob, &ciphertext).is_err());
    Ok(())
}

#[test]
fn pending_membership_commit_blocks_sending() -> TestResult {
    let mut alice = Device::generate(b"alice")?;
    let mut bob = Device::generate(b"bob")?;
    let mut channel = ClosedChannel::create(&mut alice, GROUP)?;
    channel.invite(&mut alice, &bob.key_package()?, &bob.trusted_identity())?;
    assert!(channel.encrypt(&mut alice, &text("Слишком рано")?).is_err());
    channel.confirm_commit(&mut alice)?;
    assert!(
        channel
            .encrypt(&mut alice, &text("После подтверждения")?)
            .is_ok()
    );
    Ok(())
}

#[test]
fn file_authentication_binds_channel_message_and_metadata() -> TestResult {
    let mut file = seal_file(
        GROUP,
        MESSAGE,
        "report.txt".into(),
        b"private file contents",
    )?;
    assert!(
        open_file(
            b"other-channel",
            MESSAGE,
            &file.descriptor,
            &file.ciphertext
        )
        .is_err()
    );
    assert!(open_file(GROUP, [8; 16], &file.descriptor, &file.ciphertext).is_err());
    file.descriptor.name = "other.txt".into();
    assert!(open_file(GROUP, MESSAGE, &file.descriptor, &file.ciphertext).is_err());
    file.descriptor.name = "report.txt".into();
    file.ciphertext[0] ^= 1;
    assert!(open_file(GROUP, MESSAGE, &file.descriptor, &file.ciphertext).is_err());
    file.ciphertext[0] ^= 1;
    file.ciphertext.pop();
    assert!(open_file(GROUP, MESSAGE, &file.descriptor, &file.ciphertext).is_err());
    Ok(())
}

#[test]
fn limits_and_unsafe_names_are_rejected() -> TestResult {
    assert!(Device::generate(b"").is_err());
    assert!(Message::new(MESSAGE, String::new(), vec![]).is_err());
    assert!(text(&"a".repeat(8193)).is_err());
    for name in ["", "../private", "a\\b", "a\nb"] {
        assert!(seal_file(GROUP, MESSAGE, name.into(), b"file").is_err());
    }
    assert!(seal_file(GROUP, MESSAGE, "empty".into(), b"").is_err());
    assert!(
        seal_file(
            GROUP,
            MESSAGE,
            "too-large".into(),
            &vec![0; MAX_FILE_SIZE + 1]
        )
        .is_err()
    );
    let file = seal_file(GROUP, [9; 16], "a.txt".into(), b"file")?;
    assert!(Message::new(MESSAGE, String::new(), vec![file.descriptor]).is_err());
    Ok(())
}

#[test]
fn independent_uploads_have_distinct_keys_and_ciphertexts() -> TestResult {
    let first = seal_file(GROUP, MESSAGE, "a.txt".into(), b"same contents")?;
    let second = seal_file(GROUP, MESSAGE, "a.txt".into(), b"same contents")?;
    assert_ne!(first.descriptor.id, second.descriptor.id);
    assert_ne!(first.ciphertext, second.ciphertext);
    assert!(open_file(GROUP, MESSAGE, &first.descriptor, &second.ciphertext).is_err());
    Ok(())
}

#[test]
fn malformed_and_trailing_data_do_not_damage_receive_state() -> TestResult {
    let mut pair = Pair::new()?;
    let ciphertext = pair
        .sender
        .encrypt(&mut pair.alice, &text("Принять после ошибок")?)?;
    for invalid in [&[][..], &[0, 1, 2][..], &vec![0; 65537][..]] {
        assert!(pair.receiver.decrypt(&mut pair.bob, invalid).is_err());
    }
    let mut trailing = ciphertext.clone();
    trailing.push(0);
    assert!(pair.receiver.decrypt(&mut pair.bob, &trailing).is_err());
    pair.receiver.decrypt(&mut pair.bob, &ciphertext)?;
    Ok(())
}

#[test]
fn five_files_are_allowed_but_six_are_not() -> TestResult {
    for count in [5, 6] {
        let files = (0..count)
            .map(|_| seal_file(GROUP, MESSAGE, "a.txt".into(), b"contents").map(|f| f.descriptor))
            .collect::<Result<Vec<_>, _>>()?;
        let result = Message::new(MESSAGE, String::new(), files);
        assert_eq!(result.is_ok(), count == 5);
    }
    Ok(())
}

#[test]
fn manager_command_is_encrypted_and_cannot_also_be_chat_text() -> TestResult {
    let mut pair = Pair::new()?;
    let mut command: Message = serde_json::from_value(
        serde_json::json!({"version":1,"id":MESSAGE,"text":"","files":[],"manager":"grant-bob"}),
    )?;
    let ciphertext = pair.sender.encrypt(&mut pair.alice, &command)?;
    assert!(!contains(&ciphertext, b"grant-bob"));
    let received = pair.receiver.decrypt(&mut pair.bob, &ciphertext)?;
    assert_eq!(received.sender, pair.alice.trusted_identity().identity);
    assert_eq!(received.message.manager.as_deref(), Some("grant-bob"));
    command.text = "Обычное сообщение".into();
    assert!(pair.sender.encrypt(&mut pair.alice, &command).is_err());
    Ok(())
}

#[test]
fn reactions_are_encrypted_bound_and_validated() -> TestResult {
    let mut pair = Pair::new()?;
    let value = serde_json::json!({"version":1,"id":vec![3;16],"text":"","files":[],"reaction":{"message_id":MESSAGE,"grant_id":"author-device","emoji":"👩🏽‍💻","active":true}});
    let message: Message = serde_json::from_value(value.clone())?;
    let ciphertext = pair.sender.encrypt(&mut pair.alice, &message)?;
    assert!(!contains(&ciphertext, "👩🏽‍💻".as_bytes()));
    let received = pair.receiver.decrypt(&mut pair.bob, &ciphertext)?;
    assert_eq!(received.message.reaction.ok_or("Нет реакции")?.emoji, "👩🏽‍💻");
    for (field, invalid) in [
        ("emoji", serde_json::json!("<script>")),
        ("grant_id", serde_json::json!("")),
    ] {
        let mut bad = value.clone();
        bad["reaction"][field] = invalid;
        let malformed: Message = serde_json::from_value(bad)?;
        assert!(pair.sender.encrypt(&mut pair.alice, &malformed).is_err());
    }
    let mut bad = value;
    bad["text"] = serde_json::json!("Нельзя совместить");
    assert!(
        pair.sender
            .encrypt(&mut pair.alice, &serde_json::from_value(bad)?)
            .is_err()
    );
    Ok(())
}
