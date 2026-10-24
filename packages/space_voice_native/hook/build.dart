import 'dart:io';

import 'package:hooks/hooks.dart';
import 'package:code_assets/code_assets.dart';

Future<void> main(List<String> args) => build(args, (input, output) async {
  if (!input.config.buildCodeAssets) return;
  final config = input.config.code;
  final target = rustTarget(config);
  final root = input.packageRoot.resolve('../../native/space_voice/');
  final directory =
      Platform.environment['SPACE_VOICE_TARGET_DIR'] ??
      root.resolve('../../.local/voice-native/').toFilePath();
  final environment = <String, String>{'CARGO_TARGET_DIR': directory};
  if (config.targetOS == OS.android) {
    final compiler = config.cCompiler?.compiler;
    if (compiler == null) throw StateError('Не найден Android NDK');
    final triple = config.targetArchitecture == Architecture.arm
        ? 'armv7a-linux-androideabi'
        : target;
    final suffix = Platform.isWindows ? '.cmd' : '';
    environment['CARGO_TARGET_${target.toUpperCase().replaceAll('-', '_')}_LINKER'] =
        compiler
            .resolve('$triple${config.android.targetNdkApi}-clang$suffix')
            .toFilePath();
    environment['CC_${target.replaceAll('-', '_')}'] = compiler
        .resolve('$triple${config.android.targetNdkApi}-clang$suffix')
        .toFilePath();
    environment['AR_${target.replaceAll('-', '_')}'] = compiler
        .resolve(Platform.isWindows ? 'llvm-ar.exe' : 'llvm-ar')
        .toFilePath();
  }
  await ensureToolchain(root, environment);
  await run(
    'rustup',
    ['target', 'add', target, '--toolchain', '1.99.1'],
    root,
    environment,
  );
  await run(
    'cargo',
    ['+1.99.1', 'build', '--locked', '--release', '--target', target],
    root,
    environment,
  );
  final filename = switch (config.targetOS) {
    OS.windows => 'space_voice.dll',
    OS.macOS => 'libspace_voice.dylib',
    _ => 'libspace_voice.so',
  };
  final library = Directory(directory).uri.resolve('$target/release/$filename');
  if (!await File.fromUri(library).exists())
    throw StateError('Не найдена библиотека голоса');
  output.assets.code.add(
    CodeAsset(
      package: input.packageName,
      name: 'space_voice_native.dart',
      linkMode: DynamicLoadingBundled(),
      file: library,
    ),
  );
  for (final name in [
    'Cargo.toml',
    'Cargo.lock',
    'src/lib.rs',
    'src/processor.rs',
    'src/worker.rs',
  ]) {
    output.dependencies.add(root.resolve(name));
  }
  await for (final entry in Directory.fromUri(
    root.resolve('vendor/'),
  ).list(recursive: true)) {
    if (entry is File) output.dependencies.add(entry.uri);
  }
});

String rustTarget(CodeConfig config) => switch ((
  config.targetOS,
  config.targetArchitecture,
)) {
  (OS.windows, Architecture.x64) => 'x86_64-pc-windows-msvc',
  (OS.linux, Architecture.x64) => 'x86_64-unknown-linux-gnu',
  (OS.macOS, Architecture.arm64) => 'aarch64-apple-darwin',
  (OS.macOS, Architecture.x64) => 'x86_64-apple-darwin',
  (OS.android, Architecture.arm64) => 'aarch64-linux-android',
  (OS.android, Architecture.arm) => 'armv7-linux-androideabi',
  (OS.android, Architecture.x64) => 'x86_64-linux-android',
  _ => throw UnsupportedError('Платформа обработки голоса не поддерживается'),
};

Future<void> run(
  String command,
  List<String> args,
  Uri root,
  Map<String, String> environment,
) async {
  final result = await Process.run(
    command,
    args,
    workingDirectory: root.toFilePath(),
    environment: environment,
    runInShell: Platform.isWindows,
  );
  if (result.exitCode != 0)
    throw StateError('Ошибка сборки голоса: $command\n${result.stderr}');
}

Future<void> ensureToolchain(Uri root, Map<String, String> environment) async {
  final installed = await Process.run(
    'rustup',
    ['run', '1.99.1', 'rustc', '--version'],
    environment: environment,
    runInShell: Platform.isWindows,
  );
  if (installed.exitCode == 0) return;
  await run(
    'rustup',
    [
      'toolchain',
      'install',
      '1.99.1',
      '--profile',
      'minimal',
      '--no-self-update',
    ],
    root,
    environment,
  );
}
