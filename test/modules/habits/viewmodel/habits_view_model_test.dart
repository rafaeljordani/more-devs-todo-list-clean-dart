import 'package:flutter_test/flutter_test.dart';
import 'package:todo_gabarito/modules/habits/viewmodel/habits_view_model.dart';

import '../../../helpers/fake_habits_service.dart';

void main() {
  test('load entrega os hábitos e o resumo prontos para a tela', () async {
    final viewModel = HabitsViewModel(FakeHabitsService());

    await viewModel.load();

    expect(viewModel.loading, isFalse);
    expect(viewModel.error, isNull);
    expect(viewModel.total, 3);
    expect(viewModel.doneToday, 1);
    expect(viewModel.bestStreakLabel, '🔥 melhor: 3 dias');
    expect(viewModel.remainingLabel, 'Faltam 2 para fechar o dia');

    final [water, reading, meditation] = viewModel.items;
    expect(water.streakLabel, '3 dias seguidos');
    expect(water.doneToday, isFalse);
    expect(reading.streakLabel, '2 dias seguidos');
    expect(reading.doneToday, isTrue);
    expect(meditation.streakLabel, 'Comece hoje');
    expect(meditation.onFire, isFalse);
  });

  test('falha ao carregar vira mensagem de erro', () async {
    final service = FakeHabitsService()..fail = true;
    final viewModel = HabitsViewModel(service);

    await viewModel.load();

    expect(viewModel.error, 'Não foi possível carregar os hábitos');
    expect(viewModel.items, isEmpty);
  });

  test('checkIn marca o hábito e aumenta o streak', () async {
    final viewModel = HabitsViewModel(FakeHabitsService());
    await viewModel.load();

    final saved = await viewModel.checkIn(1);

    expect(saved, isTrue);
    expect(viewModel.items.first.doneToday, isTrue);
    expect(viewModel.items.first.streakLabel, '4 dias seguidos');
    expect(viewModel.doneToday, 2);
    expect(viewModel.bestStreakLabel, '🔥 melhor: 4 dias');
  });

  test('falha no checkIn devolve false e não muda a tela', () async {
    final service = FakeHabitsService();
    final viewModel = HabitsViewModel(service);
    await viewModel.load();
    service.fail = true;

    final saved = await viewModel.checkIn(1);

    expect(saved, isFalse);
    expect(viewModel.items.first.doneToday, isFalse);
    expect(viewModel.doneToday, 1);
  });

  test('com tudo feito, o resumo comemora', () async {
    final viewModel = HabitsViewModel(FakeHabitsService());
    await viewModel.load();

    await viewModel.checkIn(1);
    await viewModel.checkIn(3);

    expect(viewModel.progress, 1);
    expect(viewModel.remainingLabel, 'Tudo feito hoje · mandou bem!');
  });
}
