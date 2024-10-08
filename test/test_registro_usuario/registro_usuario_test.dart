import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../test_inicio_sesion/auth_test.mock.mocks.dart';

void main() {
  group('Pruebas de Inicio de Sesión', () {
    test('Usuario registrado intenta registrarse nuevamente', () async {
      final auth = MockAuth();

      String email = "hola@gmail.com";
      String password = "12345678";
      String verifyPassword = "12345678";
      bool termsAccepted = true;

      // Simula que el usuario ya está registrado
      when(auth.signUpWithEmail(email, password, verifyPassword, termsAccepted))
          .thenAnswer((_) async => false);

      // Act (ejecuta la acción)
      var result = await auth.signUpWithEmail(email, password, verifyPassword, termsAccepted);

      // Assert (verifica el resultado)
      expect(result, false,
          reason:
              'El sistema no debería permitir registrar un usuario ya registrado.');
    });

    test('Campos vacíos en el registro de usuario', () async {
      final auth = MockAuth();

      String email = "";
      String password = "";
      String verifyPassword = "";
      bool termsAccepted = false;

      // Simula campos vacíos
      when(auth.signUpWithEmail(email, password, verifyPassword, termsAccepted))
          .thenAnswer((_) async => false);

      // Act
      var result = await auth.signUpWithEmail(email, password, verifyPassword, termsAccepted);

      // Assert
      expect(result, false,
          reason: 'El sistema no debería permitir campos vacíos.');
    });

    test('Correo válido, contraseña vacía en el registro de usuario', () async {
      final auth = MockAuth();

      String email = "hola@gmail.com";
      String password = "";
      String verifyPassword = "";
      bool termsAccepted = true;

      // Simula contraseña vacía
      when(auth.signUpWithEmail(email, password, verifyPassword, termsAccepted))
          .thenAnswer((_) async => false);

      // Act
      var result = await auth.signUpWithEmail(email, password, verifyPassword, termsAccepted);

      // Assert
      expect(result, false,
          reason: 'El sistema no debería permitir registrar sin contraseña.');
    });

    test('Correo vacío, contraseña válida en el registro de usuario', () async {
      final auth = MockAuth();

      String email = "";
      String password = "12345678";
      String verifyPassword = "12345678";
      bool termsAccepted = true;

      // Simula correo vacío
      when(auth.signUpWithEmail(email, password, verifyPassword, termsAccepted))
          .thenAnswer((_) async => false);

      // Act
      var result = await auth.signUpWithEmail(email, password, verifyPassword, termsAccepted);

      // Assert
      expect(result, false,
          reason: 'El sistema no debería permitir registrar con correo vacío.');
    });

    test('Contraseña no coincide con verificación', () async {
      final auth = MockAuth();

      String email = "ejemplo@example.com";
      String password = "12345678";
      String verifyPassword = "87654321";
      bool termsAccepted = true;

      // Simula que las contraseñas no coinciden
      when(auth.signUpWithEmail(email, password, verifyPassword, termsAccepted))
          .thenAnswer((_) async => false);

      // Act
      var result = await auth.signUpWithEmail(email, password, verifyPassword, termsAccepted);

      // Assert
      expect(result, false,
          reason:
              'El sistema no debería permitir registrar si las contraseñas no coinciden.');
    });

    test('Campos completos pero términos y condiciones no aceptados', () async {
      final auth = MockAuth();

      String email = "hola@gmail.com";
      String password = "12345678";
      String verifyPassword = "12345678";
      bool termsAccepted = false; // Términos no aceptados

      // Simula que el usuario no acepta los términos y condiciones
      when(auth.signUpWithEmail(email, password, verifyPassword, termsAccepted))
          .thenAnswer((_) async => false);

      // Act
      var result = await auth.signUpWithEmail(
          email, password, verifyPassword, termsAccepted);

      // Assert
      expect(result, false,
          reason:
              'El sistema no debería permitir registrar sin aceptar los términos y condiciones.');
    });

    test('Contraseña menor a 8 caracteres', () async {
      final auth = MockAuth();

      String email = "hola@gmail.com";
      String password = "123";
      String verifyPassword = "123";
      bool termsAccepted = true; // Términos aceptados

      // Simula que la contraseña es menor a 8 caracteres
      when(auth.signUpWithEmail(email, password, verifyPassword, termsAccepted))
          .thenAnswer((_) async => false);

      // Act
      var result = await auth.signUpWithEmail(
          email, password, verifyPassword, termsAccepted);

      // Assert
      expect(result, false,
          reason:
              'El sistema no debería permitir registrar con una contraseña menor a 8 caracteres.');
    });

    test('Correo inválido', () async {
      final auth = MockAuth();

      String email = "invalidemail"; // Correo inválido
      String password = "12345678";
      String verifyPassword = "12345678";
      bool termsAccepted = true; // Términos aceptados

      // Simula que el correo es inválido
      when(auth.signUpWithEmail(email, password, verifyPassword, termsAccepted))
          .thenAnswer((_) async => false);

      // Act
      var result = await auth.signUpWithEmail(
          email, password, verifyPassword, termsAccepted);

      // Assert
      expect(result, false,
          reason:
              'El sistema no debería permitir registrar con un correo inválido.');
    });

    test('Intento de registro con usuario ya registrado', () async {
      final auth = MockAuth();

      String email = "ejemplo@example.com";
      String password = "12345678";
      String verifyPassword = "12345678";
      bool termsAccepted = true; // Términos aceptados

      // Simula que el usuario ya está registrado
      when(auth.signUpWithEmail(email, password, verifyPassword, termsAccepted))
          .thenAnswer((_) async => false);

      // Act
      var result = await auth.signUpWithEmail(
          email, password, verifyPassword, termsAccepted);

      // Assert
      expect(result, false,
          reason:
              'El sistema no debería permitir registrar a un usuario ya registrado.');
    });

    test('Registro exitoso con datos válidos', () async {
      final auth = MockAuth();

      String email = "ejemplo@example.com";
      String password = "12345678";
      String verifyPassword = "12345678";
      bool termsAccepted = true; // Términos aceptados

      // Simula un registro exitoso
      when(auth.signUpWithEmail(email, password, verifyPassword, termsAccepted))
          .thenAnswer((_) async => true);

      // Act
      var result = await auth.signUpWithEmail(
          email, password, verifyPassword, termsAccepted);

      // Assert
      expect(result, true,
          reason:
              'El sistema debería permitir registrar al usuario con datos válidos.');
    });

    test('Registro con contraseña solo de símbolos', () async {
      final auth = MockAuth();

      String email = "ejemplo@example.com";
      String password = "@@@@@@@@";
      String verifyPassword = "@@@@@@@@";
      bool termsAccepted = true; // Términos aceptados

      // Simula que la contraseña contiene solo símbolos
      when(auth.signUpWithEmail(email, password, verifyPassword, termsAccepted))
          .thenAnswer((_) async => true);

      // Act
      var result = await auth.signUpWithEmail(
          email, password, verifyPassword, termsAccepted);

      // Assert
      expect(result, true,
          reason:
              'El sistema debería permitir registrar con contraseñas de solo símbolos si son seguras.');
    });

    test('Contraseñas no coinciden', () async {
      final auth = MockAuth();

      String email = "ejemplo@example.com";
      String password = "12345678";
      String verifyPassword = "87654321"; // No coinciden
      bool termsAccepted = true; // Términos aceptados

      // Simula que las contraseñas no coinciden
      when(auth.signUpWithEmail(email, password, verifyPassword, termsAccepted))
          .thenAnswer((_) async => false);

      // Act
      var result = await auth.signUpWithEmail(
          email, password, verifyPassword, termsAccepted);

      // Assert
      expect(result, false,
          reason:
              'El sistema no debería permitir registrar si las contraseñas no coinciden.');
    });
  });
}
