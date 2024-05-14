import 'package:flutter/material.dart';

import 'inicioSesionUsuario.dart';
import 'pantallaPrincipal.dart';
import 'registroUsuario.dart';

class InicioPrincipal extends StatelessWidget {
  const InicioPrincipal({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SizedBox(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 60),
              ImageLogo(
                width: 250,
                height: 230,
                image: 'lib/assets/images/logo.png',
              ),
              Text(
                "PocketMetrics",
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Asap',
                ),
              ),
              Text(
                '¡Bienvenido de nuevo! Es un placer poderte servir',
                style: TextStyle(
                    fontFamily: 'Asap',
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              SizedBox(height: 15),
              iniciarSesionPage(),
              SizedBox(height: 25),
              Text(
                "¿Eres nuevo? Unete e inicia una nueva forma",
                style: TextStyle(
                    fontFamily: 'Asap',
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              Text(
                "de organizar tus metas financieras",
                style: TextStyle(
                    fontFamily: 'Asap',
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              SizedBox(height: 15),
              btnRegistroUsuario(),
            ],
          ),
        ),
      ),
    );
  }
}

class iniciarSesionPage extends StatelessWidget {
  const iniciarSesionPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const InicioSesionUsuario()),
        );
      },
      child: Container(
        width: 250,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Center(
          child: Text(
            "Iniciar Sesión",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class btnRegistroUsuario extends StatelessWidget {
  const btnRegistroUsuario({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const RegistroUsuario()),
        );
      },
      child: Container(
        width: 250,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Center(
          child: Text(
            "Registrarse",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
