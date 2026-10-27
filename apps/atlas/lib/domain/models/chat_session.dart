import 'package:equatable/equatable.dart';
import 'workflow_state.dart';

enum MessageRole { user, assistant }

enum SessionGroup {
  pinned('PINNED'),
  today('TODAY'),
  previous('PREVIOUS');

  const SessionGroup(this.heading);
  final String heading;
}

class ChatMessage extends Equatable {
  const ChatMessage({
    required this.id,
    required this.role,
    required this.content,
    this.bulletItems = const [],
    this.checkedStepIndices = const {},
    this.footerNote,
    this.providerBadge = 'Cline · Plan',
    this.isAgentWorkflowCard = false,
    this.workflowGoal = '',
    this.workflowStatus = 'Awaiting approval',
    this.workflowApproved = false,
    this.workflowCompleted = false,
  });

  final String id;
  final MessageRole role;
  final String content;
  final List<String> bulletItems;
  final Set<int> checkedStepIndices;
  final String? footerNote;
  final String providerBadge;
  final bool isAgentWorkflowCard;
  final String workflowGoal;
  final String workflowStatus;
  final bool workflowApproved;
  final bool workflowCompleted;

  List<WorkflowStepItem> buildWorkflowSteps() {
    final shortGoal = workflowGoal.length > 80
        ? '${workflowGoal.substring(0, 80)}…'
        : workflowGoal;
    if (workflowCompleted) {
      return [
        WorkflowStepItem(
          index: 1,
          title: '1 · Plan',
          detail: 'Goal understood: “$shortGoal” — broken into clear, checkable steps.',
          tag: 'Done',
          isDone: true,
          isActive: false,
        ),
        const WorkflowStepItem(
          index: 2,
          title: '2 · Gather',
          detail: 'Context, files and previous chats checked. No external action taken yet.',
          tag: 'Done',
          isDone: true,
          isActive: false,
        ),
        const WorkflowStepItem(
          index: 3,
          title: '3 · Execute',
          detail: 'Drafts and prepares the work step by step, keeping a visible activity log.',
          tag: 'Done',
          isDone: true,
          isActive: false,
        ),
        const WorkflowStepItem(
          index: 4,
          title: '4 · Verify & deliver',
          detail: 'Checks the result, summarises what changed, and shows what needs your review.',
          tag: 'Done',
          isDone: true,
          isActive: true,
        ),
      ];
    }
    return [
      WorkflowStepItem(
        index: 1,
        title: '1 · Plan',
        detail: 'Goal understood: “$shortGoal” — broken into clear, checkable steps.',
        tag: 'Done',
        isDone: true,
        isActive: false,
      ),
      const WorkflowStepItem(
        index: 2,
        title: '2 · Gather',
        detail: 'Context, files and previous chats checked. No external action taken yet.',
        tag: 'Done',
        isDone: true,
        isActive: false,
      ),
      WorkflowStepItem(
        index: 3,
        title: '3 · Execute',
        detail: 'Drafts and prepares the work step by step, keeping a visible activity log.',
        tag: workflowApproved ? 'Running' : 'Next',
        isDone: workflowApproved,
        isActive: true,
      ),
      const WorkflowStepItem(
        index: 4,
        title: '4 · Verify & deliver',
        detail: 'Checks the result, summarises what changed, and shows what needs your review.',
        tag: 'Pending',
        isDone: false,
        isActive: false,
      ),
    ];
  }

