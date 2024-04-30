import 'package:flutter/material.dart';

class registerPage extends StatefulWidget {
  @override
  State<registerPage> createState() => _registerPageState();
}

class _registerPageState extends State<registerPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hola Mundo en Flutter',
      home: Scaffold(
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200,
              height: 200,
              child: Image(
                  image: NetworkImage(
                      'https://raw.githubusercontent.com/JackySeve/Alcancia-Movil/69537243881e5f5b9bf87200f7b14e4d0a660947/lib/assets/images/logo.png')),
            ),
            const Text(
              "PocketMetrics",
              style: TextStyle(
                  color: Colors.green,
                  fontSize: 35,
                  fontWeight: FontWeight.bold),
            ),
            const Text(
              "Registrate",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Text("¡Bienvenido y espero llegues para quedarte!"),
            Form(
                child: Column(
              children: [
                SizedBox(
                  width: 350,
                  child: TextFormField(
                    decoration: InputDecoration(
                      label: const Text(
                        "Usuario",
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                  ),
                ),
              ],
            ))
          ],
        )),
      ),
    );
  }
}
