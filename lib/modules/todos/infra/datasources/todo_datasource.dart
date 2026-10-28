import 'package:todo_gabarito/modules/todos/domain/entities/todo.dart';

abstract interface class TodoDatasource {
  Future<List<Map<String, dynamic>>> fetchTodos();
  Future<Map<String, dynamic>> updateTodo(Todo todo);
}
