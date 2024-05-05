import 'package:alcancia_movil/views/ajustes.dart';
import 'package:alcancia_movil/views/alcancia.dart';
import 'package:alcancia_movil/views/avanzados.dart';
import 'package:alcancia_movil/views/divisas.dart';
import 'package:alcancia_movil/views/estadisticos.dart';
import 'package:alcancia_movil/views/historial.dart';
import 'package:alcancia_movil/views/metas.dart';
import 'package:alcancia_movil/views/pantallaPrincipal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../cerrarSesion.dart';

SizedBox menuDesplegablePrincipal(String logo, BuildContext context) {
  return SizedBox(
    width: 220,
    child: Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 200.0,
            child: DrawerHeader(
              child: Column(
                children: [
                  Container(
                    child: Image.asset(
                      logo,
                      width: 100,
                      height: 85,
                    ),
                  ),
                  Container(
                    child: const Text(
                      "PocketMetrics",
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
          menuOption(
              context, Icons.input, "Cerrar Sesión", const CerrarSesion(),
              closeApp: true),
        ],
      ),
    ),
  );
}

Widget menuOption(
    BuildContext context, IconData icon, String title, Widget? destination,
    {bool closeApp = false}) {
  return SizedBox(
    height: 55,
    child: Container(
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 226, 225, 225),
      ),
      child: Center(
        child: ListTile(
          contentPadding: const EdgeInsets.only(left: 30),
          leading: Icon(
            icon,
            color: const Color.fromRGBO(16, 162, 31, 1),
            size: 40,
          ),
          title: Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          onTap: () {
            if (destination != null) {
              if (closeApp) {
                SystemNavigator.pop();
              } else {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => destination),
                );
              }
            } else {
              SystemNavigator.pop();
            }
          },
        ),
      ),
    ),
  );
}
