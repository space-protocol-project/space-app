//
//  Generated code. Do not modify.
//  source: space/v1/space.proto
//

import "package:connectrpc/connect.dart" as connect;
import "space.pb.dart" as spacev1space;

/// Экспериментальный контракт первого локального прототипа.
abstract final class ChannelService {
  /// Fully-qualified name of the ChannelService service.
  static const name = 'space.v1.ChannelService';

  static const watchChannels = connect.Spec(
    '/$name/WatchChannels',
    connect.StreamType.server,
    spacev1space.WatchChannelsRequest.new,
    spacev1space.WatchChannelsResponse.new,
  );

  static const listChannels = connect.Spec(
    '/$name/ListChannels',
    connect.StreamType.unary,
    spacev1space.ListChannelsRequest.new,
    spacev1space.ListChannelsResponse.new,
  );

  static const createChannel = connect.Spec(
    '/$name/CreateChannel',
    connect.StreamType.unary,
    spacev1space.CreateChannelRequest.new,
    spacev1space.CreateChannelResponse.new,
  );

  static const updateChannel = connect.Spec(
    '/$name/UpdateChannel',
    connect.StreamType.unary,
    spacev1space.UpdateChannelRequest.new,
    spacev1space.UpdateChannelResponse.new,
  );

  static const deleteChannel = connect.Spec(
    '/$name/DeleteChannel',
    connect.StreamType.unary,
    spacev1space.DeleteChannelRequest.new,
    spacev1space.DeleteChannelResponse.new,
  );

  static const getChannelAccess = connect.Spec(
    '/$name/GetChannelAccess',
    connect.StreamType.unary,
    spacev1space.GetChannelAccessRequest.new,
    spacev1space.GetChannelAccessResponse.new,
  );

  static const updateChannelAccess = connect.Spec(
    '/$name/UpdateChannelAccess',
    connect.StreamType.unary,
    spacev1space.UpdateChannelAccessRequest.new,
    spacev1space.UpdateChannelAccessResponse.new,
  );

  static const getManifest = connect.Spec(
    '/$name/GetManifest',
    connect.StreamType.unary,
    spacev1space.GetManifestRequest.new,
    spacev1space.GetManifestResponse.new,
  );
}
abstract final class ContentService {
  /// Fully-qualified name of the ContentService service.
  static const name = 'space.v1.ContentService';

  static const getHistoryPage = connect.Spec(
    '/$name/GetHistoryPage',
    connect.StreamType.unary,
    spacev1space.GetHistoryPageRequest.new,
    spacev1space.GetHistoryPageResponse.new,
  );

  static const searchContent = connect.Spec(
    '/$name/SearchContent',
    connect.StreamType.unary,
    spacev1space.SearchContentRequest.new,
    spacev1space.SearchContentResponse.new,
  );

  /// Постоянная очередь использует отдельный RPC: старый runtime отклоняет
  /// его до изменения данных, а не игнорирует неизвестный ключ запроса.
  static const applyContentMutation = connect.Spec(
    '/$name/ApplyContentMutation',
    connect.StreamType.unary,
    spacev1space.ApplyContentMutationRequest.new,
    spacev1space.ApplyContentMutationResponse.new,
  );

  static const setReaction = connect.Spec(
    '/$name/SetReaction',
    connect.StreamType.unary,
    spacev1space.SetReactionRequest.new,
    spacev1space.SetReactionResponse.new,
  );

  static const updateContent = connect.Spec(
    '/$name/UpdateContent',
    connect.StreamType.unary,
    spacev1space.UpdateContentRequest.new,
    spacev1space.UpdateContentResponse.new,
  );

  static const deleteContent = connect.Spec(
    '/$name/DeleteContent',
    connect.StreamType.unary,
    spacev1space.DeleteContentRequest.new,
    spacev1space.DeleteContentResponse.new,
  );

  static const createContent = connect.Spec(
    '/$name/CreateContent',
    connect.StreamType.unary,
    spacev1space.CreateContentRequest.new,
    spacev1space.CreateContentResponse.new,
  );

  static const listContent = connect.Spec(
    '/$name/ListContent',
    connect.StreamType.unary,
    spacev1space.ListContentRequest.new,
    spacev1space.ListContentResponse.new,
  );
}
/// Файлы передаются ограниченными частями; права проверяются на каждой операции.
abstract final class AssetService {
  /// Fully-qualified name of the AssetService service.
  static const name = 'space.v1.AssetService';

  static const beginUpload = connect.Spec(
    '/$name/BeginUpload',
    connect.StreamType.unary,
    spacev1space.BeginUploadRequest.new,
    spacev1space.BeginUploadResponse.new,
  );

  static const uploadChunk = connect.Spec(
    '/$name/UploadChunk',
    connect.StreamType.unary,
    spacev1space.UploadChunkRequest.new,
    spacev1space.UploadChunkResponse.new,
  );

