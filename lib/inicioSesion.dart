import 'package:flutter/material.dart';
import 'registroUsuario.dart';

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
            ),
            Form(
                child: Column(
              children: [
                SizedBox(
                  width: 350,
                  child: TextFormField(
                    decoration: InputDecoration(
                        label: Text(
                      "Correo o Usuario",
                      style: TextStyle(color: Colors.green),
                    )),
                  ),
                ),
                const Text(""),
                SizedBox(
                  width: 350,
                  child: TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                        label: Text(
                      "Contraseña",
                      style: TextStyle(color: Colors.green),
                    )),
                  ),
                ),
                const Text(" "),
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.green),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        )),
                    onPressed: () {},
                    child: const Text(
                      "Iniciar Sesion",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    )),
                const Text(" "),
                Text(
                  "¿Aun no estas registrado?",
                  style: TextStyle(color: Colors.grey),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => registerPage()),
                      );
                    },
                    child: const Text(
                      "Registrate",
                      style: TextStyle(color: Colors.green),
                    ))
              ],
            ))
          ],
        ),
      ),
    );
  }
}
