import 'package:alcancia_movil/views/ajustes.dart';
import 'package:alcancia_movil/views/alcancia.dart';
import 'package:alcancia_movil/views/avanzados.dart';
import 'package:alcancia_movil/views/cerrarSesion.dart';
import 'package:alcancia_movil/views/divisas.dart';
import 'package:alcancia_movil/views/estadisticos.dart';
import 'package:alcancia_movil/views/historial.dart';
import 'package:alcancia_movil/views/metas.dart';
import 'package:alcancia_movil/views/pantallaPrincipal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

SizedBox menuDesplegablePrincipal(String logo, BuildContext context,
    {User? user}) {
  return SizedBox(
    width: 220,
    child: Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 240.0,
            child: DrawerHeader(
              child: Column(
                children: [
                  Image.asset(
                    logo,
                    width: 100,
                    height: 85,
                  ),
                  const Text(
                    "PocketMetrics",
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Mostrar la información del usuario actual
                  if (user != null)
                    Text(
                      'Bienvenido, \n${user.displayName ?? user.email}',
                      style: const TextStyle(fontSize: 13, color: Colors.black),
                    ),
                ],
              ),
            ),
          ),
          menuOption(context, Icons.apps, "Inicio", const PantallaPrincipal()),
          const SizedBox(height: 5),
          menuOption(
              context, Icons.account_balance, "Alcancía", const Alcancia()),
          const SizedBox(height: 5),
          menuOption(context, Icons.history, "Historial de Movimientos",
              const Historial()),
          const SizedBox(height: 5),
          menuOption(
              context, Icons.equalizer, "Estadísticos", const Estadisticos()),
          const SizedBox(height: 5),
          menuOption(
              context, Icons.trending_up, "Avanzados", const Avanzados()),
          const SizedBox(height: 5),
          menuOption(context, Icons.flag, "Metas", const Metas()),
          const SizedBox(height: 5),
          menuOption(context, Icons.settings, "Ajustes", const Ajustes()),
          const SizedBox(height: 5),
          menuOption(
              context, Icons.currency_exchange, "Divisas", const Divisas()),
          const SizedBox(height: 5),
          menuOption(context, Icons.input, "Cerrar Sesión",
              const PantallaCerrarSesion()),
        ],
      ),
    ),
  );
}

Widget menuOption(
    BuildContext context, IconData icon, String title, Widget? destination,
    {bool closeApp = false}) {
  return SizedBox(
    height: 60,
    child: Container(
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 226, 225, 225),
      ),
      child: Center(
        child: ListTile(
          leading: Icon(
            icon,
            color: Colors.green,
            size: 32,
          ),
          title: Text(
            title,
            style: const TextStyle(fontSize: 18),
          ),
          onTap: () {
            if (destination != null) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => destination),
              );
            }
            if (closeApp) {
              SystemNavigator.pop();
            }
          },
        ),
      ),
    ),
  );
}

class CerrarSesion extends StatelessWidget {
  const CerrarSesion({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: OutlinedButton(
        onPressed: () {
          FirebaseAuth.instance.signOut();
          Navigator.pushNamedAndRemoveUntil(
              context, "/login", (Route<dynamic> route) => false);
        },
        child: const Text("Cerrar Sesión"),
      ),
    );
  }
}
