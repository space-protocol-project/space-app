import 'package:fixnum/fixnum.dart';
import 'package:space_client/src/user_export_api.dart';
import 'package:space_client/src/generated/space/v1/space_search.pbenum.dart';

class ProbeExportApi implements UserExportApi {
  @override
  String get scopeId => 'probe|me|grant';
  @override
  String get principalId => 'me';
  @override
  String get serverId => 'probe-space';
  @override
  Future<ExportUserContentResponse> export(
    ExportUserContentRequest request,
  ) async => ExportUserContentResponse(
    formatVersion: 1,
    serverId: serverId,
    principalId: principalId,
    generatedAtUnixMs: Int64(1000),
    entries: [
      UserExportEntry(
        kind: SpaceSearchKind.SPACE_SEARCH_KIND_CHAT_MESSAGE,
        id: 'message',
        channelId: 'general',
        channelTitle: 'Клуб Space',
        parentId: 'message',
        text: '**Моё сообщение** без чужого содержимого',
        createdAtUnixMs: Int64(1),
        revision: Int64.ONE,
      ),
    ],
  );
}
