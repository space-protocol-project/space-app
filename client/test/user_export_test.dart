import 'dart:async';
import 'dart:convert';
import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/user_export.dart';
import 'package:space_client/src/generated/space/v1/space_search.pbenum.dart';
import 'package:space_client/ui/user_export.dart' show userExportSelection;

UserExportEntry entry(String id,int created)=>UserExportEntry(kind:SpaceSearchKind.SPACE_SEARCH_KIND_CHAT_MESSAGE,
  id:id,channelId:'general',channelTitle:'Общий',parentId:id,text:'Мой текст',revision:Int64.ONE,createdAtUnixMs:Int64(created));
class ExportApi implements UserExportApi {
  @override String scopeId='space|me|grant';
  @override String principalId='me';
  @override String serverId='server';
  Future<ExportUserContentResponse> Function()? load;
  @override Future<ExportUserContentResponse> export(ExportUserContentRequest request) async=>load!=null?load!():response();
  ExportUserContentResponse response()=>ExportUserContentResponse(formatVersion:1,serverId:serverId,principalId:principalId,generatedAtUnixMs:Int64(1000),entries:[entry('one',1),entry('two',2)]);
}
void main() {
  test('JSON содержит документированный формат и только разрешённые поля',() async {
    final api=ExportApi();final c=UserExportController(api,channels:{'general'},available:()=>true,write:(_,_)async{});addTearDown(c.close);
    await c.prepare(ExportUserContentRequest());final json=jsonDecode(c.state.document) as Map;
    expect(json['format'],'space.user-content');expect(json['version'],1);expect((json['content'] as Map)['principalId'],'me');expect(c.state.count,2);
    expect(json['attachmentPayloads'],false);expect(json['mlsIncluded'],false);
  });
  test('Чужой ответ, неизвестный раздел и повтор не попадают в файл',() {
    final api=ExportApi();
    for(final response in [api.response()..principalId='other',api.response()..serverId='other',
      api.response()..entries.first.channelId='secret',api.response()..entries.add(entry('one',1)),api.response()..entries.first.revision=Int64.ZERO]) {
      expect(()=>checkedUserExport(response,api,{'general'},ExportUserContentRequest()),throwsFormatException);
    }
  });
  test('Поздний ответ отбрасывается при смене пространства или grant',() async {
    final api=ExportApi(),pending=Completer<ExportUserContentResponse>();api.load=()=>pending.future;
    final c=UserExportController(api,channels:{'general'},available:()=>true,write:(_,_)async{});addTearDown(c.close);
    final loading=c.prepare(ExportUserContentRequest());api.scopeId='other';pending.complete(api.response());await loading;
    expect(c.state.revoked,true);expect(c.state.document,isEmpty);
  });
  test('Отзыв доступа перед сохранением не записывает файл',() async {
    final api=ExportApi();var active=true,written=false;
    final c=UserExportController(api,channels:{'general'},available:()=>active,write:(_,_)async{written=true;});addTearDown(c.close);
    await c.prepare(ExportUserContentRequest());active=false;await c.save('chosen.json');expect(written,false);expect(c.state.document,isEmpty);
  });
  test('Ошибка экспорта не оставляет прежний документ; ошибка записи допускает повтор',() async {
    final api=ExportApi();var fail=true;
    final c=UserExportController(api,channels:{'general'},available:()=>true,write:(_,_)async{if(fail) throw StateError('Запись недоступна');});addTearDown(c.close);
    await c.prepare(ExportUserContentRequest());await c.save('chosen.json');expect(c.state.saved,false);expect(c.state.error,isNotNull);
    fail=false;await c.save('chosen.json');expect(c.state.saved,true);expect(c.state.error,isNull);
    api.load=()async=>throw StateError('Нет доступа');await c.prepare(ExportUserContentRequest());expect(c.state.document,isEmpty);
  });
  test('Период строгий, UTC; последняя дата включена',() {
    final req=userExportSelection('general','2026-01-01','2026-01-31');
    expect(req.createdAfterUnixMs,Int64(DateTime.utc(2026).millisecondsSinceEpoch));expect(req.createdBeforeUnixMs,Int64(DateTime.utc(2026,2).millisecondsSinceEpoch));
    for(final date in ['2026-02-31','2026-1-1','1969-01-01','invalid']) {
      expect(()=>userExportSelection('',date,''),throwsFormatException);
    }
    expect(()=>userExportSelection('','2026-02-01','2026-01-01'),throwsFormatException);
  });
}