  static const completeUpload = connect.Spec(
    '/$name/CompleteUpload',
    connect.StreamType.unary,
    spacev1space.CompleteUploadRequest.new,
    spacev1space.CompleteUploadResponse.new,
  );

  static const cancelUpload = connect.Spec(
    '/$name/CancelUpload',
    connect.StreamType.unary,
    spacev1space.CancelUploadRequest.new,
    spacev1space.CancelUploadResponse.new,
  );

  static const downloadChunk = connect.Spec(
    '/$name/DownloadChunk',
    connect.StreamType.unary,
    spacev1space.DownloadChunkRequest.new,
    spacev1space.DownloadChunkResponse.new,
  );

  static const listMyAssets = connect.Spec(
    '/$name/ListMyAssets',
    connect.StreamType.unary,
    spacev1space.ListMyAssetsRequest.new,
    spacev1space.ListMyAssetsResponse.new,
  );

  static const listChannelAssets = connect.Spec(
    '/$name/ListChannelAssets',
    connect.StreamType.unary,
    spacev1space.ListChannelAssetsRequest.new,
    spacev1space.ListChannelAssetsResponse.new,
  );
}
abstract final class AuthService {
  /// Fully-qualified name of the AuthService service.
  static const name = 'space.v1.AuthService';

  /// Экспериментальный API; требует поддержки stable principal у клиента.
  static const createRootRotation = connect.Spec(
    '/$name/CreateRootRotation',
    connect.StreamType.unary,
    spacev1space.CreateRootRotationRequest.new,
    spacev1space.CreateRootRotationResponse.new,
  );

  static const completeRootRotation = connect.Spec(
    '/$name/CompleteRootRotation',
    connect.StreamType.unary,
    spacev1space.CompleteRootRotationRequest.new,
    spacev1space.CompleteRootRotationResponse.new,
  );

  static const proposePairing = connect.Spec(
    '/$name/ProposePairing',
    connect.StreamType.unary,
    spacev1space.ProposePairingRequest.new,
    spacev1space.ProposePairingResponse.new,
  );

  static const createPairing = connect.Spec(
    '/$name/CreatePairing',
    connect.StreamType.unary,
    spacev1space.CreatePairingRequest.new,
    spacev1space.CreatePairingResponse.new,
  );

  static const inspectPairing = connect.Spec(
    '/$name/InspectPairing',
    connect.StreamType.unary,
    spacev1space.InspectPairingRequest.new,
    spacev1space.InspectPairingResponse.new,
  );

  static const pollPairing = connect.Spec(
    '/$name/PollPairing',
    connect.StreamType.unary,
    spacev1space.PollPairingRequest.new,
    spacev1space.PollPairingResponse.new,
  );

  static const cancelPairing = connect.Spec(
    '/$name/CancelPairing',
    connect.StreamType.unary,
    spacev1space.CancelPairingRequest.new,
    spacev1space.CancelPairingResponse.new,
  );

  static const claimPairing = connect.Spec(
    '/$name/ClaimPairing',
    connect.StreamType.unary,
    spacev1space.ClaimPairingRequest.new,
    spacev1space.ClaimPairingResponse.new,
  );

  static const revokeCurrentDevice = connect.Spec(
    '/$name/RevokeCurrentDevice',
    connect.StreamType.unary,
    spacev1space.RevokeCurrentDeviceRequest.new,
    spacev1space.RevokeCurrentDeviceResponse.new,
  );

  static const listDevices = connect.Spec(
    '/$name/ListDevices',
    connect.StreamType.unary,
    spacev1space.ListDevicesRequest.new,
    spacev1space.ListDevicesResponse.new,
  );

  static const logout = connect.Spec(
    '/$name/Logout',
    connect.StreamType.unary,
    spacev1space.LogoutRequest.new,
    spacev1space.LogoutResponse.new,
  );

  static const createChallenge = connect.Spec(
    '/$name/CreateChallenge',
    connect.StreamType.unary,
    spacev1space.CreateChallengeRequest.new,
    spacev1space.CreateChallengeResponse.new,
  );

  static const completeChallenge = connect.Spec(
    '/$name/CompleteChallenge',
    connect.StreamType.unary,
    spacev1space.CompleteChallengeRequest.new,
    spacev1space.CompleteChallengeResponse.new,
  );
}
abstract final class SyncService {
  /// Fully-qualified name of the SyncService service.
  static const name = 'space.v1.SyncService';

  static const subscribe = connect.Spec(
    '/$name/Subscribe',
    connect.StreamType.server,
    spacev1space.SubscribeRequest.new,
    spacev1space.SubscribeResponse.new,
  );

  static const listEvents = connect.Spec(
    '/$name/ListEvents',
    connect.StreamType.unary,
    spacev1space.ListEventsRequest.new,
    spacev1space.ListEventsResponse.new,
  );
}
abstract final class AdminService {
  /// Fully-qualified name of the AdminService service.
  static const name = 'space.v1.AdminService';

