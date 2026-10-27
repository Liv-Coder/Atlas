import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureKeyStore {
  const SecureKeyStore([
    this._storage = const FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
    ),
  ]);

  final FlutterSecureStorage _storage;

  static const String _apiKeyStorageKey = 'atlas_provider_api_key';
  static const String defaultMaskedKey = '••••••••••••••••4f2a';
  static const String defaultDemoPlainKey = 'cline_api_key_••••••••4f2a';

  Future<String> readApiKey() async {
    try {
      final value = await _storage.read(key: _apiKeyStorageKey);
      if (value == null || value.isEmpty) {
        return defaultDemoPlainKey;
      }
      return value;
    } catch (_) {
      return defaultDemoPlainKey;
    }
  }

  Future<void> writeApiKey(String apiKey) async {
    await _storage.write(key: _apiKeyStorageKey, value: apiKey.trim());
  }
}
