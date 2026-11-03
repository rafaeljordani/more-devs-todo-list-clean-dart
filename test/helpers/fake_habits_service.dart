import 'package:dio/dio.dart';
import 'package:todo_gabarito/modules/habits/model/habit.dart';
import 'package:todo_gabarito/modules/habits/model/habits_service.dart';

/// Service falso: guarda os hábitos em memória, nada de internet.
/// Os check-ins são contados a partir de hoje, como na API.
class FakeHabitsService extends HabitsService {
  FakeHabitsService() : super(Dio());

  final habits = [
    Habit(id: 1, name: 'Beber água', checkins: daysAgo([3, 2, 1])),
    Habit(id: 2, name: 'Ler 10 páginas', checkins: daysAgo([1, 0])),
    Habit(id: 3, name: 'Meditar', checkins: daysAgo([3, 2])),
  ];
  bool fail = false;

  void _check() {
    if (fail) throw Exception('Falha simulada');
  }

  @override
  Future<List<Habit>> fetchAll() async {
    _check();
    return List.of(habits);
  }

  @override
  Future<Habit> checkIn(int id) async {
    _check();
    final index = habits.indexWhere((habit) => habit.id == id);
    final habit = habits[index];
    if (habit.isDoneOn(DateTime.now())) throw Exception('Já feito hoje');
    final updated = Habit(
      id: habit.id,
      name: habit.name,
      checkins: [...habit.checkins, DateTime.now()],
    );
    habits[index] = updated;
    return updated;
  }
}

List<DateTime> daysAgo(List<int> days) {
  final now = DateTime.now();
  return [for (final day in days) DateTime(now.year, now.month, now.day - day)];
}
