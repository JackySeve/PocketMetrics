import 'package:alcancia_movil/views/inicioSesionUsuario.dart';
import 'package:alcancia_movil/views/widgets/menuDesplegablePrincipal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Ajustes extends StatefulWidget {
  const Ajustes({Key? key}) : super(key: key);

  @override
  _AjustesState createState() => _AjustesState();
}

class _AjustesState extends State<Ajustes> {
  double _fontSize = 16;
  String _fontFamily = 'Roboto';
  Color? _textColor;
  String _currentPassword = ''; // Variable para almacenar la contraseña actual
  String _newPassword = ''; // Variable para almacenar la nueva contraseña
  // Variables y métodos existentes en tu pantalla de ajustes

  void _changePassword() async {
    try {
      // Reautenticar al usuario para confirmar su identidad
      AuthCredential credential = EmailAuthProvider.credential(
        email: FirebaseAuth.instance.currentUser!.email!,
        password:
            _currentPassword, // Utiliza la contraseña actual ingresada por el usuario
      );
      await FirebaseAuth.instance.currentUser!
          .reauthenticateWithCredential(credential);

      // Cambiar la contraseña
      await FirebaseAuth.instance.currentUser!.updatePassword(
          _newPassword); // Utiliza la nueva contraseña ingresada por el usuario

      // Mostrar un mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Contraseña cambiada exitosamente'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (error) {
      // Manejar errores
      print('Error al cambiar la contraseña: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Error al cambiar la contraseña. Por favor, intenta de nuevo.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _deleteAccount() async {
    try {
      // Eliminar la cuenta de Firebase Auth
      await FirebaseAuth.instance.currentUser!.delete();

// Eliminar la información relacionada en Firestore
      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .delete();

// Mostrar un mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cuenta eliminada exitosamente'),
          backgroundColor: Colors.green,
        ),
      );

// Redirigir a la pantalla de inicio de sesión después de eliminar la cuenta
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => InicioSesionUsuario()),
        (Route<dynamic> route) => false,
      );
    } catch (error) {
      print('Error al eliminar la cuenta: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Error al eliminar la cuenta. Por favor, intenta de nuevo.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const logo = 'lib/assets/images/logo.png';
    // Estructura de tu pantalla de ajustes

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajustes'),
      ),
      drawer: menuDesplegablePrincipal(
        logo,
        context,
        user: FirebaseAuth.instance.currentUser,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Contenido existente en tu pantalla de ajustes

            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Mostrar diálogo o pantalla para cambiar la contraseña
                _showChangePasswordDialog(context);
              },
              child: const Text('Cambiar Contraseña'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Eliminar Cuenta'),
                    content: const Text(
                        '¿Estás seguro de que deseas eliminar tu cuenta? Esta acción no se puede deshacer.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancelar'),
                      ),
                      ElevatedButton(
                        onPressed: _deleteAccount,
                        child: const Text('Eliminar Cuenta'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Eliminar Cuenta'),
            )
          ],
        ),
      ),
    );
  }

  // Método para mostrar el diálogo o pantalla para cambiar la contraseña
  void _showChangePasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cambiar Contraseña'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration:
                    const InputDecoration(labelText: 'Contraseña Actual'),
                obscureText: true,
                onChanged: (value) {
                  // Actualizar la contraseña actual cuando el usuario escribe en el campo
                  setState(() {
                    _currentPassword = value;
                  });
                },
              ),
              TextField(
                decoration:
                    const InputDecoration(labelText: 'Nueva Contraseña'),
                obscureText: true,
                onChanged: (value) {
                  // Actualizar la nueva contraseña cuando el usuario escribe en el campo
                  setState(() {
                    _newPassword = value;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                // Cambiar la contraseña cuando el usuario confirma
                _changePassword();
                Navigator.pop(context);
              },
              child: const Text('Cambiar'),
            ),
          ],
        );
      },
    );
  }
}