  ChatMessage copyWith({
    String? content,
    List<String>? bulletItems,
    Set<int>? checkedStepIndices,
    String? footerNote,
    String? providerBadge,
    bool? isAgentWorkflowCard,
    String? workflowGoal,
    String? workflowStatus,
    bool? workflowApproved,
    bool? workflowCompleted,
  }) {
    return ChatMessage(
      id: id,
      role: role,
      content: content ?? this.content,
      bulletItems: bulletItems ?? this.bulletItems,
      checkedStepIndices: checkedStepIndices ?? this.checkedStepIndices,
      footerNote: footerNote ?? this.footerNote,
      providerBadge: providerBadge ?? this.providerBadge,
      isAgentWorkflowCard: isAgentWorkflowCard ?? this.isAgentWorkflowCard,
      workflowGoal: workflowGoal ?? this.workflowGoal,
      workflowStatus: workflowStatus ?? this.workflowStatus,
      workflowApproved: workflowApproved ?? this.workflowApproved,
      workflowCompleted: workflowCompleted ?? this.workflowCompleted,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'role': role.name,
        'content': content,
        'bulletItems': bulletItems,
        'checkedStepIndices': checkedStepIndices.toList(),
        'footerNote': footerNote,
        'providerBadge': providerBadge,
        'isAgentWorkflowCard': isAgentWorkflowCard,
        'workflowGoal': workflowGoal,
        'workflowStatus': workflowStatus,
        'workflowApproved': workflowApproved,
        'workflowCompleted': workflowCompleted,
      };

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as String,
      role: (json['role'] as String) == 'user'
          ? MessageRole.user
          : MessageRole.assistant,
      content: json['content'] as String? ?? '',
      bulletItems:
          (json['bulletItems'] as List<dynamic>? ?? const []).cast<String>(),
      checkedStepIndices:
          ((json['checkedStepIndices'] as List<dynamic>?) ?? const [])
              .cast<int>()
              .toSet(),
      footerNote: json['footerNote'] as String?,
      providerBadge: json['providerBadge'] as String? ?? 'Cline · Plan',
      isAgentWorkflowCard: json['isAgentWorkflowCard'] as bool? ?? false,
      workflowGoal: json['workflowGoal'] as String? ?? '',
      workflowStatus: json['workflowStatus'] as String? ?? 'Awaiting approval',
      workflowApproved: json['workflowApproved'] as bool? ?? false,
      workflowCompleted: json['workflowCompleted'] as bool? ?? false,
    );
  }

  @override
  List<Object?> get props => [
        id,
        role,
        content,
        bulletItems,
        checkedStepIndices,
        footerNote,
        providerBadge,
        isAgentWorkflowCard,
        workflowGoal,
        workflowStatus,
        workflowApproved,
        workflowCompleted,
      ];
}

class ChatSession extends Equatable {
  const ChatSession({
    required this.id,
    required this.title,
    required this.timeLabel,
    required this.group,
    required this.pinned,
    required this.kind,
    required this.messages,
  });

  final String id;
  final String title;
  final String timeLabel;
  final SessionGroup group;
  final bool pinned;
  final String kind;
  final List<ChatMessage> messages;

  ChatSession copyWith({
    String? id,
    String? title,
    String? timeLabel,
    SessionGroup? group,
    bool? pinned,
    String? kind,
    List<ChatMessage>? messages,
  }) {
    return ChatSession(
      id: id ?? this.id,
      title: title ?? this.title,
      timeLabel: timeLabel ?? this.timeLabel,
      group: group ?? this.group,
      pinned: pinned ?? this.pinned,
      kind: kind ?? this.kind,
      messages: messages ?? this.messages,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'timeLabel': timeLabel,
        'group': group.name,
        'pinned': pinned,
        'kind': kind,
        'messages': messages.map((m) => m.toJson()).toList(),
      };

  factory ChatSession.fromJson(Map<String, dynamic> json) {
    final groupName = json['group'] as String? ?? 'today';
    final group = SessionGroup.values.firstWhere(
      (g) => g.name == groupName,
      orElse: () => SessionGroup.today,
    );
    return ChatSession(
      id: json['id'] as String,
      title: json['title'] as String,
      timeLabel: json['timeLabel'] as String? ?? 'Today',
      group: group,
      pinned: json['pinned'] as bool? ?? false,
      kind: json['kind'] as String? ?? 'generic',
      messages: ((json['messages'] as List<dynamic>?) ?? const [])
          .map((e) => ChatMessage.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  List<Object?> get props =>
      [id, title, timeLabel, group, pinned, kind, messages];
}
