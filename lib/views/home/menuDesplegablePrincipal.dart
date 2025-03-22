import 'package:alcancia_movil/views/features/ajustes.dart';
import 'package:alcancia_movil/views/features/alcancia.dart';
import 'package:alcancia_movil/views/features/cerrarSesion.dart';
import 'package:alcancia_movil/views/features/divisas.dart';
import 'package:alcancia_movil/views/features/estadisticos.dart';
import 'package:alcancia_movil/views/features/historial.dart';
import 'package:alcancia_movil/views/features/metas.dart';
import 'package:alcancia_movil/views/home/pantallaPrincipal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MenuDesplegable extends StatelessWidget {
  final String logo;
  final User? user;

  const MenuDesplegable({super.key, required this.logo, required this.user});

  @override
  Widget build(BuildContext context) {
    double drawerWidth = MediaQuery.of(context).size.width * 0.75;
    return SizedBox(
      width: drawerWidth,
      child: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(logo, width: 90, height: 80),
                  const SizedBox(height: 2),
                  const Text(
                    "PocketMetrics",
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (user != null)
                    Text(
                      'Bienvenido, ${user!.displayName ?? user!.email}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  _menuOption(context, Icons.home, "Inicio", const PantallaPrincipal()),
                  _menuOption(context, Icons.account_balance, "Alcancía", const Alcancia()),
                  _menuOption(context, Icons.history, "Historial", const Historial()),
                  _menuOption(context, Icons.equalizer, "Estadísticos", const Estadisticos()),
                  _menuOption(context, Icons.flag, "Metas", const Metas()),
                  _menuOption(context, Icons.settings, "Ajustes", const Ajustes()),
                  _menuOption(context, Icons.currency_exchange, "Divisas", const Divisas()),
                  const Divider(),
                  _menuOption(context, Icons.exit_to_app, "Cerrar Sesión", const PantallaCerrarSesion()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuOption(BuildContext context, IconData icon, String title, Widget destination) {
    return ListTile(
      leading: Icon(icon, color: Colors.green, size: 28),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      onTap: () {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      },
    );
  }
}
