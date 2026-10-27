//
//  Generated code. Do not modify.
//  source: space/v1/directory_pairing.proto
//

import "package:connectrpc/connect.dart" as connect;
import "directory_pairing.pb.dart" as spacev1directory_pairing;
import "directory_pairing.connect.spec.dart" as specs;

/// Непрозрачный relay; эти методы не выдают grants и не читают каталог.
extension type DirectoryPairingServiceClient (connect.Transport _transport) {
  Future<spacev1directory_pairing.CreateDirectoryTransferResponse> createDirectoryTransfer(
    spacev1directory_pairing.CreateDirectoryTransferRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.DirectoryPairingService.createDirectoryTransfer,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<spacev1directory_pairing.OpenDirectoryTransferResponse> openDirectoryTransfer(
    spacev1directory_pairing.OpenDirectoryTransferRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.DirectoryPairingService.openDirectoryTransfer,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<spacev1directory_pairing.WriteDirectoryFrameResponse> writeDirectoryFrame(
    spacev1directory_pairing.WriteDirectoryFrameRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.DirectoryPairingService.writeDirectoryFrame,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<spacev1directory_pairing.ReadDirectoryFrameResponse> readDirectoryFrame(
    spacev1directory_pairing.ReadDirectoryFrameRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.DirectoryPairingService.readDirectoryFrame,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<spacev1directory_pairing.CloseDirectoryTransferResponse> closeDirectoryTransfer(
    spacev1directory_pairing.CloseDirectoryTransferRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.DirectoryPairingService.closeDirectoryTransfer,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
