abstract interface class HabitsDatasource {
  Future<List<Map<String, dynamic>>> fetchHabits();
}
