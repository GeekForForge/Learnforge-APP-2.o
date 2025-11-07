import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/widgets/glass_morphic_card.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../core/widgets/progress_indicator_circular.dart';
import '../providers/todo_provider.dart';
import '../widgets/todo_card.dart';
import '../widgets/add_todo_modal.dart';

class TodoScreen extends ConsumerWidget {
  const TodoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(todoProvider);

    final todayTodos = todos
        .where(
          (todo) =>
              DateTime(
                todo.dueDate.year,
                todo.dueDate.month,
                todo.dueDate.day,
              ) ==
              DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day,
              ),
        )
        .toList();

    final upcomingTodos = todos
        .where(
          (todo) =>
              DateTime(
                todo.dueDate.year,
                todo.dueDate.month,
                todo.dueDate.day,
              ).isAfter(
                DateTime(
                  DateTime.now().year,
                  DateTime.now().month,
                  DateTime.now().day,
                ),
              ),
        )
        .toList();

    final completedCount = todos.where((todo) => todo.isCompleted).length;
    final completionPercentage = todos.isNotEmpty
        ? (completedCount / todos.length)
        : 0.0;

    return Scaffold(
      backgroundColor: AppColors.dark900, // Fixed: darkBg → dark900
      appBar: AppBar(
        title: Text(
          'To-Do & Planner',
          style: TextStyles.orbitron(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),
        ),
        backgroundColor: AppColors.dark800, // Fixed: darkBgSecondary → dark800
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => AddTodoModal(
              onAdd: (title, desc, date, priority) {
                ref
                    .read(todoProvider.notifier)
                    .addTodo(title, desc, date, priority);
                Navigator.pop(context);
              },
            ),
          );
        },
        backgroundColor: AppColors.neonPurple, // Fixed: primary → neonPurple
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Completion Progress
            GlassMorphicCard(
              glowColor: AppColors.neonCyan,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Overall Progress',
                        style: TextStyles.inter(
                          fontSize: 14,
                          color:
                              AppColors.grey400, // Fixed: textMuted → grey400
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$completedCount/${todos.length} Tasks',
                        style: TextStyles.orbitron(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors
                              .neonPurple, // Fixed: primary → neonPurple
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircularProgressIndicator(
                          value: completionPercentage,
                          strokeWidth: 6,
                          backgroundColor: AppColors
                              .dark700, // Fixed: darkBgSecondary → dark700
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.neonCyan, // Fixed: accent → neonCyan
                          ),
                        ),
                        Text(
                          '${(completionPercentage * 100).toInt()}%',
                          style: TextStyles.orbitron(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color:
                                AppColors.neonCyan, // Fixed: accent → neonCyan
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate().slideY(duration: 400.ms, curve: Curves.easeOut),
            const SizedBox(height: 24),

            // Today's Tasks
            if (todayTodos.isNotEmpty) ...[
              Text(
                'Today',
                style: TextStyles.titleLarge.copyWith(
                  color: AppColors.white,
                ), // Fixed: textLight → white
              ),
              const SizedBox(height: 12),
              ...todayTodos.asMap().entries.map(
                (entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child:
                      TodoCard(
                        todo: entry.value,
                        onToggle: () {
                          ref
                              .read(todoProvider.notifier)
                              .toggleTodo(entry.value.id);
                        },
                        onDelete: () {
                          ref
                              .read(todoProvider.notifier)
                              .deleteTodo(entry.value.id);
                        },
                      ).animate().slideY(
                        duration: (300 + entry.key * 100).ms,
                        curve: Curves.easeOut,
                      ),
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Upcoming Tasks
            if (upcomingTodos.isNotEmpty) ...[
              Text(
                'Upcoming',
                style: TextStyles.titleLarge.copyWith(
                  color: AppColors.white,
                ), // Fixed: textLight → white
              ),
              const SizedBox(height: 12),
              ...upcomingTodos.asMap().entries.map(
                (entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child:
                      TodoCard(
                        todo: entry.value,
                        onToggle: () {
                          ref
                              .read(todoProvider.notifier)
                              .toggleTodo(entry.value.id);
                        },
                        onDelete: () {
                          ref
                              .read(todoProvider.notifier)
                              .deleteTodo(entry.value.id);
                        },
                      ).animate().slideY(
                        duration: (300 + entry.key * 100).ms,
                        curve: Curves.easeOut,
                      ),
                ),
              ),
            ],

            // Empty state when no todos
            if (todos.isEmpty) ...[
              const SizedBox(height: 60),
              Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      size: 80,
                      color: AppColors.grey400.withOpacity(0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No Tasks Yet',
                      style: TextStyles.orbitron(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Add your first task to get started',
                      style: TextStyles.inter(
                        fontSize: 14,
                        color: AppColors.grey400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
