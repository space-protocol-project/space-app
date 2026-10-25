// This is a generated file - do not edit.
//
// Generated from space/v1/space.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'space.pb.dart' as $1;
import 'space.pbjson.dart';

export 'space.pb.dart';

abstract class ChannelServiceBase extends $pb.GeneratedService {
  $async.Future<$1.WatchChannelsResponse> watchChannels(
      $pb.ServerContext ctx, $1.WatchChannelsRequest request);
  $async.Future<$1.ListChannelsResponse> listChannels(
      $pb.ServerContext ctx, $1.ListChannelsRequest request);
  $async.Future<$1.CreateChannelResponse> createChannel(
      $pb.ServerContext ctx, $1.CreateChannelRequest request);
  $async.Future<$1.UpdateChannelResponse> updateChannel(
      $pb.ServerContext ctx, $1.UpdateChannelRequest request);
  $async.Future<$1.DeleteChannelResponse> deleteChannel(
      $pb.ServerContext ctx, $1.DeleteChannelRequest request);
  $async.Future<$1.GetChannelAccessResponse> getChannelAccess(
      $pb.ServerContext ctx, $1.GetChannelAccessRequest request);
  $async.Future<$1.UpdateChannelAccessResponse> updateChannelAccess(
      $pb.ServerContext ctx, $1.UpdateChannelAccessRequest request);
  $async.Future<$1.GetManifestResponse> getManifest(
      $pb.ServerContext ctx, $1.GetManifestRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'WatchChannels':
        return $1.WatchChannelsRequest();
      case 'ListChannels':
        return $1.ListChannelsRequest();
      case 'CreateChannel':
        return $1.CreateChannelRequest();
      case 'UpdateChannel':
        return $1.UpdateChannelRequest();
      case 'DeleteChannel':
        return $1.DeleteChannelRequest();
      case 'GetChannelAccess':
        return $1.GetChannelAccessRequest();
      case 'UpdateChannelAccess':
        return $1.UpdateChannelAccessRequest();
      case 'GetManifest':
        return $1.GetManifestRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'WatchChannels':
        return watchChannels(ctx, request as $1.WatchChannelsRequest);
      case 'ListChannels':
        return listChannels(ctx, request as $1.ListChannelsRequest);
      case 'CreateChannel':
        return createChannel(ctx, request as $1.CreateChannelRequest);
      case 'UpdateChannel':
        return updateChannel(ctx, request as $1.UpdateChannelRequest);
      case 'DeleteChannel':
        return deleteChannel(ctx, request as $1.DeleteChannelRequest);
      case 'GetChannelAccess':
        return getChannelAccess(ctx, request as $1.GetChannelAccessRequest);
      case 'UpdateChannelAccess':
        return updateChannelAccess(
            ctx, request as $1.UpdateChannelAccessRequest);
      case 'GetManifest':
        return getManifest(ctx, request as $1.GetManifestRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => ChannelServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => ChannelServiceBase$messageJson;
}

abstract class ContentServiceBase extends $pb.GeneratedService {
  $async.Future<$1.GetHistoryPageResponse> getHistoryPage(
      $pb.ServerContext ctx, $1.GetHistoryPageRequest request);
  $async.Future<$1.SearchContentResponse> searchContent(
      $pb.ServerContext ctx, $1.SearchContentRequest request);
  $async.Future<$1.ApplyContentMutationResponse> applyContentMutation(
      $pb.ServerContext ctx, $1.ApplyContentMutationRequest request);
  $async.Future<$1.SetReactionResponse> setReaction(
      $pb.ServerContext ctx, $1.SetReactionRequest request);
  $async.Future<$1.UpdateContentResponse> updateContent(
      $pb.ServerContext ctx, $1.UpdateContentRequest request);
  $async.Future<$1.DeleteContentResponse> deleteContent(
      $pb.ServerContext ctx, $1.DeleteContentRequest request);
  $async.Future<$1.CreateContentResponse> createContent(
      $pb.ServerContext ctx, $1.CreateContentRequest request);
  $async.Future<$1.ListContentResponse> listContent(
      $pb.ServerContext ctx, $1.ListContentRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'GetHistoryPage':
        return $1.GetHistoryPageRequest();
      case 'SearchContent':
        return $1.SearchContentRequest();
      case 'ApplyContentMutation':
        return $1.ApplyContentMutationRequest();
      case 'SetReaction':
        return $1.SetReactionRequest();
      case 'UpdateContent':
        return $1.UpdateContentRequest();
      case 'DeleteContent':
        return $1.DeleteContentRequest();
      case 'CreateContent':
        return $1.CreateContentRequest();
      case 'ListContent':
        return $1.ListContentRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'GetHistoryPage':
        return getHistoryPage(ctx, request as $1.GetHistoryPageRequest);
      case 'SearchContent':
        return searchContent(ctx, request as $1.SearchContentRequest);
      case 'ApplyContentMutation':
        return applyContentMutation(
            ctx, request as $1.ApplyContentMutationRequest);
      case 'SetReaction':
        return setReaction(ctx, request as $1.SetReactionRequest);
      case 'UpdateContent':
        return updateContent(ctx, request as $1.UpdateContentRequest);
      case 'DeleteContent':
        return deleteContent(ctx, request as $1.DeleteContentRequest);
      case 'CreateContent':
        return createContent(ctx, request as $1.CreateContentRequest);
      case 'ListContent':
        return listContent(ctx, request as $1.ListContentRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => ContentServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => ContentServiceBase$messageJson;
}

abstract class AssetServiceBase extends $pb.GeneratedService {
  $async.Future<$1.BeginUploadResponse> beginUpload(
      $pb.ServerContext ctx, $1.BeginUploadRequest request);
  $async.Future<$1.UploadChunkResponse> uploadChunk(
      $pb.ServerContext ctx, $1.UploadChunkRequest request);
  $async.Future<$1.CompleteUploadResponse> completeUpload(
      $pb.ServerContext ctx, $1.CompleteUploadRequest request);
  $async.Future<$1.CancelUploadResponse> cancelUpload(
      $pb.ServerContext ctx, $1.CancelUploadRequest request);
  $async.Future<$1.DownloadChunkResponse> downloadChunk(
      $pb.ServerContext ctx, $1.DownloadChunkRequest request);
  $async.Future<$1.ListMyAssetsResponse> listMyAssets(
      $pb.ServerContext ctx, $1.ListMyAssetsRequest request);
  $async.Future<$1.ListChannelAssetsResponse> listChannelAssets(
      $pb.ServerContext ctx, $1.ListChannelAssetsRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'BeginUpload':
        return $1.BeginUploadRequest();
      case 'UploadChunk':
        return $1.UploadChunkRequest();
      case 'CompleteUpload':
        return $1.CompleteUploadRequest();
      case 'CancelUpload':
        return $1.CancelUploadRequest();
      case 'DownloadChunk':
        return $1.DownloadChunkRequest();
      case 'ListMyAssets':
        return $1.ListMyAssetsRequest();
      case 'ListChannelAssets':
        return $1.ListChannelAssetsRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'BeginUpload':
        return beginUpload(ctx, request as $1.BeginUploadRequest);
      case 'UploadChunk':
        return uploadChunk(ctx, request as $1.UploadChunkRequest);
      case 'CompleteUpload':
        return completeUpload(ctx, request as $1.CompleteUploadRequest);
      case 'CancelUpload':
        return cancelUpload(ctx, request as $1.CancelUploadRequest);
      case 'DownloadChunk':
        return downloadChunk(ctx, request as $1.DownloadChunkRequest);
      case 'ListMyAssets':
        return listMyAssets(ctx, request as $1.ListMyAssetsRequest);
      case 'ListChannelAssets':
        return listChannelAssets(ctx, request as $1.ListChannelAssetsRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => AssetServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => AssetServiceBase$messageJson;
}

abstract class AuthServiceBase extends $pb.GeneratedService {
  $async.Future<$1.CreateRootRotationResponse> createRootRotation(
      $pb.ServerContext ctx, $1.CreateRootRotationRequest request);
  $async.Future<$1.CompleteRootRotationResponse> completeRootRotation(
      $pb.ServerContext ctx, $1.CompleteRootRotationRequest request);
  $async.Future<$1.ProposePairingResponse> proposePairing(
      $pb.ServerContext ctx, $1.ProposePairingRequest request);
  $async.Future<$1.CreatePairingResponse> createPairing(
      $pb.ServerContext ctx, $1.CreatePairingRequest request);
  $async.Future<$1.InspectPairingResponse> inspectPairing(
      $pb.ServerContext ctx, $1.InspectPairingRequest request);
  $async.Future<$1.PollPairingResponse> pollPairing(
      $pb.ServerContext ctx, $1.PollPairingRequest request);
  $async.Future<$1.CancelPairingResponse> cancelPairing(
      $pb.ServerContext ctx, $1.CancelPairingRequest request);
  $async.Future<$1.ClaimPairingResponse> claimPairing(
      $pb.ServerContext ctx, $1.ClaimPairingRequest request);
  $async.Future<$1.RevokeCurrentDeviceResponse> revokeCurrentDevice(
      $pb.ServerContext ctx, $1.RevokeCurrentDeviceRequest request);
  $async.Future<$1.ListDevicesResponse> listDevices(
      $pb.ServerContext ctx, $1.ListDevicesRequest request);
  $async.Future<$1.LogoutResponse> logout(
      $pb.ServerContext ctx, $1.LogoutRequest request);
  $async.Future<$1.CreateChallengeResponse> createChallenge(
      $pb.ServerContext ctx, $1.CreateChallengeRequest request);
  $async.Future<$1.CompleteChallengeResponse> completeChallenge(
      $pb.ServerContext ctx, $1.CompleteChallengeRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'CreateRootRotation':
        return $1.CreateRootRotationRequest();
      case 'CompleteRootRotation':
        return $1.CompleteRootRotationRequest();
      case 'ProposePairing':
        return $1.ProposePairingRequest();
      case 'CreatePairing':
        return $1.CreatePairingRequest();
      case 'InspectPairing':
        return $1.InspectPairingRequest();
      case 'PollPairing':
        return $1.PollPairingRequest();
      case 'CancelPairing':
        return $1.CancelPairingRequest();
      case 'ClaimPairing':
        return $1.ClaimPairingRequest();
      case 'RevokeCurrentDevice':
        return $1.RevokeCurrentDeviceRequest();
      case 'ListDevices':
        return $1.ListDevicesRequest();
      case 'Logout':
        return $1.LogoutRequest();
      case 'CreateChallenge':
        return $1.CreateChallengeRequest();
      case 'CompleteChallenge':
        return $1.CompleteChallengeRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'CreateRootRotation':
        return createRootRotation(ctx, request as $1.CreateRootRotationRequest);
      case 'CompleteRootRotation':
        return completeRootRotation(
            ctx, request as $1.CompleteRootRotationRequest);
      case 'ProposePairing':
        return proposePairing(ctx, request as $1.ProposePairingRequest);
      case 'CreatePairing':
        return createPairing(ctx, request as $1.CreatePairingRequest);
      case 'InspectPairing':
        return inspectPairing(ctx, request as $1.InspectPairingRequest);
      case 'PollPairing':
        return pollPairing(ctx, request as $1.PollPairingRequest);
      case 'CancelPairing':
        return cancelPairing(ctx, request as $1.CancelPairingRequest);
      case 'ClaimPairing':
        return claimPairing(ctx, request as $1.ClaimPairingRequest);
      case 'RevokeCurrentDevice':
        return revokeCurrentDevice(
            ctx, request as $1.RevokeCurrentDeviceRequest);
      case 'ListDevices':
        return listDevices(ctx, request as $1.ListDevicesRequest);
      case 'Logout':
        return logout(ctx, request as $1.LogoutRequest);
      case 'CreateChallenge':
        return createChallenge(ctx, request as $1.CreateChallengeRequest);
      case 'CompleteChallenge':
        return completeChallenge(ctx, request as $1.CompleteChallengeRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => AuthServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => AuthServiceBase$messageJson;
}

abstract class SyncServiceBase extends $pb.GeneratedService {
  $async.Future<$1.SubscribeResponse> subscribe(
      $pb.ServerContext ctx, $1.SubscribeRequest request);
  $async.Future<$1.ListEventsResponse> listEvents(
      $pb.ServerContext ctx, $1.ListEventsRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'Subscribe':
        return $1.SubscribeRequest();
      case 'ListEvents':
        return $1.ListEventsRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'Subscribe':
        return subscribe(ctx, request as $1.SubscribeRequest);
      case 'ListEvents':
        return listEvents(ctx, request as $1.ListEventsRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => SyncServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => SyncServiceBase$messageJson;
}

abstract class AdminServiceBase extends $pb.GeneratedService {
  $async.Future<$1.ListMembersResponse> listMembers(
      $pb.ServerContext ctx, $1.ListMembersRequest request);
  $async.Future<$1.UpdateMemberResponse> updateMember(
      $pb.ServerContext ctx, $1.UpdateMemberRequest request);
  $async.Future<$1.CreateInviteResponse> createInvite(
      $pb.ServerContext ctx, $1.CreateInviteRequest request);
  $async.Future<$1.ListInvitesResponse> listInvites(
      $pb.ServerContext ctx, $1.ListInvitesRequest request);
  $async.Future<$1.RevokeInviteResponse> revokeInvite(
      $pb.ServerContext ctx, $1.RevokeInviteRequest request);
  $async.Future<$1.GetSetupStatusResponse> getSetupStatus(
      $pb.ServerContext ctx, $1.GetSetupStatusRequest request);
  $async.Future<$1.ClaimOwnerResponse> claimOwner(
      $pb.ServerContext ctx, $1.ClaimOwnerRequest request);
  $async.Future<$1.GetSettingsResponse> getSettings(
      $pb.ServerContext ctx, $1.GetSettingsRequest request);
  $async.Future<$1.UpdateSettingsResponse> updateSettings(
      $pb.ServerContext ctx, $1.UpdateSettingsRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'ListMembers':
        return $1.ListMembersRequest();
      case 'UpdateMember':
        return $1.UpdateMemberRequest();
      case 'CreateInvite':
        return $1.CreateInviteRequest();
      case 'ListInvites':
        return $1.ListInvitesRequest();
      case 'RevokeInvite':
        return $1.RevokeInviteRequest();
      case 'GetSetupStatus':
        return $1.GetSetupStatusRequest();
      case 'ClaimOwner':
        return $1.ClaimOwnerRequest();
      case 'GetSettings':
        return $1.GetSettingsRequest();
      case 'UpdateSettings':
        return $1.UpdateSettingsRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'ListMembers':
        return listMembers(ctx, request as $1.ListMembersRequest);
      case 'UpdateMember':
        return updateMember(ctx, request as $1.UpdateMemberRequest);
      case 'CreateInvite':
        return createInvite(ctx, request as $1.CreateInviteRequest);
      case 'ListInvites':
        return listInvites(ctx, request as $1.ListInvitesRequest);
      case 'RevokeInvite':
        return revokeInvite(ctx, request as $1.RevokeInviteRequest);
      case 'GetSetupStatus':
        return getSetupStatus(ctx, request as $1.GetSetupStatusRequest);
      case 'ClaimOwner':
        return claimOwner(ctx, request as $1.ClaimOwnerRequest);
      case 'GetSettings':
        return getSettings(ctx, request as $1.GetSettingsRequest);
      case 'UpdateSettings':
        return updateSettings(ctx, request as $1.UpdateSettingsRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => AdminServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => AdminServiceBase$messageJson;
}

abstract class MembershipServiceBase extends $pb.GeneratedService {
  $async.Future<$1.UpdateProfileResponse> updateProfile(
      $pb.ServerContext ctx, $1.UpdateProfileRequest request);
  $async.Future<$1.PreviewInviteResponse> previewInvite(
      $pb.ServerContext ctx, $1.PreviewInviteRequest request);
  $async.Future<$1.AcceptInviteResponse> acceptInvite(
      $pb.ServerContext ctx, $1.AcceptInviteRequest request);
  $async.Future<$1.GetMembershipResponse> getMembership(
      $pb.ServerContext ctx, $1.GetMembershipRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'UpdateProfile':
        return $1.UpdateProfileRequest();
      case 'PreviewInvite':
        return $1.PreviewInviteRequest();
      case 'AcceptInvite':
        return $1.AcceptInviteRequest();
      case 'GetMembership':
        return $1.GetMembershipRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'UpdateProfile':
        return updateProfile(ctx, request as $1.UpdateProfileRequest);
      case 'PreviewInvite':
        return previewInvite(ctx, request as $1.PreviewInviteRequest);
      case 'AcceptInvite':
        return acceptInvite(ctx, request as $1.AcceptInviteRequest);
      case 'GetMembership':
        return getMembership(ctx, request as $1.GetMembershipRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json =>
      MembershipServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => MembershipServiceBase$messageJson;
}

abstract class MlsServiceBase extends $pb.GeneratedService {
  $async.Future<$1.RegisterMlsDeviceResponse> registerMlsDevice(
      $pb.ServerContext ctx, $1.RegisterMlsDeviceRequest request);
  $async.Future<$1.ListMlsDevicesResponse> listMlsDevices(
      $pb.ServerContext ctx, $1.ListMlsDevicesRequest request);
  $async.Future<$1.GetMlsChannelResponse> getMlsChannel(
      $pb.ServerContext ctx, $1.GetMlsChannelRequest request);
  $async.Future<$1.PublishMlsResponse> publishMls(
      $pb.ServerContext ctx, $1.PublishMlsRequest request);
  $async.Future<$1.ListMlsEnvelopesResponse> listMlsEnvelopes(
      $pb.ServerContext ctx, $1.ListMlsEnvelopesRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'RegisterMlsDevice':
        return $1.RegisterMlsDeviceRequest();
      case 'ListMlsDevices':
        return $1.ListMlsDevicesRequest();
      case 'GetMlsChannel':
        return $1.GetMlsChannelRequest();
      case 'PublishMls':
        return $1.PublishMlsRequest();
      case 'ListMlsEnvelopes':
        return $1.ListMlsEnvelopesRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'RegisterMlsDevice':
        return registerMlsDevice(ctx, request as $1.RegisterMlsDeviceRequest);
      case 'ListMlsDevices':
        return listMlsDevices(ctx, request as $1.ListMlsDevicesRequest);
      case 'GetMlsChannel':
        return getMlsChannel(ctx, request as $1.GetMlsChannelRequest);
      case 'PublishMls':
        return publishMls(ctx, request as $1.PublishMlsRequest);
      case 'ListMlsEnvelopes':
        return listMlsEnvelopes(ctx, request as $1.ListMlsEnvelopesRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => MlsServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => MlsServiceBase$messageJson;
}
