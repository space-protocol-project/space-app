// Copyright Space contributors. SPDX-License-Identifier: MIT
import 'dart:io';

import 'package:hooks/hooks.dart';
import 'package:code_assets/code_assets.dart';

Future<void> main(List<String> args) => build(args, (input, output) async {
  if (!input.config.buildCodeAssets) return;
  final config = input.config.code;
  final target = rustTarget(config);
  final root = input.packageRoot.resolve('../../native/space_directory_noise/');
  final manifest = root.resolve('Cargo.toml');
  final targetDirectory =
      Platform.environment['CARGO_TARGET_DIR'] ??
      input.outputDirectory.resolve('rust/').toFilePath();
  final environment = <String, String>{'CARGO_TARGET_DIR': targetDirectory};
  if (config.targetOS == OS.macOS) {
    environment['SDKROOT'] = await macosSdkPath();
  }
  if (config.targetOS == OS.android) {
    final linker = androidLinker(config);
    environment['CARGO_TARGET_${target.toUpperCase().replaceAll('-', '_')}_LINKER'] =
        linker;
    // cc-rs (ring) не использует CARGO_TARGET_*_LINKER для компиляции C.
    environment['CC_${target.replaceAll('-', '_')}'] = linker;
    environment['AR_${target.replaceAll('-', '_')}'] = config
        .cCompiler!
        .compiler
        .resolve('llvm-ar${Platform.isWindows ? '.exe' : ''}')
        .toFilePath();
  }
  await ensureToolchain(root.toFilePath(), environment);
  await run(
    'rustup',
    ['target', 'add', target, '--toolchain', '1.99.1'],
    root.toFilePath(),
    environment,
  );
  await run(
    'cargo',
    [
      '+1.99.1',
      'build',
      '--locked',
      '--release',
      '--manifest-path',
      manifest.toFilePath(),
      '--target',
      target,
    ],
    root.toFilePath(),
    environment,
  );
  final filename = switch (config.targetOS) {
    OS.windows => 'space_directory_noise.dll',
    OS.macOS => 'libspace_directory_noise.dylib',
    _ => 'libspace_directory_noise.so',
  };
  final library = File.fromUri(
    Directory(targetDirectory).uri.resolve('$target/release/$filename'),
  );
  if (!await library.exists())
    throw StateError('Не найдена собранная библиотека Noise');
  output.assets.code.add(
    CodeAsset(
      package: input.packageName,
      name: 'space_directory_noise.dart',
      linkMode: DynamicLoadingBundled(),
      file: library.uri,
    ),
  );
  await addDependencies(root, output);
});

String rustTarget(CodeConfig config) =>
    switch ((config.targetOS, config.targetArchitecture)) {
      (OS.windows, Architecture.x64) => 'x86_64-pc-windows-msvc',
      (OS.linux, Architecture.x64) => 'x86_64-unknown-linux-gnu',
      (OS.macOS, Architecture.arm64) => 'aarch64-apple-darwin',
      (OS.macOS, Architecture.x64) => 'x86_64-apple-darwin',
      (OS.android, Architecture.arm64) => 'aarch64-linux-android',
      (OS.android, Architecture.arm) => 'armv7-linux-androideabi',
      (OS.android, Architecture.x64) => 'x86_64-linux-android',
      _ => throw UnsupportedError('Платформа Noise пока не поддерживается'),
    };

String androidLinker(CodeConfig config) {
  final compiler = config.cCompiler?.compiler;
  if (compiler == null) throw StateError('Для Noise нужен Android NDK');
  final triple = config.targetArchitecture == Architecture.arm
      ? 'armv7a-linux-androideabi'
      : rustTarget(config);
  final suffix = Platform.isWindows ? '.cmd' : '';
  return compiler
      .resolve('$triple${config.android.targetNdkApi}-clang$suffix')
      .toFilePath();
}

Future<String> macosSdkPath() async {
  final result = await Process.run('xcrun', [
    '--sdk',
    'macosx',
    '--show-sdk-path',
  ]);
  final path = result.stdout.toString().trim();
  if (result.exitCode != 0 || path.isEmpty || !await Directory(path).exists()) {
    throw StateError('Не найден SDK macOS: ${result.stderr}');
  }
  return path;
}

Future<void> run(
  String command,
  List<String> args,
  String directory,
  Map<String, String> environment,
) async {
  final result = await Process.run(
    command,
    args,
    workingDirectory: directory,
    environment: environment,
    runInShell: Platform.isWindows,
  );
  if (result.exitCode != 0)
    throw StateError('Ошибка сборки Noise: $command\n${result.stderr}');
}

Future<void> addDependencies(Uri root, BuildOutputBuilder output) async {
  await for (final entry in Directory.fromUri(root).list(recursive: true)) {
    if (entry is File &&
        (entry.path.endsWith('.rs') ||
            entry.path.endsWith('emoji.txt') ||
            entry.path.endsWith('.toml') ||
            entry.path.endsWith('Cargo.lock'))) {
      output.dependencies.add(entry.uri);
    }
  }
}

Future<void> ensureToolchain(
  String directory,
  Map<String, String> environment,
) async {
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
    directory,
    environment,
  );
}
