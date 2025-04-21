// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../auth/reestablecerContrasena.dart';
import 'registroUsuario.dart';
import '../home/pantallaPrincipal.dart';

class InicioSesionUsuario extends StatefulWidget {
  const InicioSesionUsuario({super.key});

  @override
  _InicioSesionUsuarioState createState() => _InicioSesionUsuarioState();
}

class _InicioSesionUsuarioState extends State<InicioSesionUsuario> {
  bool _obscureText = true;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: size.height * 0.01),
                Image.asset(
                  'lib/assets/images/logo.png',
                  height: size.height * 0.2,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: size.height * 0.03),
                Text("PocketMetrics", style: _titleStyle(size)),
                Text("Iniciar Sesión", style: _subtitleStyle(size)),
                const SizedBox(height: 10),
                const Text("¡Hola! Es bueno verte de nuevo",
                    style:
                        TextStyle(fontFamily: 'Asap', color: Colors.black54)),
                SizedBox(height: size.height * 0.03),
                _buildTextField(
                    _emailController, "Correo electrónico", Icons.email),
                SizedBox(height: size.height * 0.02),
                _buildTextField(_passwordController, "Contraseña", Icons.lock,
                    isPassword: true),
                SizedBox(height: size.height * 0.04),
                _isLoading
                    ? const CircularProgressIndicator()
                    : _buildButton("Iniciar Sesión", _handleSignIn),
                SizedBox(height: size.height * 0.02),
                _buildButton("Google", _handleGoogleSignIn),
                SizedBox(height: size.height * 0.02),
                TextButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ForgotPasswordScreen())),
                  child: const Text('¿Olvidaste tu contraseña?',
                      style: TextStyle(color: Colors.green)),
                ),
                SizedBox(height: size.height * 0.03),
                Text.rich(
                  TextSpan(
                    text: "¿Aún no estás registrado? ",
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                    children: [
                      TextSpan(
                        text: "Regístrate",
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const RegistroUsuario()),
                              ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: size.height * 0.05),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleSignIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        if (userCredential.user != null) {
          // Llamamos al método para verificar y actualizar el nombre
          _checkUserName(userCredential.user!);

          // Redirigir a la pantalla principal
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const PantallaPrincipal()));
        } else {
          _showSnackBar('Credenciales incorrectas');
        }
      } catch (e) {
        _showSnackBar('Error: $e');
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  void _handleGoogleSignIn() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(
        GoogleAuthProvider.credential(
          accessToken: "accessToken",
          idToken: "idToken",
        ),
      );

      if (userCredential.user != null) {
        // Llamamos al método para verificar y actualizar el nombre
        _checkUserName(userCredential.user!);

        // Redirigir a la pantalla principal
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const PantallaPrincipal()));
      }
    } catch (e) {
      _showSnackBar('Error con Google: $e');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red));
  }

  void _checkUserName(User user) async {
    // Verificamos si el displayName es nulo o vacío
    if (user.displayName == null || user.displayName!.isEmpty) {
      // Actualizamos el displayName con un nombre predeterminado
      await user.updateDisplayName('Nombre Predeterminado');

      // Recargamos los datos del usuario para obtener el nuevo displayName
      await user.reload();
    }
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {bool isPassword = false}) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword ? _obscureText : false,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility),
                onPressed: () => setState(() => _obscureText = !_obscureText),
              )
            : null,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.green, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.green, width: 2),
        ),
      ),
      validator: (value) =>
          (value == null || value.isEmpty) ? 'Campo requerido' : null,
    );
  }

  Widget _buildButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          minimumSize: const Size(double.infinity, 50)),
      child: Text(text,
          style: const TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
    );
  }

  TextStyle _titleStyle(Size size) => TextStyle(
      color: Colors.green,
      fontSize: size.width * 0.1,
      fontWeight: FontWeight.bold,
      fontFamily: 'Asap');

  TextStyle _subtitleStyle(Size size) => TextStyle(
      fontSize: size.width * 0.08,
      fontWeight: FontWeight.bold,
      fontFamily: 'Asap');
}
