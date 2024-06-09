import 'package:alcancia_movil/views/inicioSesionUsuario.dart';
import 'package:alcancia_movil/views/widgets/menuDesplegablePrincipal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Ajustes extends StatefulWidget {
  const Ajustes({super.key});

  @override
  _AjustesState createState() => _AjustesState();
}

class _AjustesState extends State<Ajustes> {
  String _currentPassword = '';
  String _newPassword = '';

  Future<void> _changePassword() async {
    try {
      AuthCredential credential = EmailAuthProvider.credential(
        email: FirebaseAuth.instance.currentUser!.email!,
        password: _currentPassword,
      );
      await FirebaseAuth.instance.currentUser!
          .reauthenticateWithCredential(credential);
      await FirebaseAuth.instance.currentUser!.updatePassword(_newPassword);

      _showSnackbar('Contraseña cambiada exitosamente', Colors.green);
    } catch (error) {
      _showSnackbar(
          'Error al cambiar la contraseña. Por favor, intenta de nuevo.',
          Colors.red);
    }
  }

  Future<void> _deleteAccount() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      // Eliminar todas las subcolecciones y documentos relacionados con el usuario basado en el correo electrónico
      await _deleteUserData(user!.email!);

      await user.delete();

      _showSnackbar('Cuenta eliminada exitosamente', Colors.green);

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const InicioSesionUsuario()),
        (Route<dynamic> route) => false,
      );
    } catch (error) {
      _showSnackbar('Error al eliminar la cuenta. Por favor, intenta de nuevo.',
          Colors.red);
    }
  }

  Future<void> _deleteUserData(String email) async {
    final userDocRef =
        FirebaseFirestore.instance.collection('usuarios').doc(email);

    // Eliminar subcolecciones y sus documentos
    final collections = [
      'alcancia',
      'metas',
      'transacciones'
    ]; // Añade más subcolecciones si es necesario

    for (var collection in collections) {
      final subcollection = userDocRef.collection(collection);
      final snapshot = await subcollection.get();
      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }
    }

    // Eliminar el documento del usuario
    await userDocRef.delete();
  }

  void _showSnackbar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const logo = 'lib/assets/images/logo.png';

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
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _showChangePasswordDialog(context),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blueAccent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('Cambiar Contraseña'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _showDeleteAccountDialog(context),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.redAccent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('Eliminar Cuenta'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Cambiar Contraseña'),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildPasswordField(
                label: 'Contraseña Actual',
                onChanged: (value) => setState(() => _currentPassword = value),
              ),
              _buildPasswordField(
                label: 'Nueva Contraseña',
                onChanged: (value) => setState(() => _newPassword = value),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
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

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Eliminar Cuenta'),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          content: const Text(
              '¿Estás seguro de que deseas eliminar tu cuenta? Esta acción no se puede deshacer.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                _deleteAccount();
                Navigator.pop(context);
              },
              child: const Text('Eliminar Cuenta'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPasswordField(
      {required String label, required Function(String) onChanged}) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      obscureText: true,
      onChanged: onChanged,
    );
  }
}
