import 'package:alcancia_movil/views/paginaBienvenida.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PantallaCerrarSesion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cerrar Sesión'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            // Cerrar sesión
            await FirebaseAuth.instance.signOut();
            // Navegar a la pantalla de inicio de sesión o registro
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      InicioPrincipal()), // Opcional: Cambiar a RegistroUsuario si deseas redirigir a la pantalla de registro
              (Route<dynamic> route) =>
                  false, // Elimina todas las rutas anteriores
            );
          },
          child: Text('Cerrar Sesión'),
        ),
      ),
    );
  }
}
