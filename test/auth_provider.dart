import 'package:flutter/material.dart';
import 'auth.dart';  // Importa la clase Auth que acabamos de crear

class AuthProvider with ChangeNotifier {
  final Auth _auth = Auth();  // Instancia de Auth

  // Aquí puedes agregar variables de estado que necesites para tu UI,
  // como si el usuario está autenticado o el error de autenticación
  bool _isAuthenticated = false;
  String _errorMessage = '';

  bool get isAuthenticated => _isAuthenticated;
  String get errorMessage => _errorMessage;

  // Método para iniciar sesión
  Future<void> signIn(String email, String password) async {
    bool result = await _auth.signInWithEmail(email, password);
    if (result) {
      _isAuthenticated = true;
      _errorMessage = '';
    } else {
      _isAuthenticated = false;
      _errorMessage = 'Error al iniciar sesión. Verifica tus credenciales.';
    }
    notifyListeners();
  }

  // Método para registrar un usuario
  Future<void> signUp(String email, String password) async {
    bool result = await _auth.signUpWithEmail(email, password);
    if (result) {
      _isAuthenticated = true;
      _errorMessage = '';
    } else {
      _isAuthenticated = false;
      _errorMessage = 'Error al registrar usuario.';
    }
    notifyListeners();
  }
}
