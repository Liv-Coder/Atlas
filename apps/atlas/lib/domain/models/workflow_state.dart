import 'package:equatable/equatable.dart';

enum WorkflowRunState { ready, running, awaitingApproval, done }

class WorkflowStepItem extends Equatable {
  const WorkflowStepItem({
    required this.index,
    required this.title,
    required this.detail,
    required this.tag,
    required this.isDone,
    required this.isActive,
  });

  final int index;
  final String title;
  final String detail;
  final String tag;
  final bool isDone;
  final bool isActive;

  @override
  List<Object?> get props => [index, title, detail, tag, isDone, isActive];
}

class AgentWorkflowProgress extends Equatable {
  const AgentWorkflowProgress({
    this.runState = WorkflowRunState.ready,
    this.statusLabel = 'Ready',
    this.goalText = '',
    this.activeStepIndex = 0,
    this.completedSteps = 0,
    this.progressFraction = 0.12,
  });

  final WorkflowRunState runState;
  final String statusLabel;
  final String goalText;
  final int activeStepIndex;
  final int completedSteps;
  final double progressFraction;

  String get metaLeftLabel {
    if (runState == WorkflowRunState.done) {
      return '$completedSteps of 4 steps · Complete';
    }
    if (runState == WorkflowRunState.running ||
        runState == WorkflowRunState.awaitingApproval) {
      return '$completedSteps of 4 steps · In progress';
    }
    return '$completedSteps of 4 steps';
  }

  AgentWorkflowProgress copyWith({
    WorkflowRunState? runState,
    String? statusLabel,
    String? goalText,
    int? activeStepIndex,
    int? completedSteps,
    double? progressFraction,
  }) {
    return AgentWorkflowProgress(
      runState: runState ?? this.runState,
      statusLabel: statusLabel ?? this.statusLabel,
      goalText: goalText ?? this.goalText,
      activeStepIndex: activeStepIndex ?? this.activeStepIndex,
      completedSteps: completedSteps ?? this.completedSteps,
      progressFraction: progressFraction ?? this.progressFraction,
    );
  }

  @override
  List<Object?> get props => [
        runState,
        statusLabel,
        goalText,
        activeStepIndex,
        completedSteps,
        progressFraction,
      ];
}
