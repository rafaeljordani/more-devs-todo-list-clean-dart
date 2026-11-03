import 'package:flutter_test/flutter_test.dart';
import 'package:todo_gabarito/modules/habits/model/habit.dart';

Habit _habit(List<DateTime> checkins) =>
    Habit(id: 1, name: 'Meditar', checkins: checkins);

void main() {
  final today = DateTime(2026, 10, 29, 15, 30);

  test('fromMap converte o JSON da API', () {
    final habit = Habit.fromMap({
      'id': 2,
      'name': 'Ler 10 páginas',
      'checkins': ['2026-10-27', '2026-10-28'],
    });

    expect(habit.id, 2);
    expect(habit.name, 'Ler 10 páginas');
    expect(habit.isDoneOn(DateTime(2026, 10, 28, 22)), isTrue);
    expect(habit.isDoneOn(DateTime(2026, 10, 29)), isFalse);
  });

  test('streak conta os dias seguidos até hoje', () {
    final habit = _habit([
      DateTime(2026, 10, 27),
      DateTime(2026, 10, 28),
      DateTime(2026, 10, 29),
    ]);

    expect(habit.streakOn(today), 3);
  });

  test('sem check-in hoje, o streak conta até ontem', () {
    final habit = _habit([DateTime(2026, 10, 27), DateTime(2026, 10, 28)]);

    expect(habit.isDoneOn(today), isFalse);
    expect(habit.streakOn(today), 2);
  });

  test('um dia inteiro sem check-in zera o streak', () {
    expect(_habit([DateTime(2026, 10, 26), DateTime(2026, 10, 27)])
        .streakOn(today), 0);
    expect(_habit([DateTime(2026, 10, 27), DateTime(2026, 10, 29)])
        .streakOn(today), 1);
    expect(_habit([]).streakOn(today), 0);
  });

  test('streak atravessa a virada do mês', () {
    final habit = _habit([DateTime(2026, 9, 30), DateTime(2026, 10, 1)]);

    expect(habit.streakOn(DateTime(2026, 10, 1)), 2);
  });
}
