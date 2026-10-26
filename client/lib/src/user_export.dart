import 'dart:convert';
import 'dart:typed_data';
import 'package:fixnum/fixnum.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'user_export_api.dart';
export 'user_export_api.dart';
part 'user_export.freezed.dart';
part 'user_export_validation.dart';

@freezed
abstract class UserExportState with _$UserExportState {
  const factory UserExportState({@Default(false) bool busy,@Default(false) bool revoked,
    @Default(false) bool saved,@Default('') String document,@Default(0) int count,Object? error})=_UserExportState;
}

class UserExportController extends Cubit<UserExportState> {
  UserExportController(this.api,{required Set<String> channels,required this.available,required this.write})
    :channels=Set.unmodifiable(channels),scope=api.scopeId,super(const UserExportState());
  final UserExportApi api;
  final String scope;
  final Set<String> channels;
  final bool Function() available;
  final Future<void> Function(String path,Uint8List bytes) write;
  int _generation=0;
  void reset() {
    if(isClosed||state.busy||state.revoked) return;
    ++_generation;emit(const UserExportState());
  }
  void invalidate() {
    if(isClosed||state.revoked) return;
    ++_generation;emit(const UserExportState(revoked:true));
  }
  bool _current(int generation) {
    if(isClosed||generation!=_generation) return false;
    if(api.scopeId!=scope||!available()) invalidate();
    return !state.revoked;
  }
  Future<void> prepare(ExportUserContentRequest request) async {
    if(!_current(_generation)||state.busy) return;
    final generation=++_generation;
    final selection=request.deepCopy()..freeze();
    emit(const UserExportState(busy:true));
    try {
      final response=await api.export(selection).timeout(const Duration(seconds:15));
      if(!_current(generation)) return;
      final document=checkedUserExport(response,api,channels,selection);
      emit(UserExportState(document:document,count:response.entries.length));
    } catch(error) {
      if(_current(generation)) emit(UserExportState(error:error));
    }
  }
  Future<void> save(String path) async {
    if(!_current(_generation)||state.busy||state.document.isEmpty) return;
    final generation=++_generation,before=state;
    emit(before.copyWith(busy:true,error:null,saved:false));
    try {
      await write(path,Uint8List.fromList(utf8.encode(before.document)));
      if(_current(generation)) emit(before.copyWith(saved:true,error:null));
    } catch(error) {
      if(_current(generation)) emit(before.copyWith(error:error,saved:false));
    }
  }
  @override Future<void> close(){++_generation;return super.close();}
}
