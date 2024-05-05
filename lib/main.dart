import 'package:alcancia_movil/views/pantallaPrincipal.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:alcancia_movil/providers/alcancia_provider.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    ChangeNotifierProvider(
      create: (_) => AlcanciaProvider(),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
    Provider.of<AlcanciaProvider>(context, listen: false).verificarFechaMetas();
    _descargarDatosDesdeFirebase();
    Provider.of<AlcanciaProvider>(context, listen: false)
        .cargarMetasDesdeFirebase();
    Provider.of<AlcanciaProvider>(context, listen: false)
        .cargarTransaccionesDesdeFirebase();
  }

  Future<void> _descargarDatosDesdeFirebase() async {
    final alcanciaProvider =
        Provider.of<AlcanciaProvider>(context, listen: false);
    await alcanciaProvider.cargarDatosDesdeFirebase();
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PantallaPrincipal(),
    );
  }
}
