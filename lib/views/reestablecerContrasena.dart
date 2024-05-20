import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();

  Future<void> _resetPassword(BuildContext context) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );
      // Mostrar un mensaje de éxito o redirigir a una pantalla de éxito.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Se ha enviado un correo electrónico para restablecer tu contraseña.'),
        ),
      );
    } catch (error) {
      // Manejar errores
      print(
          'Error al enviar el correo electrónico de restablecimiento de contraseña: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Error al enviar el correo electrónico de restablecimiento de contraseña.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('¿Olvidaste tu contraseña?'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Correo electrónico',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _resetPassword(context);
              },
              child: Text('Restablecer contraseña'),
            ),
          ],
        ),
      ),
    );
  }
}
