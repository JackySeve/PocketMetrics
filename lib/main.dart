import 'package:alcancia_movil/providers/gastos_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:alcancia_movil/views/home/paginaBienvenida.dart';
import 'package:alcancia_movil/providers/alcancia_provider.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AlcanciaProvider()),
        ChangeNotifierProvider(create: (_) => GastosProvider()),
        // Se pueden agregar más providers aquí en el futuro
      ],
      child: MainApp(savedThemeMode: savedThemeMode),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key, this.savedThemeMode});

  final AdaptiveThemeMode? savedThemeMode;

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: Colors.blue,
      ),
      dark: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.blue,
      ),
      initial: savedThemeMode ?? AdaptiveThemeMode.light,
      builder: (theme, darkTheme) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme,
        darkTheme: darkTheme,
        initialRoute: "inicio",
        routes: {
          "inicio": (context) => const InicioPrincipal(),
          // Aquí se pueden agregar más rutas si es necesario
        },
      ),
    );
  }
}
