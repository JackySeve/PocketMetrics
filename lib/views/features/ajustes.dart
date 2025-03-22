import 'package:alcancia_movil/views/auth/inicioSesionUsuario.dart';
import 'package:alcancia_movil/views/home/menuDesplegablePrincipal.dart';
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
          'Error al cambiar la contraseña. Intenta de nuevo.', Colors.red);
    }
  }

  Future<void> _deleteAccount() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      await _deleteUserData(user!.email!);
      await user.delete();
      _showSnackbar('Cuenta eliminada exitosamente', Colors.green);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const InicioSesionUsuario()),
        (Route<dynamic> route) => false,
      );
    } catch (error) {
      _showSnackbar(
          'Error al eliminar la cuenta. Intenta de nuevo.', Colors.red);
    }
  }

  Future<void> _deleteUserData(String email) async {
    final userDocRef =
        FirebaseFirestore.instance.collection('usuarios').doc(email);
    final collections = ['alcancia', 'metas', 'transacciones'];
    for (var collection in collections) {
      final subcollection = userDocRef.collection(collection);
      final snapshot = await subcollection.get();
      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }
    }
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajustes',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
      ),
      drawer: MenuDesplegable(
          logo: 'lib/assets/images/logo.png',
          user: FirebaseAuth.instance.currentUser),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              _buildButton(
                  'Cambiar Contraseña', Colors.blue, _showChangePasswordDialog),
              const SizedBox(height: 16),
              _buildButton(
                  'Eliminar Cuenta', Colors.red, _showDeleteAccountDialog),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(String text, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      child: Text(text, style: const TextStyle(fontSize: 16)),
    );
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return _buildDialog(
          title: 'Cambiar Contraseña',
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildPasswordField(
                  'Contraseña Actual', (value) => _currentPassword = value),
              const SizedBox(height: 10),
              _buildPasswordField(
                  'Nueva Contraseña', (value) => _newPassword = value),
            ],
          ),
          onConfirm: () {
            _changePassword();
            Navigator.pop(context);
          },
        );
      },
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return _buildDialog(
          title: 'Eliminar Cuenta',
          content: const Text(
              '¿Estás seguro de que deseas eliminar tu cuenta? Esta acción no se puede deshacer.',
              textAlign: TextAlign.center),
          onConfirm: () {
            _deleteAccount();
            Navigator.pop(context);
          },
        );
      },
    );
  }

  Widget _buildDialog(
      {required String title,
      required Widget content,
      required VoidCallback onConfirm}) {
    return AlertDialog(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      content: content,
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          onPressed: onConfirm,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          child: const Text('Confirmar'),
        ),
      ],
    );
  }

  Widget _buildPasswordField(String label, Function(String) onChanged) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      obscureText: true,
      onChanged: onChanged,
    );
  }
}
