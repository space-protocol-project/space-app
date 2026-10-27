import 'dart:async';

import 'core.dart' show Discovery;
import 'generated/space/v1/directory_pairing.pb.dart';
import 'generated/space/v1/directory_pairing.connect.spec.dart' as specs;
import 'rpc_connection.dart';

export 'generated/space/v1/directory_pairing.pb.dart';

abstract interface class DirectoryRelay {
  Future<CreateDirectoryTransferResponse> create(CreateDirectoryTransferRequest request);
  Future<OpenDirectoryTransferResponse> open(OpenDirectoryTransferRequest request);
  Future<ReadDirectoryFrameResponse> read(ReadDirectoryFrameRequest request);
  Future<void> write(WriteDirectoryFrameRequest request);
  Future<void> close(CloseDirectoryTransferRequest request);
  Future<void> dispose();
}

class RpcDirectoryRelay implements DirectoryRelay {
  RpcDirectoryRelay(Discovery server):connection=server.openConnection();
  final RpcConnection connection;
  static const options=RpcOptions(timeout:Duration(seconds:10));
  @override
  Future<CreateDirectoryTransferResponse> create(CreateDirectoryTransferRequest request)=>connection.unary(specs.DirectoryPairingService.createDirectoryTransfer,request,options:options);
  @override
  Future<OpenDirectoryTransferResponse> open(OpenDirectoryTransferRequest request)=>connection.unary(specs.DirectoryPairingService.openDirectoryTransfer,request,options:options);
  @override
  Future<ReadDirectoryFrameResponse> read(ReadDirectoryFrameRequest request)=>connection.unary(specs.DirectoryPairingService.readDirectoryFrame,request,options:options);
  @override
  Future<void> write(WriteDirectoryFrameRequest request) async {await connection.unary(specs.DirectoryPairingService.writeDirectoryFrame,request,options:options);}
  @override
  Future<void> close(CloseDirectoryTransferRequest request) async {await connection.unary(specs.DirectoryPairingService.closeDirectoryTransfer,request,options:const RpcOptions(timeout:Duration(seconds:2)));}
  @override
  Future<void> dispose()=>connection.shutdown();
}
