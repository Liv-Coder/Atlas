enum AtlasMode {
  plan(
    id: 'plan',
    chipLabel: 'PLAN',
    displayName: 'Plan',
    description: 'Thinks first — outlines steps and drafts before anything runs.',
    placeholder: 'Ask anything',
  ),
  chat(
    id: 'chat',
    chipLabel: 'CHAT',
    displayName: 'Chat',
    description: 'Everyday conversation and quick answers, no planning overhead.',
    placeholder: 'Message Atlas…',
  ),
  agent(
    id: 'agent',
    chipLabel: 'AGENT',
    displayName: 'Agent',
    description:
        'Professional workflow — goal → plan → gather → execute → verify, with live progress and approval before external actions.',
    placeholder: 'Describe a goal for Atlas…',
  );

  const AtlasMode({
    required this.id,
    required this.chipLabel,
    required this.displayName,
    required this.description,
    required this.placeholder,
  });

  final String id;
  final String chipLabel;
  final String displayName;
  final String description;
  final String placeholder;

  static AtlasMode fromId(String? id) {
    return AtlasMode.values.firstWhere(
      (m) => m.id == id,
      orElse: () => AtlasMode.plan,
    );
  }
}
