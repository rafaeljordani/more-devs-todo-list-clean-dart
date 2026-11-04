import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'session.dart';

class StoregeService {
  final storage = FlutterSecureStorage();
  static const _sessionKey = 'remembered_session';

  Future<void> addToken(String token, String userName) async {
    await storage.write(key: 'token:$userName', value: token);
  }

  Future<String?> getToken(String userName) async {
    return storage.read(key: 'token:$userName');
  }

  Future<void> deleteToken(String userName) async {
    await storage.delete(key: 'token:$userName');
    await storage.delete(key: _sessionKey);
  }

  Future<void> saveSession(Session session) async {
    await storage.write(
      key: _sessionKey,
      value: jsonEncode({
        'token': session.token,
        'user': {
          'id': session.user.id,
          'name': session.user.name,
          'email': session.user.email,
        },
      }),
    );
  }

  Future<Session?> getSavedSession() async {
    final value = await storage.read(key: _sessionKey);
    if (value == null) return null;

    try {
      return Session.fromMap(jsonDecode(value) as Map<String, dynamic>);
    } on FormatException {
      await storage.delete(key: _sessionKey);
      return null;
    } on TypeError {
      await storage.delete(key: _sessionKey);
      return null;
    }
  }
}
