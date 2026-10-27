import 'dart:convert';
import 'dart:typed_data';

import 'package:space_directory_noise/space_directory_noise.dart';

import 'directory_document.dart';

class DirectoryNoiseChannel {
  DirectoryNoiseChannel._(this.engine,this.handle,this.public);
  final DirectoryNoiseEngine engine;
  final int handle;
  final Uint8List public;
  bool _closed=false;
  String sas='';

  static Future<DirectoryNoiseChannel> open(DirectoryNoiseEngine engine,{
    required bool initiator,required String context,List<int>? expected}) async {
    final response=await engine.execute({'op':'create','initiator':initiator,'context':context,
      'expected':expected==null?null:base64.encode(expected)});
    final handle=directoryInt(response['handle'],min:1),public=base64Decode(response['public'] as String);
    directoryRequire(public.length==32);
    return DirectoryNoiseChannel._(engine,handle,public);
  }

  Future<Map<String,dynamic>> _call(String op,[Map<String,dynamic> fields=const {}]) async {
    if(_closed)throw StateError('Noise channel closed');
    final result=await engine.execute({'op':op,'handle':handle,...fields});
    if(_closed)throw StateError('Noise channel closed');
    final code=result['sas'];if(code is String)sas=code;
    return result;
  }
  Future<Uint8List> _bytes(String op,[Map<String,dynamic> fields=const {}]) async =>
    base64Decode((await _call(op,fields))['data'] as String);
  Future<Uint8List> writeHandshake()=>_bytes('write_handshake');
  Future<void> readHandshake(List<int> data) async {await _call('read_handshake',{'data':base64.encode(data)});}
  Future<void> confirm(String value) async {await _call('confirm',{'sas':value});}
  Future<Uint8List> confirmation()=>_bytes('confirmation');
  Future<void> receiveConfirmation(List<int> data) async {await _call('receive_confirmation',{'data':base64.encode(data)});}
  Future<List<Uint8List>> seal(List<int> data) async {
    directoryRequire(data.isNotEmpty && data.length<=directoryMaxPlain);
    final result=await _call('seal',{'data':base64.encode(data)});
    return (result['frames'] as List).cast<String>().map(base64Decode).toList();
  }
  Future<Uint8List> openDirectory(List<List<int>> frames)=>_bytes('open',{'frames':frames.map(base64.encode).toList()});
  Future<Uint8List> receipt()=>_bytes('receipt');
  Future<void> receiveReceipt(List<int> data) async {await _call('receive_receipt',{'data':base64.encode(data)});}
  Future<void> close() async {
    if(_closed)return;_closed=true;
    try {await engine.execute({'op':'close','handle':handle});} catch(_){/* Уже истёкший handle не восстанавливается. */}
  }
}
