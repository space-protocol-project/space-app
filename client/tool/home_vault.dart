import 'package:space_client/src/core.dart';

class HomeVault implements IdentityVault {
  Map<String, dynamic>? data;
  @override
  Future<DeviceRecord?> load(String origin) async =>
      data == null ? null : DeviceRecord.fromJson(data!);
  @override
  Future<void> save(DeviceRecord record) async {
    data = record.toJson();
  }
}
