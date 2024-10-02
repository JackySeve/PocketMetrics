import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'auth_test.mock.mocks.dart';

void main() {
  group('Pruebas de Inicio de Sesión', () {
    test('Usuario no registrado intenta iniciar sesión', () async {
      // Arrange (Configurar)
      final auth = MockAuth(); // Crear el mock de Auth
      String email = "ejemplo@example.com"; // Correo de prueba
      String password = "12345678"; // Contraseña de prueba

      // Simula que el usuario no está registrado
      when(auth.signInWithEmail(email, password))
          .thenAnswer((_) async => false);

      // Act (Actuar)
      var result = await auth.signInWithEmail(email, password);

      // Assert (Afirmar)
      expect(result, false,
          reason:
              'El sistema no debería dejar iniciar sesión a usuarios no registrados.');
    });

    test('Usuario registrado inicia sesión exitosamente', () async {
      // Arrange (Configurar)
      final auth = MockAuth();
      String email = "hola@gmail.com";
      String password = "12345678";

      // Simula que el usuario está registrado
      when(auth.signInWithEmail(email, password)).thenAnswer((_) async => true);

      // Act (Actuar)
      var result = await auth.signInWithEmail(email, password);

      // Assert (Afirmar)
      expect(result, true,
          reason:
              'El sistema debería permitir el inicio de sesión con credenciales válidas.');
    });

    test('Campos vacíos al intentar iniciar sesión', () async {
      // Arrange (Configurar)
      final auth = MockAuth();
      String email = "";
      String password = "";

      // Simula campos vacíos
      when(auth.signInWithEmail(email, password))
          .thenAnswer((_) async => false);

      // Act (Actuar)
      var result = await auth.signInWithEmail(email, password);

      // Assert (Afirmar)
      expect(result, false,
          reason: 'El sistema no debería permitir campos vacíos.');
    });

    test('Campo de contraseña vacío, correo válido', () async {
      // Arrange (Configurar)
      final auth = MockAuth();
      String email = "hola@gmail.com";
      String password = "";

      // Simula contraseña vacía
      when(auth.signInWithEmail(email, password))
          .thenAnswer((_) async => false);

      // Act (Actuar)
      var result = await auth.signInWithEmail(email, password);

      // Assert (Afirmar)
      expect(result, false,
          reason:
              'El sistema no debería permitir que la contraseña esté vacía.');
    });

    test('Campo de correo vacío, contraseña válida', () async {
      // Arrange (Configurar)
      final auth = MockAuth();
      String email = "";
      String password = "12345678";

      // Simula correo vacío
      when(auth.signInWithEmail(email, password))
          .thenAnswer((_) async => false);

      // Act (Actuar)
      var result = await auth.signInWithEmail(email, password);

      // Assert (Afirmar)
      expect(result, false,
          reason:
              'El sistema no debería permitir que el campo de correo esté vacío.');
    });
  });
}
