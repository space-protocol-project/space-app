import 'dart:io';
import 'package:flutter/foundation.dart';

bool supportsHomePlatform(String operatingSystem) =>
    const {'windows', 'macos', 'linux'}.contains(operatingSystem);

bool get canHostSpace => !kIsWeb && supportsHomePlatform(Platform.operatingSystem);
