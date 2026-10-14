import 'package:grpc/grpc.dart' show CallOptions;

import 'rpc_connection.dart';
import 'generated/space/v1/space.pb.dart';
import 'generated/space/v1/space.connect.spec.dart' as specs;
export 'generated/space/v1/space.pb.dart';

class ChannelServiceClient {
  const ChannelServiceClient(this.connection);
  final RpcConnection connection;
  RpcStream<WatchChannelsResponse> watchChannels(
    WatchChannelsRequest request, {
    CallOptions? options,
  }) => connection.server(
    specs.ChannelService.watchChannels,
    request,
    options: options,
  );
  Future<ListChannelsResponse> listChannels(
    ListChannelsRequest request, {
    CallOptions? options,
  }) => connection.unary(
    specs.ChannelService.listChannels,
    request,
    options: options,
  );
  Future<CreateChannelResponse> createChannel(
    CreateChannelRequest request, {
    CallOptions? options,
  }) => connection.unary(
    specs.ChannelService.createChannel,
    request,
    options: options,
  );
  Future<UpdateChannelResponse> updateChannel(
    UpdateChannelRequest request, {
    CallOptions? options,
  }) => connection.unary(
    specs.ChannelService.updateChannel,
    request,
    options: options,
  );
  Future<DeleteChannelResponse> deleteChannel(
    DeleteChannelRequest request, {
    CallOptions? options,
  }) => connection.unary(
    specs.ChannelService.deleteChannel,
    request,
    options: options,
  );
  Future<GetChannelAccessResponse> getChannelAccess(
    GetChannelAccessRequest request, {
    CallOptions? options,
  }) => connection.unary(
    specs.ChannelService.getChannelAccess,
    request,
    options: options,
  );
  Future<UpdateChannelAccessResponse> updateChannelAccess(
    UpdateChannelAccessRequest request, {
    CallOptions? options,
  }) => connection.unary(
    specs.ChannelService.updateChannelAccess,
    request,
    options: options,
  );
  Future<GetManifestResponse> getManifest(
    GetManifestRequest request, {
    CallOptions? options,
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
    CallOptions? options,
  }) => connection.unary(
    specs.ContentService.createContent,
    request,
    options: options,
  );
  Future<ListContentResponse> listContent(
    ListContentRequest request, {
    CallOptions? options,
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
    CallOptions? options,
  }) => connection.unary(
    specs.AuthService.createRootRotation,
    request,
    options: options,
  );
  Future<CompleteRootRotationResponse> completeRootRotation(
    CompleteRootRotationRequest request, {
    CallOptions? options,
  }) => connection.unary(
    specs.AuthService.completeRootRotation,
    request,
    options: options,
  );
  Future<ProposePairingResponse> proposePairing(
    ProposePairingRequest request, {
    CallOptions? options,
  }) => connection.unary(
    specs.AuthService.proposePairing,
    request,
    options: options,
  );
  Future<CreatePairingResponse> createPairing(
    CreatePairingRequest request, {
    CallOptions? options,
  }) => connection.unary(
    specs.AuthService.createPairing,
    request,
    options: options,
  );
  Future<InspectPairingResponse> inspectPairing(
    InspectPairingRequest request, {
    CallOptions? options,
  }) => connection.unary(
    specs.AuthService.inspectPairing,
    request,
    options: options,
  );
  Future<PollPairingResponse> pollPairing(
    PollPairingRequest request, {
    CallOptions? options,
  }) => connection.unary(
    specs.AuthService.pollPairing,
    request,
    options: options,
  );
  Future<CancelPairingResponse> cancelPairing(
    CancelPairingRequest request, {
    CallOptions? options,
  }) => connection.unary(
    specs.AuthService.cancelPairing,
    request,
    options: options,
  );
  Future<ClaimPairingResponse> claimPairing(
    ClaimPairingRequest request, {
    CallOptions? options,
  }) => connection.unary(
    specs.AuthService.claimPairing,
    request,
    options: options,
  );
  Future<RevokeCurrentDeviceResponse> revokeCurrentDevice(
    RevokeCurrentDeviceRequest request, {
    CallOptions? options,
  }) => connection.unary(
    specs.AuthService.revokeCurrentDevice,
    request,
    options: options,
  );
  Future<ListDevicesResponse> listDevices(
    ListDevicesRequest request, {
    CallOptions? options,
  }) => connection.unary(
    specs.AuthService.listDevices,
    request,
    options: options,
  );
  Future<LogoutResponse> logout(
    LogoutRequest request, {
    CallOptions? options,
  }) => connection.unary(specs.AuthService.logout, request, options: options);
  Future<CreateChallengeResponse> createChallenge(
    CreateChallengeRequest request, {
    CallOptions? options,
  }) => connection.unary(
    specs.AuthService.createChallenge,
    request,
    options: options,
  );
  Future<CompleteChallengeResponse> completeChallenge(
    CompleteChallengeRequest request, {
    CallOptions? options,
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
    CallOptions? options,
  }) =>
      connection.server(specs.SyncService.subscribe, request, options: options);
  Future<ListEventsResponse> listEvents(
    ListEventsRequest request, {
    CallOptions? options,
  }) =>
      connection.unary(specs.SyncService.listEvents, request, options: options);
}

