import 'dart:io';

void main(List<String> args) {
  stdout.writeln('=========================================');
  stdout.writeln('  Atlas Monorepo Setup (com.atlas.chat)  ');
  stdout.writeln('=========================================');
  stdout.writeln('Verifying workspace packages...');

  final expected = [
    'apps/atlas',
    'packages/core',
    'packages/design_system',
    'packages/logger',
    'packages/routing',
    'packages/storage',
  ];

  for (final path in expected) {
    final exists = Directory(path).existsSync();
    stdout.writeln('  [${exists ? "OK" : "MISSING"}] $path');
  }

  stdout.writeln('\nRun `flutter pub get` or `dart run melos bootstrap` to link workspace packages.');
}
