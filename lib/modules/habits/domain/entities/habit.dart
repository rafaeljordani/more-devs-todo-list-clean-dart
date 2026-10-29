class Habit {
  final int id;
  final String name;
  final List<String> checkins;

  const Habit({required this.id, required this.checkins, required this.name});

  Habit copyWith({String? title, bool? done}) => Habit(
        id: id,
        checkins: [],
        name: '',
      );
}
