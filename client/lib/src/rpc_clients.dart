export 'rpc_connection.dart' show RpcOptions;

import 'rpc_connection.dart';
import 'generated/space/v1/space.pb.dart';
import 'generated/space/v1/space.connect.spec.dart' as specs;
export 'generated/space/v1/space.pb.dart';

class ChannelServiceClient {
  const ChannelServiceClient(this.connection);
  final RpcConnection connection;
  RpcStream<WatchChannelsResponse> watchChannels(
    WatchChannelsRequest request, {
    RpcOptions? options,
  }) => connection.server(
    specs.ChannelService.watchChannels,
    request,
    options: options,
  );
  Future<ListChannelsResponse> listChannels(
    ListChannelsRequest request, {
    RpcOptions? options,
  }) => connection.unary(
    specs.ChannelService.listChannels,
    request,
    options: options,
  );
  Future<CreateChannelResponse> createChannel(
    CreateChannelRequest request, {
    RpcOptions? options,
  }) => connection.unary(
    specs.ChannelService.createChannel,
    request,
    options: options,
  );
  Future<UpdateChannelResponse> updateChannel(
    UpdateChannelRequest request, {
    RpcOptions? options,
  }) => connection.unary(
    specs.ChannelService.updateChannel,
    request,
    options: options,
  );
  Future<DeleteChannelResponse> deleteChannel(
    DeleteChannelRequest request, {
    RpcOptions? options,
  }) => connection.unary(
    specs.ChannelService.deleteChannel,
    request,
    options: options,
  );
  Future<GetChannelAccessResponse> getChannelAccess(
    GetChannelAccessRequest request, {
    RpcOptions? options,
  }) => connection.unary(
    specs.ChannelService.getChannelAccess,
    request,
    options: options,
  );
  Future<UpdateChannelAccessResponse> updateChannelAccess(
    UpdateChannelAccessRequest request, {
    RpcOptions? options,
  }) => connection.unary(
    specs.ChannelService.updateChannelAccess,
    request,
    options: options,
  );
  Future<GetManifestResponse> getManifest(
    GetManifestRequest request, {
    RpcOptions? options,
  }) => connection.unary(
    specs.ChannelService.getManifest,
    request,
    options: options,
  );
}

class ContentServiceClient {
  const ContentServiceClient(this.connection);
  final RpcConnection connection;
  Future<CreateContentResponse> createContent(
    CreateContentRequest request, {
    RpcOptions? options,
  }) => connection.unary(
    specs.ContentService.createContent,
    request,
    options: options,
  );
  Future<UpdateContentResponse> updateContent(
    UpdateContentRequest request, {
    RpcOptions? options,
  }) => connection.unary(
    specs.ContentService.updateContent,
    request,
    options: options,
  );
  Future<DeleteContentResponse> deleteContent(
    DeleteContentRequest request, {
    RpcOptions? options,
  }) => connection.unary(
    specs.ContentService.deleteContent,
    request,
    options: options,
  );
  Future<ListContentResponse> listContent(
    ListContentRequest request, {
    RpcOptions? options,
  }) => connection.unary(
    specs.ContentService.listContent,
    request,
    options: options,
  );
}

class AuthServiceClient {
  const AuthServiceClient(this.connection);
  final RpcConnection connection;
  Future<CreateRootRotationResponse> createRootRotation(
    CreateRootRotationRequest request, {
    RpcOptions? options,
  }) => connection.unary(
    specs.AuthService.createRootRotation,
    request,
    options: options,
  );
  Future<CompleteRootRotationResponse> completeRootRotation(
    CompleteRootRotationRequest request, {
    RpcOptions? options,
  }) => connection.unary(
    specs.AuthService.completeRootRotation,
    request,
    options: options,
  );
  Future<ProposePairingResponse> proposePairing(
    ProposePairingRequest request, {
    RpcOptions? options,
  }) => connection.unary(
    specs.AuthService.proposePairing,
    request,
    options: options,
  );
  Future<CreatePairingResponse> createPairing(
    CreatePairingRequest request, {
    RpcOptions? options,
  }) => connection.unary(
    specs.AuthService.createPairing,
    request,
    options: options,
  );
  Future<InspectPairingResponse> inspectPairing(
    InspectPairingRequest request, {
    RpcOptions? options,
  }) => connection.unary(
    specs.AuthService.inspectPairing,
    request,
    options: options,
  );
  Future<PollPairingResponse> pollPairing(
    PollPairingRequest request, {
    RpcOptions? options,
  }) => connection.unary(
    specs.AuthService.pollPairing,
    request,
    options: options,
  );
  Future<CancelPairingResponse> cancelPairing(
    CancelPairingRequest request, {
    RpcOptions? options,
  }) => connection.unary(
    specs.AuthService.cancelPairing,
    request,
    options: options,
  );
  Future<ClaimPairingResponse> claimPairing(
    ClaimPairingRequest request, {
    RpcOptions? options,
  }) => connection.unary(
    specs.AuthService.claimPairing,
    request,
    options: options,
  );
  Future<RevokeCurrentDeviceResponse> revokeCurrentDevice(
    RevokeCurrentDeviceRequest request, {
    RpcOptions? options,
  }) => connection.unary(
    specs.AuthService.revokeCurrentDevice,
    request,
    options: options,
  );
  Future<ListDevicesResponse> listDevices(
    ListDevicesRequest request, {
    RpcOptions? options,
  }) => connection.unary(
    specs.AuthService.listDevices,
    request,
    options: options,
  );
  Future<LogoutResponse> logout(LogoutRequest request, {RpcOptions? options}) =>
      connection.unary(specs.AuthService.logout, request, options: options);
  Future<CreateChallengeResponse> createChallenge(
    CreateChallengeRequest request, {
    RpcOptions? options,
  }) => connection.unary(
    specs.AuthService.createChallenge,
    request,
    options: options,
  );
  Future<CompleteChallengeResponse> completeChallenge(
    CompleteChallengeRequest request, {
    RpcOptions? options,
  }) => connection.unary(
    specs.AuthService.completeChallenge,
    request,
    options: options,
  );
}

