import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../providers/alcancia_provider.dart';
import 'pantallaPrincipal.dart';
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
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (context) => AlcanciaProvider(),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 60),
                  SizedBox(
                    height: size.height * 0.15,
                    child: Image.asset(
                      'lib/assets/images/logo.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  const Text(
                    "PocketMetrics",
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Asap',
                    ),
                  ),
                  const Text(
                    "Regístrate",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 30,
                    child: Text(
                      "¡Bienvenido y espero llegues para quedarte!",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                  ),
                  TextFormField(
                    controller: _controladorName,
                    decoration: const InputDecoration(
                      labelText: "Usuario",
                      labelStyle: TextStyle(color: Colors.green),
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, ingrese su nombre de usuario';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: "Correo",
                      labelStyle: TextStyle(color: Colors.green),
                      prefixIcon: Icon(Icons.mail),
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
                      labelStyle: const TextStyle(color: Colors.green),
                      prefixIcon: const Icon(Icons.lock),
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
                      if (value.length < 8) {
                        return 'La contraseña debe tener al menos 8 caracteres';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureTextCheck,
                    decoration: InputDecoration(
                      labelText: "Verificar contraseña",
                      labelStyle: const TextStyle(color: Colors.green),
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(_obscureTextCheck
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () {
                          setState(() {
                            _obscureTextCheck = !_obscureTextCheck;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, confirme su contraseña';
                      }
                      if (value != _passwordController.text) {
                        return 'Las contraseñas no coinciden';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                        value: _isChecked,
                        onChanged: (value) {
                          setState(() {
                            _isChecked = value ?? false;
                          });
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text("Acepto "),
                          InkWell(
                            onTap: () async {
                              launchURL() async {
                                const url =
                                    'https://www.dominos.com.co/pages/order/menu#!/menu/category/viewall/';
                                Uri uri = Uri.parse(url);
                                await launchUrl(uri,
                                    mode: LaunchMode.externalApplication);
                              }
                            },
                            child: const Text(
                              "Términos y Condiciones",
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Colors.green),
                            ),
                          ),
                          const Text(" y "),
                          InkWell(
                            onTap: () async {
                              launchURL() async {
                                const url =
                                    'https://www.dominos.com.co/pages/order/menu#!/menu/category/viewall/';
                                Uri uri = Uri.parse(url);
                                await launchUrl(uri,
                                    mode: LaunchMode.externalApplication);
                              }
                            },
                            child: const Text(
                              "Política de Privacidad",
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Colors.green),
                            ),
                          ),
                          const Text("."),
                        ],
                      )
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // Lógica de registro de usuario
                        String name = _controladorName.text;
                        String email = _emailController.text;
                        String password = _passwordController.text;
                        if (_isChecked) {
                          try {
                            String? userId =
                                await Provider.of<AlcanciaProvider>(context,
                                        listen: false)
                                    .registerUser(name, email, password);
                            if (userId != null) {
                              // Registro exitoso, podrías navegar a otra pantalla o mostrar un mensaje de éxito.
                              print(
                                  'Usuario registrado con éxito. ID: $userId');
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const PantallaPrincipal()),
                              );
                            } else {
                              // Registro fallido, podrías mostrar un mensaje de error al usuario.
                              print('Error al registrar usuario.');
                            }
                          } catch (error) {
                            // Manejar el error al registrar al usuario
                            String errorMessage = 'Error al registrar usuario.';
                            if (error is FirebaseAuthException) {
                              // Si el error es específico de Firebase Auth
                              switch (error.code) {
                                case 'email-already-in-use':
                                  errorMessage =
                                      'El correo electrónico ya está en uso.';
                                  break;
                                // Puedes agregar más casos para manejar otros tipos de errores si lo deseas
                              }
                            }
                            print(errorMessage);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(errorMessage),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        } else {
                          // Si el checkbox no está marcado, mostramos un mensaje de error
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Por favor, acepta los términos y condiciones.'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: const Size(250, 40),
                    ),
                    child: const Text(
                      "Regístrarse",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: [
                        Text.rich(
                          TextSpan(
                            text: "¿Ya tienes una cuenta? ",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                            children: [
                              TextSpan(
                                text: "Inicia Sesión",
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
                                            const InicioSesionUsuario(),
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
      ),
    );
  }

  void launchURL() async {
    const url =
        'https://www.dominos.com.co/pages/order/menu#!/menu/category/viewall/';
    Uri uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
