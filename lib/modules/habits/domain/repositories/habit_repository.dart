import 'package:todo_gabarito/modules/habits/domain/entities/habit.dart';

abstract class HabitRepository {
  Future<List<Habit>> fetchHabits();
}
