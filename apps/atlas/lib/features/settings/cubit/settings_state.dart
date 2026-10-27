import 'package:equatable/equatable.dart';

enum AtlasTextSize {
  small('S', 0.90),
  medium('Default', 1.00),
  large('Large', 1.10);

  const AtlasTextSize(this.label, this.scaleFactor);
  final String label;
  final double scaleFactor;
}

class SettingsState extends Equatable {
  const SettingsState({
    this.isDarkMode = false,
    this.textSize = AtlasTextSize.medium,
    this.agentApprovals = true,
    this.showWorkflowProgress = true,
    this.apiKeyRevealed = false,
    this.plainApiKey = 'cline_api_key_••••••••4f2a',
  });

  final bool isDarkMode;
  final AtlasTextSize textSize;
  final bool agentApprovals;
  final bool showWorkflowProgress;
  final bool apiKeyRevealed;
  final String plainApiKey;

  double get textScaleFactor => textSize.scaleFactor;

  String get displayApiKey => apiKeyRevealed
      ? '$plainApiKey (tap to hide)'
      : '••••••••••••••••4f2a';

  SettingsState copyWith({
    bool? isDarkMode,
    AtlasTextSize? textSize,
    bool? agentApprovals,
    bool? showWorkflowProgress,
    bool? apiKeyRevealed,
    String? plainApiKey,
  }) {
    return SettingsState(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      textSize: textSize ?? this.textSize,
      agentApprovals: agentApprovals ?? this.agentApprovals,
      showWorkflowProgress: showWorkflowProgress ?? this.showWorkflowProgress,
      apiKeyRevealed: apiKeyRevealed ?? this.apiKeyRevealed,
      plainApiKey: plainApiKey ?? this.plainApiKey,
    );
  }

  Map<String, dynamic> toJson() => {
        'isDarkMode': isDarkMode,
        'textSize': textSize.name,
        'agentApprovals': agentApprovals,
        'showWorkflowProgress': showWorkflowProgress,
      };

  @override
  List<Object?> get props => [
        isDarkMode,
        textSize,
        agentApprovals,
        showWorkflowProgress,
        apiKeyRevealed,
        plainApiKey,
      ];
}
