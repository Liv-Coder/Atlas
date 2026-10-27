import 'dart:convert';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';

class HiveStorageService {
  HiveStorageService._();

  static final HiveStorageService instance = HiveStorageService._();

  static const String _sessionsBoxName = 'atlas_sessions_box';
  static const String _settingsBoxName = 'atlas_settings_box';

  Box<String>? _sessionsBox;
  Box<String>? _settingsBox;

  bool get isInitialized => _sessionsBox != null && _settingsBox != null;

  Future<void> init() async {
    if (isInitialized) return;
    try {
      await Hive.initFlutter();
      _sessionsBox = await Hive.openBox<String>(_sessionsBoxName);
      _settingsBox = await Hive.openBox<String>(_settingsBoxName);
      AppLogger.info('HiveStorageService initialized', tag: 'Storage');
    } catch (e, st) {
      AppLogger.error(
        'Failed to initialize HiveStorageService, continuing with in-memory fallback',
        tag: 'Storage',
        error: e,
        stackTrace: st,
      );
    }
  }

  List<Map<String, dynamic>> readSessionsJson() {
    final box = _sessionsBox;
    if (box == null) return const [];
    final raw = box.get('sessions_list');
    if (raw == null || raw.isEmpty) return const [];
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded.cast<Map<String, dynamic>>();
    } catch (_) {
      return const [];
    }
  }

  Future<void> writeSessionsJson(List<Map<String, dynamic>> sessions) async {
    final box = _sessionsBox;
    if (box == null) return;
    await box.put('sessions_list', jsonEncode(sessions));
  }

  Map<String, dynamic>? readSettingsJson() {
    final box = _settingsBox;
    if (box == null) return null;
    final raw = box.get('app_settings');
    if (raw == null || raw.isEmpty) return null;
    try {
      return jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  Future<void> writeSettingsJson(Map<String, dynamic> settings) async {
    final box = _settingsBox;
    if (box == null) return;
    await box.put('app_settings', jsonEncode(settings));
  }

  Future<void> clearAll() async {
    await _sessionsBox?.clear();
    await _settingsBox?.clear();
  }
}
