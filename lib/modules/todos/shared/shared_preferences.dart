import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_gabarito/modules/todos/domain/entities/todo.dart';

class SharedPreferences {
  Future<void> saveTodosCache(List<Todo> listSave) async {
    final prefs = SharedPreferencesAsync();

    await prefs.setString(
        'todo_cache',
        jsonEncode({
          'lastSync': DateTime.now().toIso8601String(),
          'todos': listSave
              .map((todo) => {
                    'id': todo.id,
                    'title': todo.title,
                    'done': todo.done,
                  })
              .toList(),
        }));
  }

  Future<List<Todo>> getTodosCache() async {
    final prefs = SharedPreferencesAsync();
    final jsonString = await prefs.getString('todo_cache');

    if (jsonString == null) {
      return [];
    }
    final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
    final todosJson = jsonMap['todos'] as List<dynamic>;
    return todosJson
        .map((todoJson) => Todo(
              id: todoJson['id'] as int,
              title: todoJson['title'] as String,
              done: todoJson['done'] as bool,
            ))
        .toList();
  }
}
