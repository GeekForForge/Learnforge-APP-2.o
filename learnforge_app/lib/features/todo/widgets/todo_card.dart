import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/widgets/glass_morphic_card.dart';
import '../models/todo_model.dart';

class TodoCard extends StatelessWidget {
  final TodoModel todo;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const TodoCard({
    super.key,
    required this.todo,
    required this.onToggle,
    required this.onDelete,
  });

  Color get priorityColor {
    switch (todo.priority) {
      case 'high':
        return Colors.redAccent; // Using Flutter's built-in color for danger
      case 'medium':
        return Colors.orange; // Using Flutter's built-in color for warning
      case 'low':
        return AppColors.neonCyan; // Using neonCyan for success
      default:
        return AppColors.neonPurple; // Fixed: primary → neonPurple
    }
  }

  Color get glowColor {
    switch (todo.priority) {
      case 'high':
        return Colors.redAccent;
      case 'medium':
        return Colors.orange;
      case 'low':
        return AppColors.neonCyan;
      default:
        return AppColors.neonPurple;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GlassMorphicCard(
      glowColor: glowColor,
      child: Row(
        children: [
          // Checkbox
          GestureDetector(
            onTap: onToggle,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: todo.isCompleted
                      ? AppColors
                            .neonCyan // Using neonCyan for completed
                      : AppColors.neonPurple, // Fixed: accent → neonPurple
                  width: 2,
                ),
                color: todo.isCompleted
                    ? AppColors.neonCyan.withValues(alpha: 0.2)
                    : Colors.transparent,
                boxShadow: todo.isCompleted
                    ? [
                        BoxShadow(
                          color: AppColors.neonCyan.withValues(alpha: 0.3),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ]
                    : null,
              ),
              child: todo.isCompleted
                  ? Icon(Icons.check, size: 16, color: AppColors.neonCyan)
                  : null,
            ),
          ).animate().scale(duration: 300.ms, curve: Curves.easeOut),

          const SizedBox(width: 12),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  todo.title,
                  style:
                      TextStyles.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white, // Fixed: textLight → white
                      ).copyWith(
                        decoration: todo.isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    // Priority badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: priorityColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: priorityColor.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        todo.priority.toUpperCase(),
                        style: TextStyles.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: priorityColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Due date
                    Text(
                      todo.dayLabel,
                      style: TextStyles.inter(
                        fontSize: 10,
                        color: AppColors.grey400, // Fixed: textMuted → grey400
                      ),
                    ),
                  ],
                ),

                // Description (if available)
                if (todo.description.isNotEmpty == true) ...[
                  const SizedBox(height: 4),
                  Text(
                    todo.description,
                    style: TextStyles.inter(
                      fontSize: 12,
                      color: AppColors.grey400,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),

          // Delete button
          GestureDetector(
            onTap: onDelete,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.dark700,
                border: Border.all(color: AppColors.grey400.withValues(alpha: 0.3)),
              ),
              child: Icon(
                Icons.close,
                size: 16,
                color: AppColors.grey400, // Fixed: textMuted → grey400
              ),
            ).animate().scale(duration: 200.ms),
          ),
        ],
      ),
    );
  }
}
