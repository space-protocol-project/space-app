part of 'participant_follows.dart';

bool _followID(String id) => RegExp(r'^[\x21-\x7e]{1,128}$').hasMatch(id);
bool _followText(String text, int bytes) =>
    !text.contains('\u0000') && utf8.encode(text).length <= bytes;

Map<String, bool> _checkedAuthors(
  GetParticipantFollowStatesResponse page,
  List<String> ids,
  String principal,
) {
  if (page.revision < Int64.ZERO || page.states.length > ids.length) {
    throw const FormatException('Повреждены подписки');
  }
  final entries = <String, bool>{};
  for (final item in page.states) {
    if (!_followID(item.principalId) ||
        item.principalId == principal ||
        !ids.contains(item.principalId) ||
        entries.containsKey(item.principalId)) {
      throw const FormatException('Лишний участник подписок');
    }
    entries[item.principalId] = item.following;
  }
  return entries;
}

void _checkedSet(
  SetParticipantFollowResponse response,
  String id,
  int revision,
  bool following,
) {
  if (!response.hasState() ||
      response.state.principalId != id ||
      response.revision < Int64(revision) ||
      response.state.following != following) {
    throw const FormatException('Повреждён ответ подписки');
  }
}

void _followPostFields(FeedPost post, Set<String> channels) {
  if (!_followID(post.id) ||
      !_followID(post.authorId) ||
      !channels.contains(post.channelId) ||
      post.hidden ||
      post.sequence <= Int64.ZERO ||
      post.revision < Int64.ONE ||
      post.createdAtUnix < Int64.ZERO ||
      !_followText(post.text, 8192) ||
      post.attachments.length > 5 ||
      !_followText(post.authorName, 160)) {
    throw const FormatException('Повреждена публикация ленты');
  }
}

PersonalFeedEntry _checkedPersonalEntry(
  PersonalFeedEntry value,
  Set<String> channels,
  String principal,
) {
  if (!value.hasPost() ||
      !_followText(value.channelTitle, 320) ||
      value.post.authorId == principal) {
    throw const FormatException('Повреждена запись ленты');
  }
  final post = value.post;
  _followPostFields(post, channels);
  _followQuote(post, channels);
  return value.deepCopy()..freeze();
}

void _followQuote(FeedPost post, Set<String> channels) {
  if (post.repostOf.isEmpty && post.hasQuotedPost()) {
    throw const FormatException('Цитата без ссылки');
  }
  if (post.repostOf.isNotEmpty && !_followID(post.repostOf)) {
    throw const FormatException('Некорректный оригинал');
  }
  if (!post.hasQuotedPost()) return;
  final quote = post.quotedPost;
  _followPostFields(quote, channels);
  if (quote.id != post.repostOf ||
      quote.channelId != post.channelId ||
      quote.repostOf.isNotEmpty ||
      quote.hasQuotedPost()) {
    throw const FormatException('Некорректная вложенная цитата');
  }
}

int _followPosition(PersonalFeedEntry a, PersonalFeedEntry b) {
  final time = a.post.createdAtUnix.compareTo(b.post.createdAtUnix);
  if (time != 0) return time;
  final channel = a.post.channelId.compareTo(b.post.channelId);
  return channel != 0 ? channel : a.post.id.compareTo(b.post.id);
}

FollowTimelineState _checkedFollowPage(
  _FollowPage page,
  FollowTimelineState before,
  Set<String> channels,
  FollowPageKind kind,
  String principal,
) {
  if (page.revision < 0 ||
      (before.next.isNotEmpty && page.revision != before.revision) ||
      page.posts.length + page.authors.length > 50) {
    throw const FormatException('Некорректная ревизия или размер страницы');
  }
  if (kind == FollowPageKind.posts) {
    return _checkedPostPage(page, before, channels, principal);
  }
  return _checkedAuthorPage(page, before, principal);
}

FollowTimelineState _checkedPostPage(
  _FollowPage page,
  FollowTimelineState before,
  Set<String> channels,
  String principal,
) {
  final entries = [...before.entries];
  final seen = {for (final item in entries) item.post.id};
  for (final value in page.posts) {
    final item = _checkedPersonalEntry(value, channels, principal);
    if (!seen.add(item.post.id)) {
      throw const FormatException('Повтор публикации');
    }
    if (entries.isNotEmpty && _followPosition(entries.last, item) <= 0) {
      throw const FormatException('Нарушен порядок ленты');
    }
    entries.add(item);
  }
  final capped = entries.length >= 500;
  return FollowTimelineState(
    entries: entries.take(500).toList(),
    next: capped ? '' : page.next,
    revision: page.revision,
    capped: capped,
  );
}

FollowTimelineState _checkedAuthorPage(
  _FollowPage page,
  FollowTimelineState before,
  String principal,
) {
  final authors = [...before.participants];
  for (final item in page.authors) {
    if (!_followID(item.principalId) ||
        item.principalId == principal ||
        !_followText(item.displayName, 160) ||
        (!item.available && item.displayName.isNotEmpty)) {
      throw const FormatException('Повреждён участник подписок');
    }
    if (authors.isNotEmpty &&
        authors.last.principalId.compareTo(item.principalId) >= 0) {
      throw const FormatException('Повтор или неверный порядок подписок');
    }
    authors.add(item.deepCopy()..freeze());
  }
  if (authors.length > 1000) {
    throw const FormatException('Слишком много подписок');
  }
  return FollowTimelineState(
    participants: authors,
    next: page.next,
    revision: page.revision,
  );
}