class SyncServiceClient {
  const SyncServiceClient(this.connection);
  final RpcConnection connection;
  RpcStream<SubscribeResponse> subscribe(
    SubscribeRequest request, {
    RpcOptions? options,
  }) =>
      connection.server(specs.SyncService.subscribe, request, options: options);
  Future<ListEventsResponse> listEvents(
    ListEventsRequest request, {
    RpcOptions? options,
  }) =>
      connection.unary(specs.SyncService.listEvents, request, options: options);
}

class AdminServiceClient {
  const AdminServiceClient(this.connection);
  final RpcConnection connection;
  Future<ListMembersResponse> listMembers(
    ListMembersRequest request, {
    RpcOptions? options,
  }) => connection.unary(
    specs.AdminService.listMembers,
    request,
    options: options,
  );
  Future<UpdateMemberResponse> updateMember(
    UpdateMemberRequest request, {
    RpcOptions? options,
  }) => connection.unary(
    specs.AdminService.updateMember,
    request,
    options: options,
  );
  Future<CreateInviteResponse> createInvite(
    CreateInviteRequest request, {
    RpcOptions? options,
  }) => connection.unary(
    specs.AdminService.createInvite,
    request,
    options: options,
  );
  Future<ListInvitesResponse> listInvites(
    ListInvitesRequest request, {
    RpcOptions? options,
  }) => connection.unary(
    specs.AdminService.listInvites,
    request,
    options: options,
  );
  Future<RevokeInviteResponse> revokeInvite(
    RevokeInviteRequest request, {
    RpcOptions? options,
  }) => connection.unary(
    specs.AdminService.revokeInvite,
    request,
    options: options,
  );
  Future<GetSetupStatusResponse> getSetupStatus(
    GetSetupStatusRequest request, {
    RpcOptions? options,
  }) => connection.unary(
    specs.AdminService.getSetupStatus,
    request,
    options: options,
  );
  Future<ClaimOwnerResponse> claimOwner(
    ClaimOwnerRequest request, {
    RpcOptions? options,
  }) => connection.unary(
    specs.AdminService.claimOwner,
    request,
    options: options,
  );
  Future<GetSettingsResponse> getSettings(
    GetSettingsRequest request, {
    RpcOptions? options,
  }) => connection.unary(
    specs.AdminService.getSettings,
    request,
    options: options,
  );
  Future<UpdateSettingsResponse> updateSettings(
    UpdateSettingsRequest request, {
    RpcOptions? options,
  }) => connection.unary(
    specs.AdminService.updateSettings,
    request,
    options: options,
  );
}

class MembershipServiceClient {
  Future<UpdateProfileResponse> updateProfile(
    UpdateProfileRequest request, {
    RpcOptions? options,
  }) => connection.unary(
    specs.MembershipService.updateProfile,
    request,
    options: options,
  );
  const MembershipServiceClient(this.connection);
  final RpcConnection connection;
  Future<PreviewInviteResponse> previewInvite(
    PreviewInviteRequest request, {
    RpcOptions? options,
  }) => connection.unary(
    specs.MembershipService.previewInvite,
    request,
    options: options,
  );
  Future<AcceptInviteResponse> acceptInvite(
    AcceptInviteRequest request, {
    RpcOptions? options,
  }) => connection.unary(
    specs.MembershipService.acceptInvite,
    request,
    options: options,
  );
  Future<GetMembershipResponse> getMembership(
    GetMembershipRequest request, {
    RpcOptions? options,
  }) => connection.unary(
    specs.MembershipService.getMembership,
    request,
    options: options,
  );
}

class AssetServiceClient {
  const AssetServiceClient(this.connection);
  final RpcConnection connection;
  Future<BeginUploadResponse> beginUpload(
    BeginUploadRequest request, {
    RpcOptions? options,
  }) => connection.unary(
    specs.AssetService.beginUpload,
    request,
    options: options,
  );
  Future<UploadChunkResponse> uploadChunk(
    UploadChunkRequest request, {
    RpcOptions? options,
  }) => connection.unary(
    specs.AssetService.uploadChunk,
    request,
    options: options,
  );
  Future<CompleteUploadResponse> completeUpload(
    CompleteUploadRequest request, {
    RpcOptions? options,
  }) => connection.unary(
    specs.AssetService.completeUpload,
    request,
    options: options,
  );
  Future<CancelUploadResponse> cancelUpload(
    CancelUploadRequest request, {
    RpcOptions? options,
  }) => connection.unary(
    specs.AssetService.cancelUpload,
    request,
    options: options,
  );
  Future<DownloadChunkResponse> downloadChunk(
    DownloadChunkRequest request, {
    RpcOptions? options,
  }) => connection.unary(
    specs.AssetService.downloadChunk,
    request,
    options: options,
  );
  Future<ListChannelAssetsResponse> listChannelAssets(
    ListChannelAssetsRequest request, {
    RpcOptions? options,
  }) => connection.unary(
    specs.AssetService.listChannelAssets,
    request,
    options: options,
  );
  Future<ListMyAssetsResponse> listMyAssets(
    ListMyAssetsRequest request, {
    RpcOptions? options,
  }) => connection.unary(
    specs.AssetService.listMyAssets,
    request,
    options: options,
  );
}
