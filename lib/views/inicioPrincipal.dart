import 'package:flutter/material.dart';

import 'inicioSesion.dart';
import 'registroUsuario.dart';

class InicioPrincipal extends StatelessWidget {
  const InicioPrincipal({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 200,
              width: 200,
              child: Image(
                  image: NetworkImage(
                      'https://raw.githubusercontent.com/JackySeve/Alcancia-Movil/main/lib/assets/images/logo.png')),
            ),
            Text(
              "PocketMetrics",
              style: TextStyle(
                  color: Colors.green,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Asap'),
            ),
            Text(
              '¡Bienvenido de nuevo! Es un placer poderte servir',
              style: TextStyle(fontFamily: 'Asap', fontWeight: FontWeight.bold),
            ),
            Text(" "),
            NewWidget(),
            Text(" "),
            Text(
              "¿Eres nuevo? Unete e inicia una nueva forma",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              "de organizar tus metas financieras",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(" "),
            pageUserRegister(),
          ],
        ),
      ),
    );
  }
}

class pageUserRegister extends StatelessWidget {
  const pageUserRegister({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const registerPage()),
        );
      },
      child: const Text(
        'Registrarse',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}

class NewWidget extends StatelessWidget {
  const NewWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SecondPage()),
        );
      },
      child: const Text(
        'Iniciar Sesión',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
