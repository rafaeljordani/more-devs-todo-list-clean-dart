import 'package:dio/dio.dart';
import 'package:todo_gabarito/modules/notes/model/note.dart';
import 'package:todo_gabarito/modules/notes/model/notes_service.dart';

/// Service falso: guarda as notas em memória, nada de internet.
class FakeNotesService extends NotesService {
  FakeNotesService() : super(Dio());

  final notes = [
    Note(
      id: 1,
      title: 'Clean Dart',
      content: 'Quatro camadas',
      updatedAt: DateTime(2026, 10, 29, 10),
    ),
    Note(
      id: 2,
      title: 'Mercado',
      content: 'Café e pão',
      updatedAt: DateTime(2026, 10, 28, 9),
    ),
  ];
  bool fail = false;
  int _nextId = 3;

  void _check() {
    if (fail) throw Exception('Falha simulada');
  }

  @override
  Future<List<Note>> fetchAll() async {
    _check();
    return List.of(notes);
  }

  @override
  Future<Note> create({required String title, required String content}) async {
    _check();
    final note = Note(
      id: _nextId++,
      title: title,
      content: content,
      updatedAt: DateTime.now(),
    );
    notes.insert(0, note);
    return note;
  }

  @override
  Future<Note> update(
    int id, {
    required String title,
    required String content,
  }) async {
    _check();
    final note = Note(
      id: id,
      title: title,
      content: content,
      updatedAt: DateTime.now(),
    );
    notes
      ..removeWhere((item) => item.id == id)
      ..insert(0, note);
    return note;
  }

  @override
  Future<void> delete(int id) async {
    _check();
    notes.removeWhere((item) => item.id == id);
  }
}
