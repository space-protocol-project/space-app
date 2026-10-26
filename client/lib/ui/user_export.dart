import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fixnum/fixnum.dart';
import '../l10n/strings.dart';
import '../src/chat_controller.dart';
import '../src/file_picker.dart';
import '../src/user_export.dart';
import 'feed.dart' show feedError;

class UserExportButton extends StatelessWidget {
  const UserExportButton({super.key,required this.parent});
  final ChatController parent;
  @override Widget build(BuildContext context)=>ListenableBuilder(listenable:parent,builder:(context,_) {
    if(parent.userExport==null) return const SizedBox.shrink();
    return Padding(padding:const EdgeInsets.only(top:20),child:OutlinedButton.icon(
      key:const ValueKey('open-user-export'),onPressed:()=>showDialog<void>(context:context,builder:(_)=>UserExportDialog(parent:parent)),
      icon:const Icon(Icons.download_outlined),label:Text(context.strings.userExportTitle)));
  });
}

class UserExportDialog extends StatefulWidget {
  const UserExportDialog({super.key,required this.parent});
  final ChatController parent;
  @override State<UserExportDialog> createState()=>_UserExportDialogState();
}
class _UserExportDialogState extends State<UserExportDialog> with WidgetsBindingObserver {
  final after=TextEditingController(),before=TextEditingController();
  String channel='';
  late final api=widget.parent.userExport!;
  late final scope=api.scopeId;
  late final catalog=_catalog();
  late final controller=UserExportController(api,channels:widget.parent.channels.map((c)=>c.id).toSet(),available:_available,
    write:(path,bytes)=>SpaceFile.fromData(bytes,mimeType:'application/json',name:'space-user-content.json').saveTo(path));
  String _catalog()=>widget.parent.channels.map((c)=>'${c.id}:${c.revision}:${c.archived}:${c.permissions.read}:${c.permissions.visible}:${c.mlsGroupId}').join('|');
  bool _available()=>mounted&&widget.parent.connected&&!widget.parent.accessRemoved&&widget.parent.userExport?.scopeId==scope&&_catalog()==catalog;
  void _changed(){if(!_available()) controller.invalidate();}
  @override void initState(){super.initState();WidgetsBinding.instance.addObserver(this);widget.parent.addListener(_changed);}
  @override void didChangeAppLifecycleState(AppLifecycleState state){if(state!=AppLifecycleState.resumed) controller.invalidate();}
  @override void dispose(){widget.parent.removeListener(_changed);WidgetsBinding.instance.removeObserver(this);after.dispose();before.dispose();unawaited(controller.close());super.dispose();}
  Future<void> _prepare() async {
    try {await controller.prepare(userExportSelection(channel,after.text,before.text));}
    catch(error) {if(mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text(context.strings.userExportInvalidPeriod)));}
  }
  Future<void> _save() async {
    final destination=await getSaveLocation(suggestedName:'space-user-content-${DateTime.now().millisecondsSinceEpoch}.json',
      acceptedTypeGroups:const [XTypeGroup(label:'JSON',extensions:['json'])]);
    if(destination!=null) await controller.save(destination.path);
  }
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
        for(final c in widget.parent.channels.where((c)=>c.permissions.read&&c.mlsGroupId.isEmpty&&!c.archived))
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

ExportUserContentRequest userExportSelection(String channel,String after,String before) {
  final start=_exportDate(after),end=_exportDate(before)?.add(const Duration(days:1));
  if(start!=null&&end!=null&&!start.isBefore(end)) throw const FormatException('Некорректный период');
  return ExportUserContentRequest(channelId:channel,createdAfterUnixMs:Int64(start?.millisecondsSinceEpoch??0),createdBeforeUnixMs:Int64(end?.millisecondsSinceEpoch??0));
}
DateTime? _exportDate(String input) {
  final text=input.trim();if(text.isEmpty) return null;
  if(!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(text)) throw const FormatException('Нужна дата YYYY-MM-DD');
  final date=DateTime.tryParse('${text}T00:00:00Z');
  if(date==null||date.year<1970||date.toIso8601String().substring(0,10)!=text) throw const FormatException('Некорректная дата');
  return date;
}
