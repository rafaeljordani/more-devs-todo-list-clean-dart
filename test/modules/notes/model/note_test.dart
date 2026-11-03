import 'package:flutter_test/flutter_test.dart';
import 'package:todo_gabarito/modules/notes/model/note.dart';

void main() {
  test('fromMap converte o JSON da API', () {
    final note = Note.fromMap({
      'id': 3,
      'title': 'Verbos HTTP',
      'content': 'GET, POST, PUT e DELETE',
      'updatedAt': '2026-10-29T13:45:00.000Z',
    });

    expect(note.id, 3);
    expect(note.title, 'Verbos HTTP');
    expect(note.content, 'GET, POST, PUT e DELETE');
    expect(note.updatedAt, DateTime.utc(2026, 10, 29, 13, 45));
  });

  test('fromMap aceita nota sem texto', () {
    final note = Note.fromMap({
      'id': 1,
      'title': 'Só título',
      'updatedAt': '2026-10-29T13:45:00.000Z',
    });

    expect(note.content, isEmpty);
  });

  test('matches procura no título e no texto, sem diferenciar maiúsculas', () {
    final note = Note(
      id: 1,
      title: 'O que é MVC',
      content: 'Model, View e Controller',
      updatedAt: DateTime(2026),
    );

    expect(note.matches('mvc'), isTrue);
    expect(note.matches('  CONTROLLER '), isTrue);
    expect(note.matches(''), isTrue);
    expect(note.matches('dart'), isFalse);
  });
}
