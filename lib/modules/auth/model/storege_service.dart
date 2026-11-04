import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StoregeService {
  final storage = FlutterSecureStorage();

  Future<void> addToken(String token, String userName) async {
    await storage.write(key: 'nameUser: $userName', value: token);
  }

  Future<String?> getToken(String userName) async {
    return await storage.read(key: userName).toString();
  }

  Future<void> deleteToken(String userName) async {
    await storage.delete(key: userName);
  }
}
