import 'package:flutter_test/flutter_test.dart';
import 'package:todo_gabarito/modules/auth/model/session.dart';

void main() {
  test('fromMap converte o JSON do login', () {
    final session = Session.fromMap({
      'token': 'abc-123',
      'user': {'id': 1, 'name': 'Aluno', 'email': 'aluno@todo.dev'},
    });

    expect(session.token, 'abc-123');
    expect(session.user.id, 1);
    expect(session.user.name, 'Aluno');
    expect(session.user.email, 'aluno@todo.dev');
  });
}
