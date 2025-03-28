import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../providers/alcancia_provider.dart';
import '../home/pantallaPrincipal.dart';
import 'inicioSesionUsuario.dart';

class RegistroUsuario extends StatefulWidget {
  const RegistroUsuario({super.key});

  @override
  _RegistroUsuarioState createState() => _RegistroUsuarioState();
}

class _RegistroUsuarioState extends State<RegistroUsuario> {
  bool _isChecked = false;
  bool _obscureText = true;
  bool _obscureTextCheck = true;
  final _formKey = GlobalKey<FormState>();
  final _controladorName = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    return Scaffold(
      body: ChangeNotifierProvider(
        create: (context) => AlcanciaProvider(),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.05,
              vertical: height * 0.02,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'lib/assets/images/logo.png',
                    height: height * 0.15,
                    fit: BoxFit.contain,
                  ),
                  const Text(
                    "PocketMetrics",
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Asap',
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Regístrate",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "¡Bienvenido y espero llegues para quedarte!",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  _buildTextField(
                    controller: _controladorName,
                    label: "Usuario",
                    icon: Icons.person,
                    validator: (value) =>
                        value!.isEmpty ? 'Ingrese su usuario' : null,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _emailController,
                    label: "Correo",
                    icon: Icons.mail,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingrese su correo';
                      }

                      // Expresión regular para validar correos electrónicos
                      String pattern =
                          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
                      RegExp regex = RegExp(pattern);

                      if (!regex.hasMatch(value)) {
                        return 'Formato de correo inválido';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildPasswordField(
                    controller: _passwordController,
                    label: "Contraseña",
                    obscureText: _obscureText,
                    toggleVisibility: () => setState(() {
                      _obscureText = !_obscureText;
                    }),
                    validator: (value) {
                      if (value!.length < 8) {
                        return 'Debe tener al menos 8 caracteres';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildPasswordField(
                    controller: _confirmPasswordController,
                    label: "Verificar contraseña",
                    obscureText: _obscureTextCheck,
                    toggleVisibility: () => setState(() {
                      _obscureTextCheck = !_obscureTextCheck;
                    }),
                    validator: (value) => value != _passwordController.text
                        ? 'Las contraseñas no coinciden'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Checkbox(
                        value: _isChecked,
                        onChanged: (value) =>
                            setState(() => _isChecked = value!),
                      ),
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            text: "Acepto ",
                            children: [
                              _buildLink("Términos y Condiciones"),
                              const TextSpan(text: " y "),
                              _buildLink("Política de Privacidad"),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildButton(
                    text: "Registrarse",
                    onPressed: _isChecked ? _onRegister : () {},
                    context: context,
                  ),
                  const SizedBox(height: 16),
                  Text.rich(
                    TextSpan(
                      text: "¿Ya tienes una cuenta? ",
                      style:
                          const TextStyle(fontSize: 16, color: Colors.black54),
                      children: [
                        TextSpan(
                          text: "Inicia Sesión",
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.green),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const InicioSesionUsuario()),
                                ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton({
    required BuildContext context,
    required String text,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        minimumSize: const Size(double.infinity, 50),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    Widget? suffixIcon,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black54),
        prefixIcon: Icon(icon),
        suffixIcon: suffixIcon,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.green, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.green, width: 2),
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscureText,
    required VoidCallback toggleVisibility,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility),
          onPressed: toggleVisibility,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.green, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.green, width: 2),
        ),
      ),
      validator: validator,
    );
  }

  TextSpan _buildLink(String text) {
    return TextSpan(
      text: text,
      style: const TextStyle(
          decoration: TextDecoration.underline, color: Colors.green),
      recognizer: TapGestureRecognizer()
        ..onTap = () => _launchURL("https://example.com"),
    );
  }

  void _onRegister() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Obtén los valores del formulario
        String email = _emailController.text;
        String password = _passwordController.text;
        String name = _controladorName.text;

        // Registrar al usuario con email y password
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Actualiza el displayName del usuario con el nombre proporcionado
        await userCredential.user!.updateDisplayName(name);
        await userCredential.user!
            .reload(); // Recargar para actualizar los datos del usuario

        // Navegar a la pantalla principal después del registro exitoso
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PantallaPrincipal()),
        );
      } catch (e) {
        // Manejo de errores en caso de fallar el registro
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al registrar el usuario')),
        );
      }
    }
  }

  void _launchURL(String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
