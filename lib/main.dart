import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_gabarito/modules/habits/domain/usecases/check_in_habit.dart';
import 'package:todo_gabarito/modules/habits/domain/usecases/get_habits.dart';
import 'package:todo_gabarito/modules/habits/external/datasources/habit_api_datasoucers.dart';
import 'package:todo_gabarito/modules/habits/infra/datasources/habitsDatasource.dart';
import 'package:todo_gabarito/modules/habits/infra/repositories/habit_repository_impl.dart';
import 'package:todo_gabarito/modules/habits/presenter/habits_controller.dart';
import 'package:todo_gabarito/modules/todos/domain/usecases/update_todo_usecase.dart';

import 'modules/habits/presenter/habits_page.dart';
import 'modules/todos/domain/usecases/get_todos.dart';
import 'modules/todos/external/datasources/todo_api_datasource.dart';
import 'modules/todos/infra/datasources/todo_datasource.dart';
import 'modules/todos/infra/repositories/todo_repository_impl.dart';
import 'modules/todos/presenter/todos_controller.dart';
import 'modules/todos/presenter/todos_page.dart';

/// Único lugar que sabe quais implementações usar.
void main() {
  Dio dio = Dio(
      BaseOptions(baseUrl: 'https://todo-api-production-62d2.up.railway.app'));
  final TodoDatasource datasource = TodoApiDatasource(dio);
  final repository = TodoRepositoryImpl(datasource);
  final controller = TodosController(
    getTodos: GetTodosUseCase(repository),

    /// plmds rafael lembra que voce fez issoi aqwuoi
    updateTodoUsecase: UpdateTodoUsecase(repository: repository),
  )..load();

  final HabitsDatasource habitsDatasource = HabitApiDatasoucers(dio);
  final habitsRepository = HabitRepositoryImpl(habitsDatasource);
  final habitsController = HabitsController(
      getHabitsUseCase: GetHabitsUseCase(habitsRepository),
      checkHabitUseCase: CheckHabitUseCase(habitsRepository));

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<TodosController>.value(value: controller),
      ChangeNotifierProvider<HabitsController>.value(value: habitsController)
    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeShell(pages: [TodosPage(controller: controller), HabitsPage()]),
    ),
  ));
}

/// Navegação entre os módulos. Fica aqui para um módulo não importar o outro.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key, required this.pages});

  final List<Widget> pages;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: index, children: widget.pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (value) => setState(() => index = value),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.checklist_rounded),
            label: 'Tarefas',
          ),
          NavigationDestination(
            icon: Icon(Icons.local_fire_department_rounded),
            label: 'Hábitos',
          ),
        ],
      ),
    );
  }
}
