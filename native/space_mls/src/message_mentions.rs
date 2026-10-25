use serde::{Deserialize, Serialize};

use crate::{Error, Result};

pub const MAX_MENTIONS: usize = 10;

pub(crate) fn deserialize_mentions<'de, D>(
    input: D,
) -> std::result::Result<Option<Vec<Mention>>, D::Error>
where
    D: serde::Deserializer<'de>,
{
    Vec::<Mention>::deserialize(input).map(Some)
}

// Эти поля допустимы только внутри зашифрованного сообщения приложения.
#[derive(Clone, Debug, PartialEq, Eq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct Mention {
    pub principal_id: String,
    pub display_name: String,
    pub start: u32,
    pub length: u32,
}

impl Mention {
    fn end(&self, units: &[u16], previous: usize) -> Result<usize> {
        let start = usize::try_from(self.start).map_err(|_| Error::InvalidInput)?;
        let length = usize::try_from(self.length).map_err(|_| Error::InvalidInput)?;
        let end = start.checked_add(length).ok_or(Error::InvalidInput)?;
        if !valid_id(&self.principal_id)
            || self.display_name.is_empty()
            || self.display_name.len() > 256
            || self.display_name.chars().any(char::is_control)
            || start < previous
            || length < 2
        {
            return Err(Error::InvalidInput);
        }
        let selected = units.get(start..end).ok_or(Error::InvalidInput)?;
        let label = format!("@{}", self.display_name);
        if !selected.iter().copied().eq(label.encode_utf16()) {
            return Err(Error::InvalidInput);
        }
        Ok(end)
    }
}

pub(crate) fn valid_id(value: &str) -> bool {
    !value.is_empty()
        && value.len() <= 128
        && value.is_ascii()
        && !value.chars().any(char::is_control)
}

pub(crate) fn validate_mentions(
    version: u8,
    text: &str,
    mentions: Option<&[Mention]>,
    control: bool,
) -> Result<()> {
    match (version, mentions) {
        (1, None) => Ok(()),
        (2, Some(items)) if !control && !items.is_empty() && items.len() <= MAX_MENTIONS => {
            let units: Vec<_> = text.encode_utf16().collect();
            let mut previous = 0;
            for mention in items {
                previous = mention.end(&units, previous)?;
            }
            Ok(())
        }
        _ => Err(Error::InvalidInput),
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::Message;
    use serde_json::json;

    fn selected(start: u32) -> Mention {
        Mention {
            principal_id: "u_bob".into(),
            display_name: "Боб🚀".into(),
            start,
            length: 6,
        }
    }

    #[test]
    fn utf16_and_repeated_recipient_are_preserved() -> Result<()> {
        let message = Message::new([3; 16], "🚀 @Боб🚀 @Боб🚀".into(), vec![])?
            .with_mentions(vec![selected(3), selected(10)])?;
        let value = serde_json::to_value(message).map_err(|_| Error::InvalidInput)?;
        assert_eq!(value["version"], 2);
        assert_eq!(value["mentions"][0]["start"], 3);
        let decoded: Message = serde_json::from_value(value).map_err(|_| Error::InvalidInput)?;
        decoded.validate()?;
        assert_eq!(decoded.mentions, Some(vec![selected(3), selected(10)]));
        Ok(())
    }

    #[test]
    fn plain_message_keeps_legacy_shape() -> Result<()> {
        let message = Message::new([3; 16], "@Боб🚀".into(), vec![])?.with_mentions(vec![])?;
        let value = serde_json::to_value(message).map_err(|_| Error::InvalidInput)?;
        assert_eq!(value["version"], 1);
        assert!(value.get("mentions").is_none());
        Ok(())
    }

    #[test]
    fn malformed_ranges_and_control_messages_are_rejected() {
        for mention in [
            selected(1),
            Mention {
                length: 5,
                ..selected(3)
            },
            Mention {
                start: u32::MAX,
                ..selected(3)
            },
            Mention {
                principal_id: "юзер".into(),
                ..selected(3)
            },
            Mention {
                principal_id: "x".repeat(129),
                ..selected(3)
            },
        ] {
            assert!(validate_mentions(2, "🚀 @Боб🚀", Some(&[mention]), false).is_err());
        }
        assert!(
            validate_mentions(2, "🚀 @Боб🚀", Some(&[selected(3), selected(3)]), false).is_err()
        );
        assert!(validate_mentions(2, "🚀 @Боб🚀", Some(&[selected(3)]), true).is_err());
    }

    #[test]
    fn unsupported_versions_and_null_metadata_are_rejected() {
        for version in [1, 2, 3] {
            for mentions in [json!(null), json!([])] {
                let value = json!({"version":version,"id":vec![3;16],"text":"@Боб🚀","files":[],"mentions":mentions});
                let parsed = serde_json::from_value::<Message>(value);
                assert!(parsed.is_err() || parsed.is_ok_and(|message| message.validate().is_err()));
            }
        }
        let unknown = json!({"principal_id":"u_bob","display_name":"Боб🚀","start":0,"length":6,"everyone":true});
        assert!(serde_json::from_value::<Mention>(unknown).is_err());
    }

    #[test]
    fn ten_spans_are_allowed_but_eleven_are_not() {
        let text = ["@X"; 11].join(" ");
        let mentions: Vec<_> = (0..11)
            .map(|i| Mention {
                principal_id: "u_bob".into(),
                display_name: "X".into(),
                start: i * 3,
                length: 2,
            })
            .collect();
        assert!(validate_mentions(2, &text, Some(&mentions[..10]), false).is_ok());
        assert!(validate_mentions(2, &text, Some(&mentions), false).is_err());
    }
}
