part of 'user_export.dart';

bool _exportID(String value)=>RegExp(r'^[\x21-\x7e]{1,128}$').hasMatch(value);
bool _exportText(String value,int limit)=>!value.contains('\u0000')&&utf8.encode(value).length<=limit;

void _exportEntry(UserExportEntry entry,Set<String> channels,ExportUserContentRequest request) {
  if(!_exportID(entry.id)||!channels.contains(entry.channelId)||entry.kind.value<1||entry.kind.value>5) {
    throw const FormatException('Повреждён объект экспорта');
  }
  if(!_exportText(entry.text,8192)||!_exportText(entry.title,320)||!_exportText(entry.channelTitle,320)||entry.revision<Int64.ONE) {
    throw const FormatException('Повреждено содержимое экспорта');
  }
  if(entry.createdAtUnixMs<request.createdAfterUnixMs||entry.createdAtUnixMs<Int64.ZERO) {
    throw const FormatException('Неверная нижняя граница экспорта');
  }
  if(request.createdBeforeUnixMs>Int64.ZERO&&entry.createdAtUnixMs>=request.createdBeforeUnixMs) {
    throw const FormatException('Неверная верхняя граница экспорта');
  }
  if(request.channelId.isNotEmpty&&request.channelId!=entry.channelId) throw const FormatException('Лишний раздел экспорта');
  _exportReferences(entry);
}

void _exportReferences(UserExportEntry entry) {
  if(!_exportID(entry.parentId)||entry.attachments.length>5) throw const FormatException('Повреждены ссылки экспорта');
  if(entry.repostOf.isNotEmpty&&(entry.kind.value!=4||!_exportID(entry.repostOf))) throw const FormatException('Повреждена ссылка репоста');
  final ids=<String>{};
  for(final asset in entry.attachments) {
    if(!_exportID(asset.id)||!ids.add(asset.id)||!_exportText(asset.name,255)||!_exportText(asset.mimeType,256)) {
      throw const FormatException('Повреждено вложение экспорта');
    }
    if(asset.byteSize<=Int64.ZERO||asset.byteSize>Int64(20971520)||asset.sha256.length!=32) throw const FormatException('Повреждён размер или хеш вложения');
  }
}

int _exportPosition(UserExportEntry a,UserExportEntry b) {
  final created=a.createdAtUnixMs.compareTo(b.createdAtUnixMs);
  if(created!=0) return created;
  final kind=a.kind.value.compareTo(b.kind.value);
  if(kind!=0) return kind;
  final channel=a.channelId.compareTo(b.channelId);
  return channel!=0?channel:a.id.compareTo(b.id);
}

String checkedUserExport(ExportUserContentResponse response,UserExportApi api,Set<String> channels,ExportUserContentRequest request) {
  if(response.formatVersion!=1||response.serverId!=api.serverId||response.principalId!=api.principalId||response.generatedAtUnixMs<=Int64.ZERO) {
    throw const FormatException('Экспорт принадлежит другому пространству или участнику');
  }
  if(response.entries.length>5000) throw const FormatException('Слишком большой экспорт');
  final ids=<String>{};UserExportEntry? previous;
  for(final entry in response.entries) {
    _exportEntry(entry,channels,request);
    if(!ids.add('${entry.kind.value}:${entry.channelId}:${entry.id}')) throw const FormatException('Повтор объекта экспорта');
    if(previous!=null&&_exportPosition(previous,entry)>=0) throw const FormatException('Неверный порядок экспорта');
    previous=entry;
  }
  final document=const JsonEncoder.withIndent('  ').convert({
    'format':'space.user-content','version':1,'selection':request.toProto3Json(),
    'content':response.toProto3Json(),'attachmentPayloads':false,'mlsIncluded':false,
  });
  if(utf8.encode(document).length>16*1024*1024) throw const FormatException('Слишком большой JSON экспорта');
  return document;
}
