import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  LicenseRegistry.addLicense(() async* {
    for (final entry in {
      'Nunito': 'Nunito',
      'Nunito Sans': 'NunitoSans',
      'JetBrains Mono': 'JetBrainsMono',
    }.entries) {
      yield LicenseEntryWithLineBreaks([
        entry.key,
      ], await rootBundle.loadString('assets/fonts/${entry.value}-OFL.txt'));
    }
  });
  runApp(const SpaceApp());
}
