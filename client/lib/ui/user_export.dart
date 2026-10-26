import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../l10n/strings.dart';
import '../src/chat_controller.dart';
import '../src/user_export_file.dart';
import '../src/user_export.dart';
import '../src/generated/space/v1/space.pb.dart' show Channel;
import 'feed.dart' show feedError;

class UserExportButton extends StatelessWidget {
  const UserExportButton({super.key,required this.parent});
  final ChatController parent;
  void _open(BuildContext context) {
    final api=parent.userExport;
    if(api==null) return;
    final scope=api.scopeId,catalog=_exportCatalog(parent);
    bool available()=>parent.connected&&!parent.accessRemoved&&parent.userExport?.scopeId==scope&&_exportCatalog(parent)==catalog;
    final channels=parent.channels.map((c)=>c.deepCopy()..freeze()).toList(growable:false);
    unawaited(showDialog<void>(context:context,builder:(_)=>UserExportDialog(api:api,channels:channels,available:available,changes:parent.stream)));
  }
  @override Widget build(BuildContext context)=>BlocBuilder<ChatController,ChatState>(bloc:parent,builder:(context,_) {
    if(parent.userExport==null) return const SizedBox.shrink();
    return Padding(padding:const EdgeInsets.only(top:20),child:OutlinedButton.icon(
      key:const ValueKey('open-user-export'),onPressed:()=>_open(context),
      icon:const Icon(Icons.download_outlined),label:Text(context.strings.userExportTitle)));
  });
}

class UserExportDialog extends StatefulWidget {
  const UserExportDialog({super.key,required this.api,required this.channels,required this.available,this.changes,this.chooseDestination});
  final UserExportApi api;
  final List<Channel> channels;
  final bool Function() available;
  final Stream<Object?>? changes;
  final Future<String?> Function()? chooseDestination;
  @override State<UserExportDialog> createState()=>_UserExportDialogState();
}
class _UserExportDialogState extends State<UserExportDialog> with WidgetsBindingObserver {
  final after=TextEditingController(),before=TextEditingController();
  String channel='';
  bool choosing=false;
  final files=UserExportFileService();
  StreamSubscription<Object?>? subscription;
  late final api=widget.api;
  late final scope=api.scopeId;
  late final controller=UserExportController(api,channels:_exportChannels(widget.channels).map((c)=>c.id).toSet(),available:_available,
    write:(path,bytes)=>files.write(path,bytes));
  bool _available()=>mounted&&api.scopeId==scope&&widget.available();
  void _changed(){if(!_available()) controller.invalidate();}
  @override void initState(){super.initState();WidgetsBinding.instance.addObserver(this);subscription=widget.changes?.listen((_)=>_changed());}
  @override void didChangeAppLifecycleState(AppLifecycleState state){if(state!=AppLifecycleState.resumed&&!choosing) controller.invalidate();}
  @override void dispose(){unawaited(subscription?.cancel());WidgetsBinding.instance.removeObserver(this);after.dispose();before.dispose();unawaited(controller.close());super.dispose();}
  Future<void> _prepare() async {
    try {await controller.prepare(userExportSelection(channel,after.text,before.text));}
    catch(error) {if(mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text(context.strings.userExportInvalidPeriod)));}
  }
  Future<void> _save() async {
    if(choosing) return;
    choosing=true;
    try {
      final path=await (widget.chooseDestination??_destination)();
      if(path!=null) await _saveSelected(path);
    } catch(error) {
      if(mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text(feedError(context,error))));
    } finally {choosing=false;}
  }
  Future<void> _saveSelected(String path) async {
    if(!_available()||controller.state.revoked||controller.state.document.isEmpty) {await files.discard(path);return;}
    await controller.save(path);
  }
  Future<String?> _destination()=>files.choose('space-user-content-${DateTime.now().millisecondsSinceEpoch}.json');
  @override Widget build(BuildContext context)=>BlocBuilder<UserExportController,UserExportState>(bloc:controller,builder:_body);
  Widget _body(BuildContext context,UserExportState state)=>Dialog(child:ConstrainedBox(
    constraints:BoxConstraints(maxWidth:640,maxHeight:MediaQuery.sizeOf(context).height*.9),
    child:SingleChildScrollView(padding:const EdgeInsets.all(24),child:Column(mainAxisSize:MainAxisSize.min,crossAxisAlignment:CrossAxisAlignment.stretch,children:[
      Row(children:[Expanded(child:Text(context.strings.userExportTitle,style:Theme.of(context).textTheme.titleLarge)),
        IconButton(onPressed:state.busy?null:()=>Navigator.pop(context),tooltip:context.strings.close,icon:const Icon(Icons.close))]),
      const SizedBox(height:12),Text(context.strings.userExportHelp),const SizedBox(height:20),
      ..._selection(state),const SizedBox(height:20),..._result(state),
    ]))));
  List<Widget> _selection(UserExportState state)=>[
    DropdownButtonFormField<String>(initialValue:channel,isExpanded:true,
      decoration:InputDecoration(labelText:context.strings.userExportSection),
      items:[DropdownMenuItem(value:'',child:Text(context.strings.userExportAll)),
        for(final c in _exportChannels(widget.channels))
          DropdownMenuItem(value:c.id,child:Text(c.title,overflow:TextOverflow.ellipsis))],
      onChanged:state.busy||state.revoked?null:(value){channel=value??'';controller.reset();}),
    const SizedBox(height:16),
    TextField(key:const ValueKey('export-after'),controller:after,enabled:!state.busy&&!state.revoked,
      onChanged:(_)=>controller.reset(),decoration:InputDecoration(labelText:context.strings.userExportAfter,hintText:'YYYY-MM-DD')),
    const SizedBox(height:16),
    TextField(key:const ValueKey('export-before'),controller:before,enabled:!state.busy&&!state.revoked,
      onChanged:(_)=>controller.reset(),decoration:InputDecoration(labelText:context.strings.userExportBefore,hintText:'YYYY-MM-DD')),
  ];
  List<Widget> _result(UserExportState state)=>[
    if(state.revoked) Text(context.strings.followRevoked),
    if(state.error!=null) Text(feedError(context,state.error!)),
    if(state.busy) const LinearProgressIndicator(),
    if(state.document.isNotEmpty) Text('${context.strings.userExportReady}: ${state.count}'),
    if(state.saved) Text(context.strings.userExportSaved),
    const SizedBox(height:16),
    Wrap(spacing:12,runSpacing:12,children:[
      OutlinedButton(key:const ValueKey('prepare-user-export'),onPressed:state.busy||state.revoked?null:_prepare,child:Text(context.strings.userExportPrepare)),
      FilledButton(key:const ValueKey('save-user-export'),onPressed:state.busy||state.revoked||state.document.isEmpty?null:_save,child:Text(context.strings.userExportSave)),
    ]),
  ];
}

String _exportCatalog(ChatController parent)=>parent.channels.map((c)=>'${c.id}:${c.revision}:${c.archived}:${c.permissions.read}:${c.permissions.visible}:${c.mlsGroupId}').join('|');
Iterable<Channel> _exportChannels(List<Channel> channels)=>channels.where((c)=>c.permissions.read&&c.permissions.visible&&!c.archived&&c.mlsGroupId.isEmpty&&c.views.any((view)=>['chat','forum','feed'].contains(view.type)));

