import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:alcancia_movil/providers/alcancia_provider.dart';
import 'package:alcancia_movil/views/pantallaPrincipal.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AlcanciaProvider(),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: PantallaPrincipal(),
        ),
      ),
    );
  }
}
