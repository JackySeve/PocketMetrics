// ignore_for_file: use_build_context_synchronously, avoid_print, library_private_types_in_public_api

import 'package:alcancia_movil/providers/alcancia_provider.dart';
import 'package:alcancia_movil/views/auth/inicioSesionUsuario.dart';
import 'package:alcancia_movil/views/home/menuDesplegablePrincipal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class Ajustes extends StatefulWidget {
  const Ajustes({super.key});

  @override
  _AjustesState createState() => _AjustesState();
}

class _AjustesState extends State<Ajustes> {
  String _currentPassword = '';
  String _newPassword = '';
  String _newName = '';
  String _newEmail = '';
  final String userEmail = FirebaseAuth.instance.currentUser?.email ?? '';

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
      if (user == null) {
        _showSnackbar('Error: No hay usuario autenticado.', Colors.red);
        return;
      }

      String userEmail =
          user.email!; // Guardamos el correo para eliminar de Firestore

      // 🔴 PASO 1: Eliminar los datos en Firestore antes de eliminar la cuenta
      await _deleteUserData(userEmail);

      // 🔴 PASO 2: Eliminar la cuenta en Firebase Authentication
      await user.delete();

      _showSnackbar('Cuenta eliminada exitosamente', Colors.green);

      // 🔴 PASO 3: Redirigir a la pantalla de inicio de sesión
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const InicioSesionUsuario()),
        (Route<dynamic> route) => false,
      );
    } catch (error) {
      _showSnackbar(
          'Error al eliminar la cuenta: ${error.toString()}', Colors.red);
    }
  }

  Future<void> _deleteUserData(String email) async {
    try {
      final userDocRef =
          FirebaseFirestore.instance.collection('usuarios').doc(email);
      final collections = ['alcancia', 'metas', 'transacciones'];

      // 🔴 Eliminar todas las subcolecciones primero
      for (var collection in collections) {
        var subcollection = await userDocRef.collection(collection).get();
        for (var doc in subcollection.docs) {
          await doc.reference.delete();
        }
      }

      // 🔴 Luego eliminar el documento principal del usuario
      await userDocRef.delete();
    } catch (error) {
      _showSnackbar(
          'Error al eliminar datos de usuario en Firestore.', Colors.red);
    }
  }

  void _showSnackbar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
      ),
    );
  }

  Future<void> _updateUserInfo() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        _showSnackbar('Error: Usuario no autenticado.', Colors.red);
        return;
      }

      List<String> updatedFields = [];

      // Actualizar nombre
      if (_newName.isNotEmpty && _newName != user.displayName) {
        await user.updateDisplayName(_newName);
        updatedFields.add('nombre');
      }

      // Si el usuario quiere cambiar su correo, necesita reautenticarse
      if (_newEmail.isNotEmpty && _newEmail != user.email) {
        await user.verifyBeforeUpdateEmail(_newEmail);
        updatedFields.add('correo');
      }

      // Verificamos si hubo cambios
      if (updatedFields.isEmpty) {
        _showSnackbar('No hiciste cambios en tu información.', Colors.orange);
        return;
      }

      // Recargar la información del usuario
      await user.reload();

      _showSnackbar(
          'Información actualizada: ${updatedFields.join(', ')}', Colors.green);
    } catch (error) {
      _showSnackbar('Error al actualizar la información: ${error.toString()}',
          Colors.red);
    }
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              Image.asset(
                'lib/assets/images/logo.png',
                height: 150,
                width: 150,
              ),

              const SizedBox(height: 20),

              _buildButton(
                  'Cambiar Contraseña', Colors.blue, _showChangePasswordDialog),
              const SizedBox(height: 16),
              _buildButton(
                  'Eliminar Cuenta', Colors.red, _showDeleteAccountDialog),
              const SizedBox(height: 16),
              _buildButton('Editar Información', Colors.orange,
                  _showEditUserInfoDialog), // Nuevo botón
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

  // Diálogo para cambiar la contraseña
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

  // Diálogo para eliminar la cuenta
  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return _buildDialogDelete(
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

  Future<void> _cargarDatos() async {
    try {
      final alcanciaProvider =
          Provider.of<AlcanciaProvider>(context, listen: false);
      await alcanciaProvider.verificarFechaMetas();
      if (mounted) {
        await alcanciaProvider.cargarDatosDesdeFirebase(userEmail);
        await alcanciaProvider.cargarMetasDesdeFirebase(userEmail);
        await alcanciaProvider.cargarTransaccionesDesdeFirebase(userEmail);
      }
    } catch (error) {
      print('Error al cargar datos: $error');
    }
  }

  // Diálogo para editar la información
  void _showEditUserInfoDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return _buildDialog(
          title: 'Editar Información',
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField('Nuevo Nombre', (value) => _newName = value),
              const SizedBox(height: 10),
              _buildTextField('Nuevo Correo', (value) => _newEmail = value),
            ],
          ),
          onConfirm: () {
            _updateUserInfo();
            Navigator.pop(context);
            _cargarDatos();
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child:
                  const Text('Cancelar', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: onConfirm,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Confirmar',
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildDialogDelete(
      {required String title,
      required Widget content,
      required VoidCallback onConfirm}) {
    return AlertDialog(
      title: Row(
        children: [
          Image.asset(
            'lib/assets/images/sad_logo.png',
            height: 150,
            width: 150,
          ),
          const SizedBox(width: 10),
          Expanded(
              child: Text(title,
                  style: const TextStyle(fontWeight: FontWeight.bold))),
        ],
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      content: content,
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child:
                  const Text('Cancelar', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: onConfirm,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Confirmar',
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildTextField(String label, Function(String) onChanged) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onChanged: onChanged,
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
