import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/user_export_file.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('Android запрашивает системный документ и передаёт данные только выбранному URI',() async {
    final calls=<MethodCall>[];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(UserExportFileService.channel,(call) async {
      calls.add(call);return call.method=='choose'?'content://documents/export':null;
    });
    addTearDown(()=>TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(UserExportFileService.channel,null));
    final files=UserExportFileService(android:true),bytes=Uint8List.fromList([123,125]);
    final path=await files.choose('space-user-content-1.json');await files.write(path!,bytes);
    expect(calls.map((c)=>c.method),['choose','write']);expect((calls.last.arguments as Map)['uri'],path);expect((calls.last.arguments as Map)['bytes'],bytes);
    await files.discard(path);expect(calls.last.method,'discard');
  });
  test('Настольное сохранение заменяет файл полным содержимым и очищает временный каталог',() async {
    final directory=await Directory.systemTemp.createTemp('space-export-test-');addTearDown(()=>directory.delete(recursive:true));
    final path='${directory.path}/chosen.json';await File(path).writeAsString('Старое содержимое');
    await UserExportFileService(android:false).write(path,Uint8List.fromList([123,125]));
    expect(await File(path).readAsString(),'{}');expect((await directory.list().toList()).length,1);
  });
}
