import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:todo_gabarito/modules/auth/viewmodel/login_view_model.dart';

import '../../../helpers/fake_auth_service.dart';

void main() {
  test('só deixa enviar com e-mail e senha preenchidos', () {
    final viewModel = LoginViewModel(FakeAuthService());
    expect(viewModel.canSubmit, isFalse);

    viewModel.setEmail('aluno@todo.dev');
    expect(viewModel.canSubmit, isFalse);

    viewModel.setPassword('123456');
    expect(viewModel.canSubmit, isTrue);

    viewModel.setEmail('   ');
    expect(viewModel.canSubmit, isFalse);
  });

  test('login certo cria a sessão', () async {
    final viewModel = LoginViewModel(FakeAuthService())
      ..setEmail('  aluno@todo.dev ')
      ..setPassword('123456');

    await viewModel.login();

    expect(viewModel.loggedIn, isTrue);
    expect(viewModel.session!.user.name, 'Aluno');
    expect(viewModel.error, isNull);
    expect(viewModel.loading, isFalse);
  });

  test('e-mail inválido mostra erro no campo e não chama a API', () async {
    final service = FakeAuthService();
    final viewModel = LoginViewModel(service)
      ..setEmail('aluno')
      ..setPassword('123456');

    await viewModel.login();

    expect(viewModel.emailError, 'Digite um e-mail válido');
    expect(service.calls, isEmpty);
    expect(viewModel.loggedIn, isFalse);

    viewModel.setEmail('aluno@');
    expect(viewModel.emailError, isNull);
  });

  test('senha errada vira mensagem de credenciais incorretas', () async {
    final viewModel = LoginViewModel(FakeAuthService())
      ..setEmail('aluno@todo.dev')
      ..setPassword('errada');

    await viewModel.login();

    expect(viewModel.error, 'E-mail ou senha incorretos');
    expect(viewModel.loggedIn, isFalse);

    viewModel.setPassword('outra');
    expect(viewModel.error, isNull);
  });

  test('falha de rede vira mensagem genérica', () async {
    final viewModel = LoginViewModel(FakeAuthService()..fail = true)
      ..setEmail('aluno@todo.dev')
      ..setPassword('123456');

    await viewModel.login();

    expect(viewModel.error, 'Não foi possível entrar. Tente de novo.');
    expect(viewModel.loggedIn, isFalse);
  });

  test('enquanto carrega, não aceita um segundo envio', () async {
    final service = FakeAuthService()..gate = Completer();
    final viewModel = LoginViewModel(service)
      ..setEmail('aluno@todo.dev')
      ..setPassword('123456');

    final first = viewModel.login();
    expect(viewModel.loading, isTrue);
    expect(viewModel.canSubmit, isFalse);

    await viewModel.login();
    expect(service.calls, hasLength(1));

    service.gate!.complete();
    await first;
    expect(viewModel.loading, isFalse);
    expect(viewModel.loggedIn, isTrue);
  });

  test('alternar a visibilidade da senha', () {
    final viewModel = LoginViewModel(FakeAuthService());
    expect(viewModel.obscurePassword, isTrue);

    viewModel.togglePasswordVisibility();

    expect(viewModel.obscurePassword, isFalse);
  });

  test('"Lembrar de mim" começa desmarcado e alterna', () {
    final viewModel = LoginViewModel(FakeAuthService());
    expect(viewModel.rememberMe, isFalse);

    viewModel.toggleRememberMe();

    expect(viewModel.rememberMe, isTrue);
  });
}
