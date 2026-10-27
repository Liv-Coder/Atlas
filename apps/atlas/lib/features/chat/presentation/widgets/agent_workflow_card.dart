import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import '../../../../domain/models/chat_session.dart';

class AgentWorkflowCard extends StatelessWidget {
  const AgentWorkflowCard({
    super.key,
    required this.message,
    required this.onApprove,
    required this.onEditPlan,
  });

  final ChatMessage message;
  final VoidCallback onApprove;
  final VoidCallback onEditPlan;

  @override
  Widget build(BuildContext context) {
    final colors = context.atlasColors;
    final steps = message.buildWorkflowSteps();

    return Container(
      margin: const EdgeInsets.only(top: 12, bottom: 6),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.hair2),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: colors.surface2,
              border: Border(bottom: BorderSide(color: colors.hair)),
            ),
            child: Row(
              children: [
                Text(
                  'WORKFLOW',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.3,
                    color: colors.text,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: colors.hair),
                  ),
                  child: Text(
                    message.workflowStatus,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: colors.text2,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              children: steps.map((step) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 22,
                        height: 22,
                        margin: const EdgeInsets.only(top: 1),
                        decoration: BoxDecoration(
                          color: step.isDone ? colors.text : Colors.transparent,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: (step.isDone || step.isActive)
                                ? colors.text
                                : colors.hair2,
                            width: 1.5,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          step.isDone ? '✓' : '${step.index}',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: step.isDone
                                ? colors.bg
                                : (step.isActive ? colors.text : colors.muted),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              step.title,
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700,
                                color: colors.text,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              step.detail,
                              style: TextStyle(
                                fontSize: 12.5,
                                height: 1.4,
                                color: colors.muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: colors.hair),
                        ),
                        child: Text(
                          step.tag,
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            color: colors.muted,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
            decoration: BoxDecoration(
              color: colors.surface2,
              border: Border(top: BorderSide(color: colors.hair)),
            ),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  message.workflowCompleted
                      ? 'Done — result ready for your review above.'
                      : (message.workflowApproved
                          ? 'Approved — executing step 3…'
                          : 'Ready to execute step 3?'),
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: colors.text2,
                  ),
                ),
                if (!message.workflowCompleted) ...[
                  ElevatedButton(
                    onPressed: message.workflowApproved ? null : onApprove,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.text,
                      foregroundColor: colors.bg,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      shape: const StadiumBorder(),
                    ),
                    child: Text(
                      message.workflowApproved ? 'Running…' : 'Approve & run',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  OutlinedButton(
                    onPressed: onEditPlan,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colors.text,
                      side: BorderSide(color: colors.hair2),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 13,
                        vertical: 8,
                      ),
                      shape: const StadiumBorder(),
                    ),
                    child: const Text(
                      'Edit plan',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
