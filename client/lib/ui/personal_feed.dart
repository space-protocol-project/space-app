import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../l10n/strings.dart';
import '../src/feed_api.dart';
import '../src/participant_follows.dart';
import '../src/participant_profiles.dart';
import 'feed.dart' show FeedEntryCard,feedError;
import 'feed_social.dart';
import 'forum_widgets.dart' show forumAuthor;
import 'participant_profile.dart';

Future<PersonalFeedEntry?> showPersonalFeed(BuildContext context,{
  required ParticipantFollowApi api,required FeedApi feed,required ParticipantProfiles? profiles,
  required Set<String> channels,required bool Function() available,required Stream<Object?> changes,
  required FollowPageKind kind,
})=>showDialog<PersonalFeedEntry>(context:context,builder:(_)=>PersonalFeedDialog(
  api:api,feed:feed,profiles:profiles,channels:channels,available:available,changes:changes,kind:kind));

class PersonalFeedDialog extends StatefulWidget {
  const PersonalFeedDialog({super.key,required this.api,required this.feed,required this.profiles,
    required this.channels,required this.available,required this.changes,required this.kind});
  final ParticipantFollowApi api;
  final FeedApi feed;
  final ParticipantProfiles? profiles;
  final Set<String> channels;
  final bool Function() available;
  final Stream<Object?> changes;
  final FollowPageKind kind;
  @override
  State<PersonalFeedDialog> createState()=>_PersonalFeedDialogState();
}

class _PersonalFeedDialogState extends State<PersonalFeedDialog> with WidgetsBindingObserver {
  late FollowPageKind kind=widget.kind;
  late FollowTimelineController controller;
  Timer? timer;
  StreamSubscription<Object?>? subscription;
  bool foreground=true;
  void _create() {
    controller=FollowTimelineController(widget.api,kind,channels:widget.channels,
      available:()=>mounted&&foreground&&widget.available());
    unawaited(controller.refresh());
  }
  @override
  void initState() {
    super.initState();WidgetsBinding.instance.addObserver(this);_create();
    subscription=widget.changes.listen((_){if (!widget.available()) controller.invalidate();});
    timer=Timer.periodic(const Duration(seconds:10),(_)=>unawaited(controller.refresh()));
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    foreground=state!=AppLifecycleState.paused&&state!=AppLifecycleState.hidden;
    if (!foreground) controller.invalidate();
  }
  void _switch(FollowPageKind value) {
    if (value==kind) return;
    unawaited(controller.close());setState((){kind=value;_create();});
  }
  @override
  void dispose() {timer?.cancel();unawaited(subscription?.cancel());unawaited(controller.close());WidgetsBinding.instance.removeObserver(this);super.dispose();}
  @override
  Widget build(BuildContext context)=>Dialog(child:ConstrainedBox(
    constraints:const BoxConstraints(maxWidth:760),
    child:SizedBox(height:MediaQuery.sizeOf(context).height*.85,
      child:BlocBuilder<FollowTimelineController,FollowTimelineState>(bloc:controller,builder:_body))));

  Widget _body(BuildContext context,FollowTimelineState state)=>Column(children:[
    Padding(padding:const EdgeInsets.all(16),child:Row(children:[
      Expanded(child:Text(kind==FollowPageKind.posts?context.strings.personalFeed:context.strings.followingTitle,style:Theme.of(context).textTheme.titleLarge)),
      IconButton(onPressed:state.loading?null:controller.refresh,tooltip:context.strings.followRefresh,icon:const Icon(Icons.refresh)),
      IconButton(onPressed:()=>Navigator.pop(context),tooltip:context.strings.forumBack,icon:const Icon(Icons.close)),
    ])),
    Padding(padding:const EdgeInsets.symmetric(horizontal:16),child:Wrap(spacing:12,runSpacing:8,children:[
      ChoiceChip(key:const ValueKey('personal-feed-tab'),selected:kind==FollowPageKind.posts,label:Text(context.strings.personalFeed),onSelected:(_)=>_switch(FollowPageKind.posts)),
      ChoiceChip(key:const ValueKey('following-tab'),selected:kind==FollowPageKind.authors,label:Text(context.strings.followingTitle),onSelected:(_)=>_switch(FollowPageKind.authors)),
    ])),
    const SizedBox(height:12),
    if(state.loading) const LinearProgressIndicator(),
    Expanded(child:ListView(padding:const EdgeInsets.fromLTRB(16,0,16,16),children:_items(state))),
  ]);

  List<Widget> _items(FollowTimelineState state) {
    if (state.revoked) return [Text(context.strings.followRevoked)];
    if (state.error!=null) return [Text(feedError(context,state.error!))];
    return [
      if (!state.loading&&state.entries.isEmpty&&state.participants.isEmpty)
        Padding(padding:const EdgeInsets.symmetric(vertical:24),child:Text(kind==FollowPageKind.posts?context.strings.personalFeedEmpty:context.strings.followingEmpty)),
      ...state.entries.map((entry)=>_post(entry,state)),
      ...state.participants.map((person)=>_person(person,state)),
      if (state.next.isNotEmpty) TextButton(key:const ValueKey('follows-more'),onPressed:state.loading?null:controller.more,child:Text(context.strings.forumMore)),
      if (state.capped) Text(context.strings.personalFeedLimit),
    ];
  }
  Widget _person(FollowingParticipant person,FollowTimelineState state)=>Padding(
    padding:const EdgeInsets.symmetric(vertical:8),child:Row(children:[
      Expanded(child:Text(person.available?forumAuthor(person.displayName,person.principalId):context.strings.followUnavailable)),
      const SizedBox(width:12),
      IconButton(key:ValueKey('unfollow-${person.principalId}'),onPressed:state.loading?null:()=>controller.unfollow(person.principalId),tooltip:context.strings.followRemove,icon:const Icon(Icons.person_remove_outlined)),
    ]));

  Widget _post(PersonalFeedEntry entry,FollowTimelineState state) {
    final post=entry.post;
    return ParticipantProfileScope(api:widget.profiles,channel:post.channelId,
      ids:[post.authorId,if(post.hasQuotedPost()) post.quotedPost.authorId],active:foreground&&widget.available(),
      child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
        const SizedBox(height:12),
        Text(entry.channelTitle,style:Theme.of(context).textTheme.labelLarge),
        FeedEntryCard(key:ValueKey('personal-post-${post.id}'),text:post.text,author:forumAuthor(post.authorName,post.authorId),authorId:post.authorId,
          timestamp:post.createdAtUnix.toInt(),hidden:false,hiddenText:context.strings.feedHiddenPost,assets:post.attachments,
          session:widget.feed.attachmentSession,mentions:post.mentions,
          reference:post.repostOf.isEmpty?null:FeedQuote(post:post.hasQuotedPost()?post.quotedPost:null,
            open:()=>Navigator.pop(context,PersonalFeedEntry(channelTitle:entry.channelTitle,post:post.quotedPost))),
          actions:Wrap(spacing:12,runSpacing:8,children:[
            TextButton(key:ValueKey('personal-open-${post.id}'),onPressed:state.loading?null:()=>Navigator.pop(context,entry),child:Text(context.strings.personalFeedOpen)),
            IconButton(onPressed:state.loading?null:()=>controller.unfollow(post.authorId),tooltip:context.strings.followRemove,icon:const Icon(Icons.person_remove_outlined)),
          ])),
      ]));
  }
}
