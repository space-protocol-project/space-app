import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fixnum/fixnum.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/src/preferences.dart';
import 'package:space_client/src/participant_follows_api.dart';
import 'package:space_client/ui/feed.dart';
import '../support/feed_social.dart';
import '../support/participant_follows.dart';

class FollowFeed extends SocialFeed {
  FollowFeed(){root..revision=Int64.ONE..createdAtUnix=Int64(2);}
  final follow=FakeFollows();
  @override ParticipantFollowApi get follows=>follow;
}

void main() {
  enableFlutterDriverExtension();SharedPreferences.setMockInitialValues({});
  FlutterError.onError=(details){debugPrint('COMMUNITY_UI_ERROR: ${details.exceptionAsString()}');FlutterError.presentError(details);};
  PlatformDispatcher.instance.onError=(error,stack){debugPrint('COMMUNITY_UI_ERROR: $error');return true;};
  final api=FollowFeed();
  api.follow.load=(_) async=>ListPersonalFeedResponse(entries:api.follow.selected.isEmpty?[]:[PersonalFeedEntry(channelTitle:'Сообщество',post:api.root.deepCopy())],revision:Int64(api.follow.revision));
  runApp(MaterialApp(debugShowCheckedModeBanner:false,theme:AppPreferences().theme,locale:const Locale('ru'),supportedLocales:AppLocalizations.supportedLocales,
    localizationsDelegates:AppLocalizations.localizationsDelegates,home:Scaffold(body:FeedArea(api:api))));
  WidgetsBinding.instance.addPostFrameCallback((_){Timer(const Duration(seconds:1),()=>debugPrint('COMMUNITY_UI_READY'));});
}
