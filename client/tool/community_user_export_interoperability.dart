import 'dart:convert';
import 'dart:io';

import 'package:grpc/grpc.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/generated/space/v1/feed.pb.dart';
import 'package:space_client/src/user_export_api.dart';

import 'community_space_search_interoperability.dart'
    show SearchVault, require, requireCode, access, restart;
import 'community_participant_follows_interoperability.dart' show prepare;

Future<void> publishOwn(SpaceSession member) async {
  await member.send('Моё обычное сообщение', 'export-chat');
  for (final channel in ['feed', 'other']) {
    await SessionFeedApi(member).publish(
      CreateFeedPostRequest(
        channelId: channel,
        text: '**Моя запись** $channel',
        idempotencyKey: 'export-$channel',
      ),
    );
  }
}

Future<void> allowPublishing(SpaceSession owner) async {
  final feed = SessionFeedApi(owner);
  for (final channel in ['feed', 'other']) {
    final policy = await feed.access(channel);
    await feed.saveAccess(
      UpdateFeedAccessRequest(
        channelId: channel,
        expectedRevision: policy.revision,
        rules: [
          FeedAccessRule(
            role: 'member',
            permissions: FeedPermissions(publish: true, comment: true),
          ),
        ],
      ),
    );
  }
}

Future<void> main(List<String> args) async {
  final ownerVault = SearchVault(), memberVault = SearchVault();
  var owner = await SpaceSession.connect(
    await discover(args.first),
    ownerVault,
  );
  SpaceSession? member;
  try {
    await prepare(owner);
    await allowPublishing(owner);
    member = await SpaceSession.connect(
      await discover(args.first),
      memberVault,
    );
    await publishOwn(member);
    var api = SessionUserExportApi(member);
    require(member.userExport != null, 'Нет capability экспорта');
    final all = await api.export(ExportUserContentRequest());
    require(
      all.formatVersion == 1 &&
          all.principalId == member.principalId &&
          all.entries.length == 3,
      'Не все собственные объекты',
    );
    require(
      all.entries.every(
        (entry) =>
            entry.text == 'Моё обычное сообщение' ||
            entry.text.startsWith('**Моя запись**'),
      ),
      'Экспорт раскрывает чужой текст',
    );
    final file = File('${args[1]}.export.json');
    await file.writeAsString(jsonEncode(all.toProto3Json()));
    require(
      (jsonDecode(await file.readAsString()) as Map)['principalId'] ==
          member.principalId,
      'Файл не соответствует владельцу',
    );
    final selected = await api.export(
      ExportUserContentRequest(channelId: 'feed'),
    );
    require(selected.entries.length == 1, 'Фильтр раздела не применён');
    await access(owner, 'feed', false);
    await requireCode(
      api.export(ExportUserContentRequest(channelId: 'feed')),
      StatusCode.notFound,
    );
    final before = await api.export(ExportUserContentRequest());
    require(before.entries.length == 2, 'ACL не применён к общему экспорту');
    final identity = member.principalId;
    await restart(args);
    await member.close();
    await owner.close();
    owner = await SpaceSession.connect(await discover(args.first), ownerVault);
    member = await SpaceSession.connect(
      await discover(args.first),
      memberVault,
    );
    api = SessionUserExportApi(member);
    final after = await api.export(ExportUserContentRequest());
    require(
      member.principalId == identity &&
          jsonEncode(after.entries.map((v) => v.toProto3Json()).toList()) ==
              jsonEncode(before.entries.map((v) => v.toProto3Json()).toList()),
      'После перезапуска изменилось содержимое или права',
    );
    stdout.writeln(
      'COMMUNITY_USER_EXPORT_INTEROP_OK: собственные объекты, JSON, ACL, выбор раздела и перезапуск',
    );
  } finally {
    await member?.close();
    await owner.close();
  }
}
