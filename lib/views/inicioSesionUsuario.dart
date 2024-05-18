import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../providers/alcancia_provider.dart';
import 'registroUsuario.dart';
import 'pantallaPrincipal.dart';

class InicioSesionUsuario extends StatefulWidget {
  const InicioSesionUsuario({Key? key}) : super(key: key);

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
      appBar: AppBar(
        title: Text('Iniciar Sesión'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  height: size.height * 0.2,
                  child: Image.asset(
                    'lib/assets/images/logo.png',
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Iniciar Sesión",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "¡Hola! Es bueno verte de nuevo",
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: "Correo electrónico",
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
                        User? user = await Provider.of<AlcanciaProvider>(
                          context,
                          listen: false,
                        ).signInWithEmailPassword(email, password);
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
                              builder: (context) => PantallaPrincipal(),
                            ),
                          );
                        } else {
                          // Si el usuario es nulo, mostrar un mensaje de error
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
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
                          SnackBar(
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
                  child: const Text("Iniciar Sesión"),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegistroUsuario(),
                      ),
                    );
                  },
                  child: const Text("¿No tienes una cuenta? Regístrate aquí"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
