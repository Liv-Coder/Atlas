import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import '../../../../domain/models/workflow_state.dart';

class AgentWorkflowBar extends StatelessWidget {
  const AgentWorkflowBar({
    super.key,
    required this.workflow,
    required this.approvalsEnabled,
    required this.onApprovalsTap,
  });

  final AgentWorkflowProgress workflow;
  final bool approvalsEnabled;
  final VoidCallback onApprovalsTap;

  static const _stageLabels = ['Plan', 'Gather', 'Execute', 'Verify'];

  @override
  Widget build(BuildContext context) {
    final colors = context.atlasColors;
    final isRunning = workflow.runState == WorkflowRunState.running ||
        workflow.runState == WorkflowRunState.awaitingApproval;
    final dotColor = isRunning ? colors.statusRunning : colors.statusReady;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 11),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.hair2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 12,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'AGENT WORKFLOW',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.9,
                  color: colors.text,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: colors.surface2,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: colors.hair),
                ),
                child: Text(
                  workflow.statusLabel,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: colors.text2,
                  ),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: onApprovalsTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: colors.surface2,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: colors.hair),
                  ),
                  child: Text(
                    'Approvals',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: colors.text,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 13,
                height: 1.45,
                color: colors.text2,
                fontWeight: FontWeight.w500,
              ),
              children: workflow.goalText.isEmpty
                  ? [
                      TextSpan(
                        text: 'No active task. ',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: colors.text,
                        ),
                      ),
                      const TextSpan(
                        text:
                            'Describe a goal — Atlas will plan, execute & verify it.',
                      ),
                    ]
                  : [
                      TextSpan(
                        text: 'Goal: ',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: colors.text,
                        ),
                      ),
                      TextSpan(text: workflow.goalText),
                    ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: List.generate(_stageLabels.length, (i) {
              final isDone = i < workflow.completedSteps;
              final isActive = i == workflow.activeStepIndex;
              final filled = isDone || isActive;
              return Expanded(
                child: Column(
                  children: [
                    Container(
                      width: 27,
                      height: 27,
                      decoration: BoxDecoration(
                        color: filled ? colors.text : colors.surface,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: filled ? colors.text : colors.hair2,
                          width: 1.5,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        isDone ? '✓' : '${i + 1}',
                        style: TextStyle(
                          fontSize: isDone ? 13 : 11,
                          fontWeight: FontWeight.w800,
                          color: filled ? colors.bg : colors.muted,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      _stageLabels[i],
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        color: filled ? colors.text : colors.muted,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
          const SizedBox(height: 11),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: workflow.progressFraction,
              minHeight: 5,
              backgroundColor: colors.surface3,
              valueColor: AlwaysStoppedAnimation<Color>(colors.text),
            ),
          ),
          const SizedBox(height: 7),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                workflow.metaLeftLabel,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: colors.muted,
                ),
              ),
              Text(
                approvalsEnabled
                    ? 'Asks before external actions'
                    : 'Approvals off',
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: colors.muted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
