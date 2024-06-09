import 'package:alcancia_movil/views/reestablecerContrasena.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../providers/alcancia_provider.dart';
import 'registroUsuario.dart';
import 'pantallaPrincipal.dart';

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
  bool _isLoading = false; // Variable para manejar el estado de carga

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 60),
                SizedBox(
                  height: size.height * 0.2,
                  child: Image.asset(
                    'lib/assets/images/logo.png',
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "PocketMetrics",
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Asap',
                  ),
                ),
                const Text(
                  "Iniciar Sesion",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Asap',
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "¡Hola! es bueno verte de nuevo",
                  style: TextStyle(fontFamily: 'Asap', color: Colors.grey),
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: "Correo electrónico",
                    labelStyle: TextStyle(color: Colors.green),
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingrese su correo electrónico';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    labelText: "Contraseña",
                    prefixIcon: const Icon(Icons.lock),
                    labelStyle: const TextStyle(color: Colors.green),
                    suffixIcon: IconButton(
                      icon: Icon(_obscureText
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingrese su contraseña';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      String email = _emailController.text;
                      String password = _passwordController.text;

                      try {
                        // Activar el indicador de carga
                        setState(() {
                          _isLoading = true;
                        });

                        // Llamar al método signInWithEmailPassword para iniciar sesión
                        UserCredential userCredential = await FirebaseAuth
                            .instance
                            .signInWithEmailAndPassword(
                          email: email,
                          password: password,
                        );

                        User? user = userCredential.user;

                        if (user != null) {
                          // Inicio de sesión exitoso, cargar los datos del usuario
                          await Provider.of<AlcanciaProvider>(
                            context,
                            listen: false,
                          ).loadUserData();

                          // Desactivar el indicador de carga
                          setState(() {
                            _isLoading = false;
                          });

                          // Redirigir al usuario a la pantalla principal
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PantallaPrincipal(),
                            ),
                          );
                        } else {
                          // Si el usuario es nulo, mostrar un mensaje de error
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Credenciales de inicio de sesión incorrectas'),
                              backgroundColor: Colors.red,
                            ),
                          );

                          // Desactivar el indicador de carga
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      } catch (error) {
                        // Capturar y manejar cualquier error
                        print('Error al iniciar sesión: $error');
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Error al iniciar sesión'),
                            backgroundColor: Colors.red,
                          ),
                        );

                        // Desactivar el indicador de carga
                        setState(() {
                          _isLoading = false;
                        });
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text(
                    "Iniciar Sesión",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    await Provider.of<AlcanciaProvider>(context, listen: false)
                        .signInWithGoogle();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PantallaPrincipal()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text(
                    "Google",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Agregar botón para restablecer contraseña
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ForgotPasswordScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    '¿Olvidaste tu contraseña?',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    children: [
                      Text.rich(
                        TextSpan(
                          text: "¿Aun no estas registrado? ",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                          children: [
                            TextSpan(
                              text: "Registrate",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const RegistroUsuario(),
                                    ),
                                  );
                                },
                            ),
                          ],
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
    );
  }
}
