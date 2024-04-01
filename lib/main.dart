import 'package:alcancia_movil/views/alcancia.dart';
import 'package:alcancia_movil/views/pantallaPrincipal.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: pantallaPrincipal(
            valorTotalAhorrado: alcancia().valorTotalAhorrado,
          ),
        ),
      ),
    );
  }
}
