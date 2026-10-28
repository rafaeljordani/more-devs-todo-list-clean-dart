import 'package:todo_gabarito/modules/todos/domain/entities/todo.dart';
import 'package:todo_gabarito/modules/todos/domain/repositories/todo_repository.dart';

class UpdateTodoUsecase {
  final TodoRepository repository;
  UpdateTodoUsecase({required this.repository});

  Future<Todo> call(Todo todo) async {
    return await repository.updateTodo(todo);
  }
}
