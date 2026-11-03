import 'dart:async';

import 'package:dio/dio.dart';
import 'package:todo_gabarito/modules/auth/model/auth_service.dart';
import 'package:todo_gabarito/modules/auth/model/session.dart';

/// Service falso: aceita só aluno@todo.dev / 123456, nada de internet.
class FakeAuthService extends AuthService {
  FakeAuthService() : super(Dio());

  bool fail = false;
  final calls = <String>[];

  /// Quando definido, o login só termina ao completar este Completer.
  Completer<void>? gate;

  @override
  Future<Session> login(String email, String password) async {
    calls.add(email);
    await gate?.future;
    if (fail) throw Exception('Falha simulada');
    if (email != 'aluno@todo.dev' || password != '123456') {
      throw InvalidCredentialsException();
    }
    return const Session(
      token: 'token-de-teste',
      user: User(id: 1, name: 'Aluno', email: 'aluno@todo.dev'),
    );
  }
}