class AdminServiceClient {
  const AdminServiceClient(this.connection);
  final RpcConnection connection;
  Future<ListMembersResponse> listMembers(
    ListMembersRequest request, {
    CallOptions? options,
  }) => connection.unary(
    specs.AdminService.listMembers,
    request,
    options: options,
  );
  Future<UpdateMemberResponse> updateMember(
    UpdateMemberRequest request, {
    CallOptions? options,
  }) => connection.unary(
    specs.AdminService.updateMember,
    request,
    options: options,
  );
  Future<CreateInviteResponse> createInvite(
    CreateInviteRequest request, {
    CallOptions? options,
  }) => connection.unary(
    specs.AdminService.createInvite,
    request,
    options: options,
  );
  Future<ListInvitesResponse> listInvites(
    ListInvitesRequest request, {
    CallOptions? options,
  }) => connection.unary(
    specs.AdminService.listInvites,
    request,
    options: options,
  );
  Future<RevokeInviteResponse> revokeInvite(
    RevokeInviteRequest request, {
    CallOptions? options,
  }) => connection.unary(
    specs.AdminService.revokeInvite,
    request,
    options: options,
  );
  Future<GetSetupStatusResponse> getSetupStatus(
    GetSetupStatusRequest request, {
    CallOptions? options,
  }) => connection.unary(
    specs.AdminService.getSetupStatus,
    request,
    options: options,
  );
  Future<ClaimOwnerResponse> claimOwner(
    ClaimOwnerRequest request, {
    CallOptions? options,
  }) => connection.unary(
    specs.AdminService.claimOwner,
    request,
    options: options,
  );
  Future<GetSettingsResponse> getSettings(
    GetSettingsRequest request, {
    CallOptions? options,
  }) => connection.unary(
    specs.AdminService.getSettings,
    request,
    options: options,
  );
  Future<UpdateSettingsResponse> updateSettings(
    UpdateSettingsRequest request, {
    CallOptions? options,
  }) => connection.unary(
    specs.AdminService.updateSettings,
    request,
    options: options,
  );
}

class MembershipServiceClient {
  const MembershipServiceClient(this.connection);
  final RpcConnection connection;
  Future<PreviewInviteResponse> previewInvite(
    PreviewInviteRequest request, {
    CallOptions? options,
  }) => connection.unary(
    specs.MembershipService.previewInvite,
    request,
    options: options,
  );
  Future<AcceptInviteResponse> acceptInvite(
    AcceptInviteRequest request, {
    CallOptions? options,
  }) => connection.unary(
    specs.MembershipService.acceptInvite,
    request,
    options: options,
  );
  Future<GetMembershipResponse> getMembership(
    GetMembershipRequest request, {
    CallOptions? options,
  }) => connection.unary(
    specs.MembershipService.getMembership,
    request,
    options: options,
  );
}
