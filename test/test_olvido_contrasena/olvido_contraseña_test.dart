import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../test_inicio_sesion/auth_test.mock.mocks.dart';

void main() {
  group('Pruebas de Olvido de Contraseña', () {
    test('Usuario registrado recibe correo de restablecimiento', () async {
      final auth = MockAuth();

      String email = "hola@gmail.com";

      // Simula que el correo de restablecimiento se envía exitosamente
      when(auth.resetPasswordWithEmail(email)).thenAnswer((_) async => true);

      // Act (ejecuta la acción)
      var result = await auth.resetPasswordWithEmail(email);

      // Assert (verifica el resultado)
      expect(result, true, reason: 'El sistema debería enviar un correo de restablecimiento de contraseña a un usuario registrado.');
    });

    test('Correo no registrado intenta recuperar contraseña', () async {
      final auth = MockAuth();

      String email = "ejemplo@example.com";

      // Simula que el correo no está registrado
      when(auth.resetPasswordWithEmail(email)).thenAnswer((_) async => false);

      // Act (ejecuta la acción)
      var result = await auth.resetPasswordWithEmail(email);

      // Assert (verifica el resultado)
      expect(result, false, reason: 'El sistema no debería enviar un correo a un usuario no registrado.');
    });

    test('Campo de correo vacío al intentar recuperar contraseña', () async {
      final auth = MockAuth();

      String email = "";

      // Simula un intento con un campo de correo vacío
      when(auth.resetPasswordWithEmail(email)).thenAnswer((_) async => false);

      // Act (ejecuta la acción)
      var result = await auth.resetPasswordWithEmail(email);

      // Assert (verifica el resultado)
      expect(result, false, reason: 'El sistema no debería enviar un correo si el campo de correo está vacío.');
    });
  });
}
