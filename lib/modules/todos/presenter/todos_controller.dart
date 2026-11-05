import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:todo_gabarito/modules/todos/domain/usecases/update_todos_use_case.dart';
import 'package:todo_gabarito/modules/todos/shared/connectivity_plus.dart';
import 'package:todo_gabarito/modules/todos/shared/shared_preferences.dart';

import '../domain/entities/todo.dart';
import '../domain/errors/todo_failure.dart';
import '../domain/usecases/get_todos.dart';

class TodosController extends ChangeNotifier {
  TodosController({required this.getTodos, required this.updateUseCase}) {
    _connectivitySubscription =
        connectivityPlus.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  final GetTodosUseCase getTodos;
  final UpdateTodoUseCase updateUseCase;
  final SharedPreferences sharedPreferences = SharedPreferences();

  final ConnectivityPlus connectivityPlus = ConnectivityPlus();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  List<Todo> todos = [];
  bool loading = false;
  String? error;
  bool hideDone = false;
  bool hasConnection = false;

  void _updateConnectionStatus(List<ConnectivityResult> _) {
    load();
  }

  Future<void> load() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      if (!await connectivityPlus.cheackConective()) {
        hasConnection = false;
        todos = await sharedPreferences.getTodosCache();
        if (hideDone) {
          todos = todos.where((todo) => !todo.done).toList();
        }
        loading = false;
        notifyListeners();
        return;
      }
      hasConnection = true;
      todos = await getTodos(hideDone: hideDone);
    } on TodoFailure catch (f) {
      error = f.message;
    } finally {
      await sharedPreferences.saveTodosCache(todos);
      loading = false;
      notifyListeners();
    }
  }

  void toggleHideDone() {
    hideDone = !hideDone;
    load();
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }
}
