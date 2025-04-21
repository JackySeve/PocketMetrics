// ignore_for_file: file_names

import 'package:alcancia_movil/views/features/ahorroBanco.dart';
import 'package:alcancia_movil/views/features/ajustes.dart';
import 'package:alcancia_movil/views/features/alcancia.dart';
import 'package:alcancia_movil/views/features/cerrarSesion.dart';
import 'package:alcancia_movil/views/features/divisas.dart';
import 'package:alcancia_movil/views/features/estadisticos.dart';
import 'package:alcancia_movil/views/features/financiamientos.dart';
import 'package:alcancia_movil/views/features/gastos.dart';
import 'package:alcancia_movil/views/features/historial.dart';
import 'package:alcancia_movil/views/features/metas.dart';
import 'package:alcancia_movil/views/home/pantallaPrincipal.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
                      style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  _menuOption(context, FontAwesomeIcons.house, "Inicio", const PantallaPrincipal()),
                  _menuOption(context, FontAwesomeIcons.piggyBank, "Alcancía", const Alcancia()),
                  _menuOption(context, FontAwesomeIcons.clockRotateLeft, "Historial", const Historial()),
                  _menuOption(context, Icons.equalizer, "Estadísticos", const Estadisticos()),
                  _menuOption(context, FontAwesomeIcons.flagCheckered, "Metas", const Metas()),
                  _menuOption(context, FontAwesomeIcons.buildingUser, "Financiamiento", const FinanciamientoScreen()),
                  _menuOption(context, FontAwesomeIcons.buildingColumns, "Ahorros en Banco", const BankSavingsScreen()),
                  _menuOption(context, FontAwesomeIcons.moneyBills, "Gastos", const PantallaGastos()),
                  _menuOption(context, Icons.currency_exchange, "Divisas", const Divisas()),
                  _menuOption(context, FontAwesomeIcons.gear, "Ajustes", const Ajustes()),
                  const Divider(),
                  _menuOption(context, Icons.logout, "Cerrar Sesión", const PantallaCerrarSesion()),
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
      leading: Icon(icon, color: Colors.green, size: 30),
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
