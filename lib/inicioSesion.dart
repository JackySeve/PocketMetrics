import 'package:flutter/material.dart';

class SecondPage extends StatefulWidget {
  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200,
              height: 200,
              child: Image(
                  image: NetworkImage(
                      'https://raw.githubusercontent.com/JackySeve/Alcancia-Movil/main/lib/assets/images/logo.png')),
            ),
            const Text(
              "PocketMetrics",
              style: TextStyle(
                  color: Colors.green,
                  fontFamily: 'Asap',
                  fontSize: 35,
                  fontWeight: FontWeight.w900),
            ),
            const Text(
              "Iniciar Sesion",
              style: TextStyle(
                  fontFamily: 'Asap',
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            const Text(
              "¡Hola! Es bueno verte de nuevo.",
              style: TextStyle(fontSize: 15, color: Colors.grey),
            )
          ],
        ),
      ),
    );
  }
}