  static const listMembers = connect.Spec(
    '/$name/ListMembers',
    connect.StreamType.unary,
    spacev1space.ListMembersRequest.new,
    spacev1space.ListMembersResponse.new,
  );

  static const updateMember = connect.Spec(
    '/$name/UpdateMember',
    connect.StreamType.unary,
    spacev1space.UpdateMemberRequest.new,
    spacev1space.UpdateMemberResponse.new,
  );

  static const createInvite = connect.Spec(
    '/$name/CreateInvite',
    connect.StreamType.unary,
    spacev1space.CreateInviteRequest.new,
    spacev1space.CreateInviteResponse.new,
  );

  static const listInvites = connect.Spec(
    '/$name/ListInvites',
    connect.StreamType.unary,
    spacev1space.ListInvitesRequest.new,
    spacev1space.ListInvitesResponse.new,
  );

  static const revokeInvite = connect.Spec(
    '/$name/RevokeInvite',
    connect.StreamType.unary,
    spacev1space.RevokeInviteRequest.new,
    spacev1space.RevokeInviteResponse.new,
  );

  static const getSetupStatus = connect.Spec(
    '/$name/GetSetupStatus',
    connect.StreamType.unary,
    spacev1space.GetSetupStatusRequest.new,
    spacev1space.GetSetupStatusResponse.new,
  );

  static const claimOwner = connect.Spec(
    '/$name/ClaimOwner',
    connect.StreamType.unary,
    spacev1space.ClaimOwnerRequest.new,
    spacev1space.ClaimOwnerResponse.new,
  );

  static const getSettings = connect.Spec(
    '/$name/GetSettings',
    connect.StreamType.unary,
    spacev1space.GetSettingsRequest.new,
    spacev1space.GetSettingsResponse.new,
  );

  static const updateSettings = connect.Spec(
    '/$name/UpdateSettings',
    connect.StreamType.unary,
    spacev1space.UpdateSettingsRequest.new,
    spacev1space.UpdateSettingsResponse.new,
  );
}
abstract final class MembershipService {
  /// Fully-qualified name of the MembershipService service.
  static const name = 'space.v1.MembershipService';

  static const getParticipantProfile = connect.Spec(
    '/$name/GetParticipantProfile',
    connect.StreamType.unary,
    spacev1space.GetParticipantProfileRequest.new,
    spacev1space.GetParticipantProfileResponse.new,
  );

  static const updateParticipantProfile = connect.Spec(
    '/$name/UpdateParticipantProfile',
    connect.StreamType.unary,
    spacev1space.UpdateParticipantProfileRequest.new,
    spacev1space.UpdateParticipantProfileResponse.new,
  );

  static const listParticipantProfiles = connect.Spec(
    '/$name/ListParticipantProfiles',
    connect.StreamType.unary,
    spacev1space.ListParticipantProfilesRequest.new,
    spacev1space.ListParticipantProfilesResponse.new,
  );

  static const previewInvite = connect.Spec(
    '/$name/PreviewInvite',
    connect.StreamType.unary,
    spacev1space.PreviewInviteRequest.new,
    spacev1space.PreviewInviteResponse.new,
  );

  static const acceptInvite = connect.Spec(
    '/$name/AcceptInvite',
    connect.StreamType.unary,
    spacev1space.AcceptInviteRequest.new,
    spacev1space.AcceptInviteResponse.new,
  );

  static const getMembership = connect.Spec(
    '/$name/GetMembership',
    connect.StreamType.unary,
    spacev1space.GetMembershipRequest.new,
    spacev1space.GetMembershipResponse.new,
  );
}
/// Сервер доставляет непрозрачные MLS-пакеты. Состав проверяется клиентами.
abstract final class MlsService {
  /// Fully-qualified name of the MlsService service.
  static const name = 'space.v1.MlsService';

  static const registerMlsDevice = connect.Spec(
    '/$name/RegisterMlsDevice',
    connect.StreamType.unary,
    spacev1space.RegisterMlsDeviceRequest.new,
    spacev1space.RegisterMlsDeviceResponse.new,
  );

  static const listMlsDevices = connect.Spec(
    '/$name/ListMlsDevices',
    connect.StreamType.unary,
    spacev1space.ListMlsDevicesRequest.new,
    spacev1space.ListMlsDevicesResponse.new,
  );

  static const getMlsChannel = connect.Spec(
    '/$name/GetMlsChannel',
    connect.StreamType.unary,
    spacev1space.GetMlsChannelRequest.new,
    spacev1space.GetMlsChannelResponse.new,
  );

  static const publishMls = connect.Spec(
    '/$name/PublishMls',
    connect.StreamType.unary,
    spacev1space.PublishMlsRequest.new,
    spacev1space.PublishMlsResponse.new,
  );

  static const listMlsEnvelopes = connect.Spec(
    '/$name/ListMlsEnvelopes',
    connect.StreamType.unary,
    spacev1space.ListMlsEnvelopesRequest.new,
    spacev1space.ListMlsEnvelopesResponse.new,
  );
}
