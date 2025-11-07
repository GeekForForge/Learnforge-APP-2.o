class TodoModel {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final DateTime dueDate;
  final String priority; // 'high', 'medium', 'low'
  final String category; // 'learning', 'practice', 'review'
  final DateTime createdAt;

  TodoModel({
    required this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
    required this.dueDate,
    this.priority = 'medium',
    this.category = 'learning',
    required this.createdAt,
  });

  String get dayLabel {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final dueDay = DateTime(dueDate.year, dueDate.month, dueDate.day);

    if (dueDay == today) return 'Today';
    if (dueDay == tomorrow) return 'Tomorrow';
    if (dueDay.isBefore(today)) return 'Overdue';
    return 'Upcoming';
  }
}
