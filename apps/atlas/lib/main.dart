import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:storage/storage.dart';
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await HiveStorageService.instance.init();
  const secureKeyStore = SecureKeyStore();
  AppLogger.info('Starting Atlas (com.atlas.chat)', tag: 'Bootstrap');

  runApp(
    AtlasApp(
      storageService: HiveStorageService.instance,
      secureKeyStore: secureKeyStore,
    ),
  );
}
