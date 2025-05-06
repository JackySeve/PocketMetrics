// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'reestablecerContrasena.dart';
import 'registroUsuario.dart';
import '../home/pantallaPrincipal.dart';

class InicioSesionUsuario extends StatefulWidget {
  const InicioSesionUsuario({super.key});

  @override
  _InicioSesionUsuarioState createState() => _InicioSesionUsuarioState();
}

class _InicioSesionUsuarioState extends State<InicioSesionUsuario>
    with SingleTickerProviderStateMixin {
  bool _obscureText = true;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("lib/assets/images/welcome_background.png"),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.white.withAlpha((0.55 * 255).toInt()),
                BlendMode.lighten,
              ),
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: size.height * 0.05),
                    Image.asset(
                      'lib/assets/images/logo.png',
                      height: size.height * 0.2,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: size.height * 0.03),
                    Text("PocketMetrics", style: _titleStyle(size)),
                    Text("Iniciar Sesión", style: _subtitleStyle(size)),
                    const SizedBox(height: 10),
                    const Text(
                      "¡Hola! Es bueno verte de nuevo",
                      style: TextStyle(fontFamily: 'Asap', color: Colors.black54),
                    ),
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
                    SizedBox(height: size.height * 0.025),
                    Text("──────────  Accede rápido con  ──────────",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade600)),
                    SizedBox(height: size.height * 0.015),
                    ElevatedButton.icon(
                      onPressed: _handleGoogleSignIn,
                      icon: Image.asset('lib/assets/images/icons/google_icon.png',
                          height: 24),
                      label: const Text("Continuar con Google"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        side: const BorderSide(color: Colors.grey),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),
                    TextButton(
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ForgotPasswordScreen())),
                      child: const Text('¿Olvidaste tu contraseña?',
                          style: TextStyle(color: Colors.green)),
                    ),
                    SizedBox(height: size.height * 0.02),
                    Text.rich(
                      TextSpan(
                        text: "¿Aún no estás registrado? ",
                        style:
                            const TextStyle(fontSize: 16, color: Colors.black54),
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
          _checkUserName(userCredential.user!);
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const PantallaPrincipal()));
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
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        _showSnackBar('El usuario canceló el inicio de sesión');
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      if (googleAuth.idToken == null || googleAuth.accessToken == null) {
        _showSnackBar('Error al obtener los tokens de Google');
        return;
      }

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      if (userCredential.user != null) {
        _checkUserName(userCredential.user!);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PantallaPrincipal()),
        );
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
    if (user.displayName == null || user.displayName!.isEmpty) {
      await user.updateDisplayName('Nombre Predeterminado');
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
                icon:
                    Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
                onPressed: () => setState(() => _obscureText = !_obscureText),
              )
            : null,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.green, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.green, width: 2),
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
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
