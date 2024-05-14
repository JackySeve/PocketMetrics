import 'package:alcancia_movil/views/paginaBienvenida.dart';
import 'package:alcancia_movil/views/widgets/menuDesplegablePrincipal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CerrarSesion extends StatelessWidget {
  const CerrarSesion({super.key});

  @override
  Widget build(BuildContext context) {
    const logo = 'lib/assets/images/logo.png';
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Alcancía'),
      ),
      drawer: menuDesplegablePrincipal(logo, context),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('¿Seguro que quieres cerrar sesión?'),
            ElevatedButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const InicioPrincipal()),
                  );
                },
                child: const Text('Cerrar Sesión'))
          ],
        ),
      ),
    );
  }
}
