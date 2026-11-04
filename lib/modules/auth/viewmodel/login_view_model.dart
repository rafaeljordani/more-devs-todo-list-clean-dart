import 'package:flutter/foundation.dart';
import 'package:todo_gabarito/modules/auth/model/storege_service.dart';

import '../model/auth_service.dart';
import '../model/session.dart';

final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

class LoginViewModel extends ChangeNotifier {
  LoginViewModel(this.service, {StoregeService? storegeService})
      : storegeService = storegeService ?? StoregeService();

  final AuthService service;

  String _email = '';
  String _password = '';

  bool loading = false;
  bool obscurePassword = true;

  bool rememberMe = false;
  bool restoringSession = true;
  String? emailError;
  String? error;
  Session? session;

  bool get loggedIn => session != null;

  bool get canSubmit =>
      !loading && _email.trim().isNotEmpty && _password.isNotEmpty;

  final StoregeService storegeService;

  void setEmail(String value) {
    _email = value;
    emailError = null;
    error = null;
    notifyListeners();
  }

  void setPassword(String value) {
    _password = value;
    error = null;
    notifyListeners();
  }

  void togglePasswordVisibility() {
    obscurePassword = !obscurePassword;
    notifyListeners();
  }

  void toggleRememberMe() {
    rememberMe = !rememberMe;
    notifyListeners();
  }

  Future<void> login() async {
    if (!canSubmit) return;

    final email = _email.trim();
    if (!_emailPattern.hasMatch(email)) {
      emailError = 'Digite um e-mail válido';
      notifyListeners();
      return;
    }

    loading = true;
    error = null;
    notifyListeners();
    try {
      final authenticatedSession = await service.login(email, _password);
      session = authenticatedSession;
      if (rememberMe) {
        await storegeService.saveSession(authenticatedSession);
      } else {
        await storegeService
            .deleteToken(authenticatedSession.user.id.toString());
      }
    } on InvalidCredentialsException {
      error = 'E-mail ou senha incorretos';
    } catch (_) {
      error = 'Não foi possível entrar. Tente de novo.';
    }
    loading = false;
    notifyListeners();
  }

  Future<String?> getToken() async {
    final savedSession = await storegeService.getSavedSession();
    return savedSession?.token;
  }

  Future deleteToken() async {
    final savedSession = await storegeService.getSavedSession();
    if (savedSession != null) {
      await storegeService.deleteToken(savedSession.user.id.toString());
    }
  }

  Future<void> logout() async {
    if (session != null) {
      await storegeService.deleteToken(session!.user.id.toString());
    }
    session = null;
    rememberMe = false;
    notifyListeners();
  }

  Future<void> autoLogin() async {
    try {
      session = await storegeService.getSavedSession();
      if (session == null) {
        rememberMe = false;
      } else {
        rememberMe = true;
      }
    } catch (_) {
      session = null;
      rememberMe = false;
    } finally {
      restoringSession = false;
      notifyListeners();
    }
  }
}
