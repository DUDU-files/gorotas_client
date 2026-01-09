import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vans/services/auth_service.dart';

class UserProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  User? _user;
  Map<String, dynamic>? _userData;
  bool _isLoading = false;

  User? get user => _user;
  Map<String, dynamic>? get userData => _userData;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _user != null;

  // ID do usuário para consultas no Firebase
  String? get userId => _user?.uid;

  // Nome do usuário para exibir no menu
  String get userName => _userData?['name'] ?? 'Usuário';
  String get userEmail => _userData?['e-mail'] ?? _user?.email ?? '';

  UserProvider() {
    // Ouvir mudanças no estado de autenticação
    _authService.authStateChanges.listen((User? user) {
      _user = user;
      if (user != null) {
        _loadUserData();
      } else {
        _userData = null;
      }
      notifyListeners();
    });
  }

  // Carregar dados do usuário do Firestore
  Future<void> _loadUserData() async {
    _userData = await _authService.getUserData();
    notifyListeners();
  }

  // Recarregar dados do usuário
  Future<void> refreshUserData() async {
    await _loadUserData();
  }

  // Cadastrar usuário
  Future<String?> register({
    required String name,
    required String cpf,
    required String phone,
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    String? error = await _authService.registerUser(
      name: name,
      cpf: cpf,
      phone: phone,
      email: email,
      password: password,
    );

    _isLoading = false;
    notifyListeners();

    return error;
  }

  // Login
  Future<String?> login({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    String? error = await _authService.loginUser(
      email: email,
      password: password,
    );

    if (error == null) {
      await _loadUserData();
    }

    _isLoading = false;
    notifyListeners();

    return error;
  }

  // Logout
  Future<void> logout() async {
    await _authService.logout();
    _user = null;
    _userData = null;
    notifyListeners();
  }

  // Atualizar perfil do usuário
  Future<void> updateProfile({
    required String name,
    required String phone,
  }) async {
    await _authService.updateUserProfile(
      name: name,
      phone: phone,
    );
    await _loadUserData();
  }
}
