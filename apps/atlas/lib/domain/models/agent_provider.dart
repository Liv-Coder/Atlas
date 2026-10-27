import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class AgentProviderConfig extends Equatable {
  const AgentProviderConfig({
    required this.id,
    required this.provider,
    required this.model,
    required this.fullModel,
    required this.initial,
    required this.color,
    this.badge = '',
    required this.baseUrl,
  });

  final String id;
  final String provider;
  final String model;
  final String fullModel;
  final String initial;
  final Color color;
  final String badge;
  final String baseUrl;

  static const List<AgentProviderConfig> defaults = [
    AgentProviderConfig(
      id: 'cline',
      provider: 'Cline',
      model: 'minimax-m2.5',
      fullModel: 'minimax/minimax-m2.5',
      initial: 'C',
      color: Color(0xFF0E7490),
      badge: 'Connected',
      baseUrl: 'https://api.cline.bot/v1',
    ),
    AgentProviderConfig(
      id: 'openrouter',
      provider: 'OpenRouter',
      model: 'nemotron-3.5-super-vl :free',
      fullModel: 'nvidia/nemotron-3.5-super-vl:free',
      initial: 'O',
      color: Color(0xFF7C3AED),
      badge: 'Vision',
      baseUrl: 'https://openrouter.ai/api/v1',
    ),
    AgentProviderConfig(
      id: 'gemini',
      provider: 'Gemini',
      model: 'gemini-2.5-flash',
      fullModel: 'gemini-2.5-flash',
      initial: 'G',
      color: Color(0xFFB45309),
      badge: '',
      baseUrl: 'https://generativelanguage.googleapis.com/v1beta/openai',
    ),
    AgentProviderConfig(
      id: 'custom',
      provider: 'Custom…',
      model: 'OpenAI-compatible endpoint',
      fullModel: 'custom endpoint',
      initial: '+',
      color: Color(0xFF475569),
      badge: '',
      baseUrl: 'https://api.openai.com/v1',
    ),
  ];

  @override
  List<Object?> get props => [id, provider, model, fullModel, badge, baseUrl];
}
