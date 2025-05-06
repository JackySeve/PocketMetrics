import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:alcancia_movil/views/home/paginaBienvenida.dart';
import 'package:alcancia_movil/providers/alcancia_provider.dart';
import 'package:alcancia_movil/providers/bank_savings_provider.dart';
import 'package:alcancia_movil/providers/divisas_provider.dart';
import 'package:alcancia_movil/providers/financiamiento_provider.dart';
import 'package:alcancia_movil/providers/gastos_provider.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final savedThemeMode = await AdaptiveTheme.getThemeMode();

  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp();
  }

  await _initializeNotifications();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AlcanciaProvider()),
        ChangeNotifierProvider(create: (_) => GastosProvider()),
        ChangeNotifierProvider(create: (_) => DivisasProvider()),
        ChangeNotifierProvider(create: (_) => BankSavingsProvider()),
        ChangeNotifierProvider(create: (_) => FinanciamientoProvider()),
      ],
      child: MainApp(savedThemeMode: savedThemeMode),
    ),
  );
}

Future<void> _initializeNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
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
          // Puedes agregar más rutas aquí
        },
      ),
    );
  }
}
