import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storage/storage.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit({
    required HiveStorageService storageService,
    required SecureKeyStore secureKeyStore,
  })  : _storage = storageService,
        _secureKeyStore = secureKeyStore,
        super(const SettingsState());

  final HiveStorageService _storage;
  final SecureKeyStore _secureKeyStore;

  Future<void> loadSettings() async {
    final saved = _storage.readSettingsJson();
    final key = await _secureKeyStore.readApiKey();
    if (saved == null) {
      emit(state.copyWith(plainApiKey: key));
      return;
    }
    final sizeName = saved['textSize'] as String? ?? 'medium';
    final textSize = AtlasTextSize.values.firstWhere(
      (e) => e.name == sizeName,
      orElse: () => AtlasTextSize.medium,
    );
    emit(
      state.copyWith(
        isDarkMode: saved['isDarkMode'] as bool? ?? false,
        textSize: textSize,
        agentApprovals: saved['agentApprovals'] as bool? ?? true,
        showWorkflowProgress: saved['showWorkflowProgress'] as bool? ?? true,
        plainApiKey: key,
      ),
    );
  }

  void setDarkMode(bool isDark) {
    emit(state.copyWith(isDarkMode: isDark));
    _persist();
  }

  void setTextSize(AtlasTextSize size) {
    emit(state.copyWith(textSize: size));
    _persist();
  }

  void toggleAgentApprovals() {
    emit(state.copyWith(agentApprovals: !state.agentApprovals));
    _persist();
  }

  void toggleWorkflowProgress() {
    emit(state.copyWith(showWorkflowProgress: !state.showWorkflowProgress));
    _persist();
  }

  void toggleApiKeyVisibility() {
    emit(state.copyWith(apiKeyRevealed: !state.apiKeyRevealed));
  }

  Future<void> updateApiKey(String newKey) async {
    await _secureKeyStore.writeApiKey(newKey);
    emit(state.copyWith(plainApiKey: newKey.trim(), apiKeyRevealed: false));
  }

  void _persist() {
    _storage.writeSettingsJson(state.toJson());
  }
}
