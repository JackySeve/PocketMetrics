import 'package:flutter/material.dart';

import 'inicioSesion.dart';
import 'registroUsuario.dart';

class InicioPrincipal extends StatelessWidget {
  const InicioPrincipal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 200,
              width: 200,
              child: const Image(
                  image: NetworkImage(
                      'https://raw.githubusercontent.com/JackySeve/Alcancia-Movil/main/lib/assets/images/logo.png')),
            ),
            const Text(
              "PocketMetrics",
              style: TextStyle(
                  color: Colors.green,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Asap'),
            ),
            const Text(
              '¡Bienvenido de nuevo! Es un placer poderte servir',
              style: TextStyle(fontFamily: 'Asap', fontWeight: FontWeight.bold),
            ),
            const Text(" "),
            NewWidget(),
            const Text(" "),
            const Text(
              "¿Eres nuevo? Unete e inicia una nueva forma",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text(
              "de organizar tus metas financieras",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text(" "),
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
          MaterialPageRoute(builder: (context) => registerPage()),
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
    Key? key,
  }) : super(key: key);

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
          MaterialPageRoute(builder: (context) => SecondPage()),
        );
      },
      child: const Text(
        'Iniciar Sesión',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
