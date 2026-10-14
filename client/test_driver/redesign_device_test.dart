import 'dart:convert';
import 'dart:io';

import 'package:integration_test/integration_test_driver.dart';

Future<void> main() => integrationDriver(
  responseDataCallback: (data) async {
    if (data == null) return;
    const output = 'build/redesign_reports';
    await Directory(output).create(recursive: true);
    final platform = data['platform'];
    final screenshot = data.remove('search_screenshot') as String?;
    if (screenshot != null) {
      await File('$output/$platform-search.png')
          .writeAsBytes(base64Decode(screenshot));
    }
    await writeResponseData(
      data,
      testOutputFilename: '$platform',
      destinationDirectory: output,
    );
  },
);
