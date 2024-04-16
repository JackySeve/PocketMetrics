// import 'package:alcancia_movil/views/alcancia.dart';
// import 'package:alcancia_movil/views/pantallaPrincipal.dart';
// import 'package:flutter/material.dart';

// void main() {
//   runApp(const MainApp());
// }

// class MainApp extends StatelessWidget {
//   const MainApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         body: Center(
//           child: pantallaPrincipal(
//             valorTotalAhorrado: alcancia().valorTotalAhorrado,
//           ),
//         ),

//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 200,
                width: 200,
                child: const Image(
                    image: NetworkImage(
                        'https://github.com/JackySeve/Alcancia-Movil/blob/main/lib/assets/images/logo.png?raw=true')),
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
                style:
                    TextStyle(fontFamily: 'Asap', fontWeight: FontWeight.bold),
              ),
              const Text(" "),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.green),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    print("PRESIONO EL BTN INICIAR SESION");
                  });
                },
                child: const Text(
                  'Iniciar Sesión',
                  style: TextStyle(color: Colors.white),
                ),
              ),
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
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.green),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    print("PRESIONO EL BTN REGISTRARSE");
                  });
                },
                child: const Text(
                  'Registrarse',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
