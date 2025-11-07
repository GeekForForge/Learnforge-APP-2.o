import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/todo_model.dart';
import '../../../core/constants/dummy_data.dart';
import 'package:uuid/uuid.dart';

final todoProvider = StateNotifierProvider<TodoNotifier, List<TodoModel>>((
  ref,
) {
  return TodoNotifier();
});

class TodoNotifier extends StateNotifier<List<TodoModel>> {
  TodoNotifier() : super(DummyData.getTodos());

  void addTodo(
    String title,
    String description,
    DateTime dueDate,
    String priority,
  ) {
    const uuid = Uuid();
    final newTodo = TodoModel(
      id: uuid.v4(),
      title: title,
      description: description,
      dueDate: dueDate,
      priority: priority,
      createdAt: DateTime.now(),
    );
    state = [...state, newTodo];
  }

  void deleteTodo(String id) {
    state = state.where((todo) => todo.id != id).toList();
  }

  void toggleTodo(String id) {
    state = [
      for (final todo in state)
        if (todo.id == id)
          TodoModel(
            id: todo.id,
            title: todo.title,
            description: todo.description,
            isCompleted: !todo.isCompleted,
            dueDate: todo.dueDate,
            priority: todo.priority,
            category: todo.category,
            createdAt: todo.createdAt,
          )
        else
          todo,
    ];
  }
}
