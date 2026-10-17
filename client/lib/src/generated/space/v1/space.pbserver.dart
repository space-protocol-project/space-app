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

import 'space.pb.dart' as $0;
import 'space.pbjson.dart';

export 'space.pb.dart';

abstract class ChannelServiceBase extends $pb.GeneratedService {
  $async.Future<$0.WatchChannelsResponse> watchChannels(
      $pb.ServerContext ctx, $0.WatchChannelsRequest request);
  $async.Future<$0.ListChannelsResponse> listChannels(
      $pb.ServerContext ctx, $0.ListChannelsRequest request);
  $async.Future<$0.CreateChannelResponse> createChannel(
      $pb.ServerContext ctx, $0.CreateChannelRequest request);
  $async.Future<$0.UpdateChannelResponse> updateChannel(
      $pb.ServerContext ctx, $0.UpdateChannelRequest request);
  $async.Future<$0.DeleteChannelResponse> deleteChannel(
      $pb.ServerContext ctx, $0.DeleteChannelRequest request);
  $async.Future<$0.GetChannelAccessResponse> getChannelAccess(
      $pb.ServerContext ctx, $0.GetChannelAccessRequest request);
  $async.Future<$0.UpdateChannelAccessResponse> updateChannelAccess(
      $pb.ServerContext ctx, $0.UpdateChannelAccessRequest request);
  $async.Future<$0.GetManifestResponse> getManifest(
      $pb.ServerContext ctx, $0.GetManifestRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'WatchChannels':
        return $0.WatchChannelsRequest();
      case 'ListChannels':
        return $0.ListChannelsRequest();
      case 'CreateChannel':
        return $0.CreateChannelRequest();
      case 'UpdateChannel':
        return $0.UpdateChannelRequest();
      case 'DeleteChannel':
        return $0.DeleteChannelRequest();
      case 'GetChannelAccess':
        return $0.GetChannelAccessRequest();
      case 'UpdateChannelAccess':
        return $0.UpdateChannelAccessRequest();
      case 'GetManifest':
        return $0.GetManifestRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'WatchChannels':
        return watchChannels(ctx, request as $0.WatchChannelsRequest);
      case 'ListChannels':
        return listChannels(ctx, request as $0.ListChannelsRequest);
      case 'CreateChannel':
        return createChannel(ctx, request as $0.CreateChannelRequest);
      case 'UpdateChannel':
        return updateChannel(ctx, request as $0.UpdateChannelRequest);
      case 'DeleteChannel':
        return deleteChannel(ctx, request as $0.DeleteChannelRequest);
      case 'GetChannelAccess':
        return getChannelAccess(ctx, request as $0.GetChannelAccessRequest);
      case 'UpdateChannelAccess':
        return updateChannelAccess(
            ctx, request as $0.UpdateChannelAccessRequest);
      case 'GetManifest':
        return getManifest(ctx, request as $0.GetManifestRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => ChannelServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => ChannelServiceBase$messageJson;
}

abstract class ContentServiceBase extends $pb.GeneratedService {
  $async.Future<$0.GetHistoryPageResponse> getHistoryPage(
      $pb.ServerContext ctx, $0.GetHistoryPageRequest request);
  $async.Future<$0.SearchContentResponse> searchContent(
      $pb.ServerContext ctx, $0.SearchContentRequest request);
  $async.Future<$0.ApplyContentMutationResponse> applyContentMutation(
      $pb.ServerContext ctx, $0.ApplyContentMutationRequest request);
  $async.Future<$0.SetReactionResponse> setReaction(
      $pb.ServerContext ctx, $0.SetReactionRequest request);
  $async.Future<$0.UpdateContentResponse> updateContent(
      $pb.ServerContext ctx, $0.UpdateContentRequest request);
  $async.Future<$0.DeleteContentResponse> deleteContent(
      $pb.ServerContext ctx, $0.DeleteContentRequest request);
  $async.Future<$0.CreateContentResponse> createContent(
      $pb.ServerContext ctx, $0.CreateContentRequest request);
  $async.Future<$0.ListContentResponse> listContent(
      $pb.ServerContext ctx, $0.ListContentRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'GetHistoryPage':
        return $0.GetHistoryPageRequest();
      case 'SearchContent':
        return $0.SearchContentRequest();
      case 'ApplyContentMutation':
        return $0.ApplyContentMutationRequest();
      case 'SetReaction':
        return $0.SetReactionRequest();
      case 'UpdateContent':
        return $0.UpdateContentRequest();
      case 'DeleteContent':
        return $0.DeleteContentRequest();
      case 'CreateContent':
        return $0.CreateContentRequest();
      case 'ListContent':
        return $0.ListContentRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'GetHistoryPage':
        return getHistoryPage(ctx, request as $0.GetHistoryPageRequest);
      case 'SearchContent':
        return searchContent(ctx, request as $0.SearchContentRequest);
      case 'ApplyContentMutation':
        return applyContentMutation(
            ctx, request as $0.ApplyContentMutationRequest);
      case 'SetReaction':
        return setReaction(ctx, request as $0.SetReactionRequest);
      case 'UpdateContent':
        return updateContent(ctx, request as $0.UpdateContentRequest);
      case 'DeleteContent':
        return deleteContent(ctx, request as $0.DeleteContentRequest);
      case 'CreateContent':
        return createContent(ctx, request as $0.CreateContentRequest);
      case 'ListContent':
        return listContent(ctx, request as $0.ListContentRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => ContentServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => ContentServiceBase$messageJson;
}

abstract class AssetServiceBase extends $pb.GeneratedService {
  $async.Future<$0.BeginUploadResponse> beginUpload(
      $pb.ServerContext ctx, $0.BeginUploadRequest request);
  $async.Future<$0.UploadChunkResponse> uploadChunk(
      $pb.ServerContext ctx, $0.UploadChunkRequest request);
  $async.Future<$0.CompleteUploadResponse> completeUpload(
      $pb.ServerContext ctx, $0.CompleteUploadRequest request);
  $async.Future<$0.CancelUploadResponse> cancelUpload(
      $pb.ServerContext ctx, $0.CancelUploadRequest request);
  $async.Future<$0.DownloadChunkResponse> downloadChunk(
      $pb.ServerContext ctx, $0.DownloadChunkRequest request);
  $async.Future<$0.ListMyAssetsResponse> listMyAssets(
      $pb.ServerContext ctx, $0.ListMyAssetsRequest request);
  $async.Future<$0.ListChannelAssetsResponse> listChannelAssets(
      $pb.ServerContext ctx, $0.ListChannelAssetsRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'BeginUpload':
        return $0.BeginUploadRequest();
      case 'UploadChunk':
        return $0.UploadChunkRequest();
      case 'CompleteUpload':
        return $0.CompleteUploadRequest();
      case 'CancelUpload':
        return $0.CancelUploadRequest();
      case 'DownloadChunk':
        return $0.DownloadChunkRequest();
      case 'ListMyAssets':
        return $0.ListMyAssetsRequest();
      case 'ListChannelAssets':
        return $0.ListChannelAssetsRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'BeginUpload':
        return beginUpload(ctx, request as $0.BeginUploadRequest);
      case 'UploadChunk':
        return uploadChunk(ctx, request as $0.UploadChunkRequest);
      case 'CompleteUpload':
        return completeUpload(ctx, request as $0.CompleteUploadRequest);
      case 'CancelUpload':
        return cancelUpload(ctx, request as $0.CancelUploadRequest);
      case 'DownloadChunk':
        return downloadChunk(ctx, request as $0.DownloadChunkRequest);
      case 'ListMyAssets':
        return listMyAssets(ctx, request as $0.ListMyAssetsRequest);
      case 'ListChannelAssets':
        return listChannelAssets(ctx, request as $0.ListChannelAssetsRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => AssetServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => AssetServiceBase$messageJson;
}

abstract class AuthServiceBase extends $pb.GeneratedService {
  $async.Future<$0.CreateRootRotationResponse> createRootRotation(
      $pb.ServerContext ctx, $0.CreateRootRotationRequest request);
  $async.Future<$0.CompleteRootRotationResponse> completeRootRotation(
      $pb.ServerContext ctx, $0.CompleteRootRotationRequest request);
  $async.Future<$0.ProposePairingResponse> proposePairing(
      $pb.ServerContext ctx, $0.ProposePairingRequest request);
  $async.Future<$0.CreatePairingResponse> createPairing(
      $pb.ServerContext ctx, $0.CreatePairingRequest request);
  $async.Future<$0.InspectPairingResponse> inspectPairing(
      $pb.ServerContext ctx, $0.InspectPairingRequest request);
  $async.Future<$0.PollPairingResponse> pollPairing(
      $pb.ServerContext ctx, $0.PollPairingRequest request);
  $async.Future<$0.CancelPairingResponse> cancelPairing(
      $pb.ServerContext ctx, $0.CancelPairingRequest request);
  $async.Future<$0.ClaimPairingResponse> claimPairing(
      $pb.ServerContext ctx, $0.ClaimPairingRequest request);
  $async.Future<$0.RevokeCurrentDeviceResponse> revokeCurrentDevice(
      $pb.ServerContext ctx, $0.RevokeCurrentDeviceRequest request);
  $async.Future<$0.ListDevicesResponse> listDevices(
      $pb.ServerContext ctx, $0.ListDevicesRequest request);
  $async.Future<$0.LogoutResponse> logout(
      $pb.ServerContext ctx, $0.LogoutRequest request);
  $async.Future<$0.CreateChallengeResponse> createChallenge(
      $pb.ServerContext ctx, $0.CreateChallengeRequest request);
  $async.Future<$0.CompleteChallengeResponse> completeChallenge(
      $pb.ServerContext ctx, $0.CompleteChallengeRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'CreateRootRotation':
        return $0.CreateRootRotationRequest();
      case 'CompleteRootRotation':
        return $0.CompleteRootRotationRequest();
      case 'ProposePairing':
        return $0.ProposePairingRequest();
      case 'CreatePairing':
        return $0.CreatePairingRequest();
      case 'InspectPairing':
        return $0.InspectPairingRequest();
      case 'PollPairing':
        return $0.PollPairingRequest();
      case 'CancelPairing':
        return $0.CancelPairingRequest();
      case 'ClaimPairing':
        return $0.ClaimPairingRequest();
      case 'RevokeCurrentDevice':
        return $0.RevokeCurrentDeviceRequest();
      case 'ListDevices':
        return $0.ListDevicesRequest();
      case 'Logout':
        return $0.LogoutRequest();
      case 'CreateChallenge':
        return $0.CreateChallengeRequest();
      case 'CompleteChallenge':
        return $0.CompleteChallengeRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'CreateRootRotation':
        return createRootRotation(ctx, request as $0.CreateRootRotationRequest);
      case 'CompleteRootRotation':
        return completeRootRotation(
            ctx, request as $0.CompleteRootRotationRequest);
      case 'ProposePairing':
        return proposePairing(ctx, request as $0.ProposePairingRequest);
      case 'CreatePairing':
        return createPairing(ctx, request as $0.CreatePairingRequest);
      case 'InspectPairing':
        return inspectPairing(ctx, request as $0.InspectPairingRequest);
      case 'PollPairing':
        return pollPairing(ctx, request as $0.PollPairingRequest);
      case 'CancelPairing':
        return cancelPairing(ctx, request as $0.CancelPairingRequest);
      case 'ClaimPairing':
        return claimPairing(ctx, request as $0.ClaimPairingRequest);
      case 'RevokeCurrentDevice':
        return revokeCurrentDevice(
            ctx, request as $0.RevokeCurrentDeviceRequest);
      case 'ListDevices':
        return listDevices(ctx, request as $0.ListDevicesRequest);
      case 'Logout':
        return logout(ctx, request as $0.LogoutRequest);
      case 'CreateChallenge':
        return createChallenge(ctx, request as $0.CreateChallengeRequest);
      case 'CompleteChallenge':
        return completeChallenge(ctx, request as $0.CompleteChallengeRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => AuthServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => AuthServiceBase$messageJson;
}

abstract class SyncServiceBase extends $pb.GeneratedService {
  $async.Future<$0.SubscribeResponse> subscribe(
      $pb.ServerContext ctx, $0.SubscribeRequest request);
  $async.Future<$0.ListEventsResponse> listEvents(
      $pb.ServerContext ctx, $0.ListEventsRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'Subscribe':
        return $0.SubscribeRequest();
      case 'ListEvents':
        return $0.ListEventsRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'Subscribe':
        return subscribe(ctx, request as $0.SubscribeRequest);
      case 'ListEvents':
        return listEvents(ctx, request as $0.ListEventsRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => SyncServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => SyncServiceBase$messageJson;
}

abstract class AdminServiceBase extends $pb.GeneratedService {
  $async.Future<$0.ListMembersResponse> listMembers(
      $pb.ServerContext ctx, $0.ListMembersRequest request);
  $async.Future<$0.UpdateMemberResponse> updateMember(
      $pb.ServerContext ctx, $0.UpdateMemberRequest request);
  $async.Future<$0.CreateInviteResponse> createInvite(
      $pb.ServerContext ctx, $0.CreateInviteRequest request);
  $async.Future<$0.ListInvitesResponse> listInvites(
      $pb.ServerContext ctx, $0.ListInvitesRequest request);
  $async.Future<$0.RevokeInviteResponse> revokeInvite(
      $pb.ServerContext ctx, $0.RevokeInviteRequest request);
  $async.Future<$0.GetSetupStatusResponse> getSetupStatus(
      $pb.ServerContext ctx, $0.GetSetupStatusRequest request);
  $async.Future<$0.ClaimOwnerResponse> claimOwner(
      $pb.ServerContext ctx, $0.ClaimOwnerRequest request);
  $async.Future<$0.GetSettingsResponse> getSettings(
      $pb.ServerContext ctx, $0.GetSettingsRequest request);
  $async.Future<$0.UpdateSettingsResponse> updateSettings(
      $pb.ServerContext ctx, $0.UpdateSettingsRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'ListMembers':
        return $0.ListMembersRequest();
      case 'UpdateMember':
        return $0.UpdateMemberRequest();
      case 'CreateInvite':
        return $0.CreateInviteRequest();
      case 'ListInvites':
        return $0.ListInvitesRequest();
      case 'RevokeInvite':
        return $0.RevokeInviteRequest();
      case 'GetSetupStatus':
        return $0.GetSetupStatusRequest();
      case 'ClaimOwner':
        return $0.ClaimOwnerRequest();
      case 'GetSettings':
        return $0.GetSettingsRequest();
      case 'UpdateSettings':
        return $0.UpdateSettingsRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'ListMembers':
        return listMembers(ctx, request as $0.ListMembersRequest);
      case 'UpdateMember':
        return updateMember(ctx, request as $0.UpdateMemberRequest);
      case 'CreateInvite':
        return createInvite(ctx, request as $0.CreateInviteRequest);
      case 'ListInvites':
        return listInvites(ctx, request as $0.ListInvitesRequest);
      case 'RevokeInvite':
        return revokeInvite(ctx, request as $0.RevokeInviteRequest);
      case 'GetSetupStatus':
        return getSetupStatus(ctx, request as $0.GetSetupStatusRequest);
      case 'ClaimOwner':
        return claimOwner(ctx, request as $0.ClaimOwnerRequest);
      case 'GetSettings':
        return getSettings(ctx, request as $0.GetSettingsRequest);
      case 'UpdateSettings':
        return updateSettings(ctx, request as $0.UpdateSettingsRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => AdminServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => AdminServiceBase$messageJson;
}

abstract class MembershipServiceBase extends $pb.GeneratedService {
  $async.Future<$0.UpdateProfileResponse> updateProfile(
      $pb.ServerContext ctx, $0.UpdateProfileRequest request);
  $async.Future<$0.PreviewInviteResponse> previewInvite(
      $pb.ServerContext ctx, $0.PreviewInviteRequest request);
  $async.Future<$0.AcceptInviteResponse> acceptInvite(
      $pb.ServerContext ctx, $0.AcceptInviteRequest request);
  $async.Future<$0.GetMembershipResponse> getMembership(
      $pb.ServerContext ctx, $0.GetMembershipRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'UpdateProfile':
        return $0.UpdateProfileRequest();
      case 'PreviewInvite':
        return $0.PreviewInviteRequest();
      case 'AcceptInvite':
        return $0.AcceptInviteRequest();
      case 'GetMembership':
        return $0.GetMembershipRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'UpdateProfile':
        return updateProfile(ctx, request as $0.UpdateProfileRequest);
      case 'PreviewInvite':
        return previewInvite(ctx, request as $0.PreviewInviteRequest);
      case 'AcceptInvite':
        return acceptInvite(ctx, request as $0.AcceptInviteRequest);
      case 'GetMembership':
        return getMembership(ctx, request as $0.GetMembershipRequest);
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
  $async.Future<$0.RegisterMlsDeviceResponse> registerMlsDevice(
      $pb.ServerContext ctx, $0.RegisterMlsDeviceRequest request);
  $async.Future<$0.ListMlsDevicesResponse> listMlsDevices(
      $pb.ServerContext ctx, $0.ListMlsDevicesRequest request);
  $async.Future<$0.GetMlsChannelResponse> getMlsChannel(
      $pb.ServerContext ctx, $0.GetMlsChannelRequest request);
  $async.Future<$0.PublishMlsResponse> publishMls(
      $pb.ServerContext ctx, $0.PublishMlsRequest request);
  $async.Future<$0.ListMlsEnvelopesResponse> listMlsEnvelopes(
      $pb.ServerContext ctx, $0.ListMlsEnvelopesRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'RegisterMlsDevice':
        return $0.RegisterMlsDeviceRequest();
      case 'ListMlsDevices':
        return $0.ListMlsDevicesRequest();
      case 'GetMlsChannel':
        return $0.GetMlsChannelRequest();
      case 'PublishMls':
        return $0.PublishMlsRequest();
      case 'ListMlsEnvelopes':
        return $0.ListMlsEnvelopesRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'RegisterMlsDevice':
        return registerMlsDevice(ctx, request as $0.RegisterMlsDeviceRequest);
      case 'ListMlsDevices':
        return listMlsDevices(ctx, request as $0.ListMlsDevicesRequest);
      case 'GetMlsChannel':
        return getMlsChannel(ctx, request as $0.GetMlsChannelRequest);
      case 'PublishMls':
        return publishMls(ctx, request as $0.PublishMlsRequest);
      case 'ListMlsEnvelopes':
        return listMlsEnvelopes(ctx, request as $0.ListMlsEnvelopesRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => MlsServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => MlsServiceBase$messageJson;
}
