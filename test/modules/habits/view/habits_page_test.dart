import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_gabarito/modules/habits/view/habits_page.dart';
import 'package:todo_gabarito/modules/habits/viewmodel/habits_view_model.dart';

import '../../../helpers/fake_habits_service.dart';

void main() {
  testWidgets('tocar em "Feito hoje" registra o hábito na tela',
      (tester) async {
    final viewModel = HabitsViewModel(FakeHabitsService());
    await viewModel.load();

    await tester.pumpWidget(
      MaterialApp(home: HabitsPage(viewModel: viewModel)),
    );
    expect(find.text('Feito hoje'), findsNWidgets(2));
    expect(find.text('3 dias seguidos'), findsOneWidget);

    await tester.tap(find.text('Feito hoje').first);
    await tester.pump();

    expect(find.text('Feito hoje'), findsOneWidget);
    expect(find.text('4 dias seguidos'), findsOneWidget);
    expect(find.text('Faltam 1 para fechar o dia'), findsOneWidget);
  });

  testWidgets('falha ao carregar mostra o erro e o botão de tentar de novo',
      (tester) async {
    final viewModel = HabitsViewModel(FakeHabitsService()..fail = true);
    await viewModel.load();

    await tester.pumpWidget(
      MaterialApp(home: HabitsPage(viewModel: viewModel)),
    );

    expect(find.text('Não foi possível carregar os hábitos'), findsOneWidget);
    expect(find.text('Tentar de novo'), findsOneWidget);
  });
}
