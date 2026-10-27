import 'package:shared_preferences/shared_preferences.dart';

class KeyValueStore {
  KeyValueStore(this._prefs);

  final SharedPreferences _prefs;

  static Future<KeyValueStore> init() async {
    final prefs = await SharedPreferences.getInstance();
    return KeyValueStore(prefs);
  }

  String? getString(String key) => _prefs.getString(key);
  Future<bool> setString(String key, String value) => _prefs.setString(key, value);

  bool? getBool(String key) => _prefs.getBool(key);
  Future<bool> setBool(String key, bool value) => _prefs.setBool(key, value);

  int? getInt(String key) => _prefs.getInt(key);
  Future<bool> setInt(String key, int value) => _prefs.setInt(key, value);

  Future<bool> clear() => _prefs.clear();
}
