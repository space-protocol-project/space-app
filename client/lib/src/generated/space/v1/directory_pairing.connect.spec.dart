//
//  Generated code. Do not modify.
//  source: space/v1/directory_pairing.proto
//

import "package:connectrpc/connect.dart" as connect;
import "directory_pairing.pb.dart" as spacev1directory_pairing;

/// Непрозрачный relay; эти методы не выдают grants и не читают каталог.
abstract final class DirectoryPairingService {
  /// Fully-qualified name of the DirectoryPairingService service.
  static const name = 'space.v1.DirectoryPairingService';

  static const createDirectoryTransfer = connect.Spec(
    '/$name/CreateDirectoryTransfer',
    connect.StreamType.unary,
    spacev1directory_pairing.CreateDirectoryTransferRequest.new,
    spacev1directory_pairing.CreateDirectoryTransferResponse.new,
  );

  static const openDirectoryTransfer = connect.Spec(
    '/$name/OpenDirectoryTransfer',
    connect.StreamType.unary,
    spacev1directory_pairing.OpenDirectoryTransferRequest.new,
    spacev1directory_pairing.OpenDirectoryTransferResponse.new,
  );

  static const writeDirectoryFrame = connect.Spec(
    '/$name/WriteDirectoryFrame',
    connect.StreamType.unary,
    spacev1directory_pairing.WriteDirectoryFrameRequest.new,
    spacev1directory_pairing.WriteDirectoryFrameResponse.new,
  );

  static const readDirectoryFrame = connect.Spec(
    '/$name/ReadDirectoryFrame',
    connect.StreamType.unary,
    spacev1directory_pairing.ReadDirectoryFrameRequest.new,
    spacev1directory_pairing.ReadDirectoryFrameResponse.new,
  );

  static const closeDirectoryTransfer = connect.Spec(
    '/$name/CloseDirectoryTransfer',
    connect.StreamType.unary,
    spacev1directory_pairing.CloseDirectoryTransferRequest.new,
    spacev1directory_pairing.CloseDirectoryTransferResponse.new,
  );
}
