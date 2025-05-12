// ignore_for_file: file_names

import 'package:alcancia_movil/services/nivel_service.dart';
import 'package:alcancia_movil/views/features/perfil.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

class MenuDesplegable extends StatefulWidget {
  final String logo;
  final User? user;

  const MenuDesplegable({super.key, required this.logo, required this.user});

  @override
  State<MenuDesplegable> createState() => _MenuDesplegableState();
}

class _MenuDesplegableState extends State<MenuDesplegable> {
  int _xp = 0;
  int _nivel = 0;
  double _progress = 0.0;
  int _currentLevelXP = 0;
  int _nextLevelXP = 100;
  String _rankName = 'Principiante';

  late XPService xpService;

  // Define rangos según nivel
  final List<Map<String, dynamic>> _rankThresholds = [
    {'name': 'Ahorrador Novato', 'minLevel': 0, 'maxLevel': 4},
    {'name': 'Ahorrador en Práctica', 'minLevel': 5, 'maxLevel': 9},
    {'name': 'Ahorrador Constante', 'minLevel': 10, 'maxLevel': 14},
    {'name': 'Estratega Financiero', 'minLevel': 15, 'maxLevel': 19},
    {'name': 'Inversionista en Crecimiento', 'minLevel': 20, 'maxLevel': 29},
    {'name': 'Maestro del Ahorro', 'minLevel': 30, 'maxLevel': 49},
    {'name': 'Leyenda Financiera', 'minLevel': 50, 'maxLevel': 99},
    {'name': 'Ícono del Ahorro', 'minLevel': 100, 'maxLevel': 149},
    {'name': 'Sabio Inversionista', 'minLevel': 150, 'maxLevel': 199},
    {'name': 'Arquitecto Financiero', 'minLevel': 200, 'maxLevel': 249},
    {'name': 'Magnate del Ahorro', 'minLevel': 250, 'maxLevel': 299},
    {'name': 'Mente Maestra Financiera', 'minLevel': 300, 'maxLevel': 349},
    {'name': 'Titán de las Finanzas', 'minLevel': 350, 'maxLevel': 399},
    {'name': 'Oráculo Económico', 'minLevel': 400, 'maxLevel': 449},
    {'name': 'Leyenda Inmortal del Ahorro', 'minLevel': 450, 'maxLevel': 499},
    {'name': 'Divinidad Financiera', 'minLevel': 500, 'maxLevel': 999},
    {'name': 'Entidad Suprema del Ahorro', 'minLevel': 1000, 'maxLevel': 9999},
  ];

  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      xpService = XPService(userId: widget.user!.uid);
      _cargarProgreso();
    }
  }

  Future<void> _cargarProgreso() async {
    final progreso = await xpService.obtenerProgreso();
    final xpTotal = progreso['xp'] as int;
    final nivelActual = progreso['nivel'] as int;

    final xpThresholdCurrent = xpService.calcularXPNivel(nivelActual);
    final xpThresholdNext = xpService.calcularXPNivel(nivelActual + 1);
    final xpIntoLevel = xpTotal - xpThresholdCurrent;
    final xpLevelRange = xpThresholdNext - xpThresholdCurrent;
    final progressValue = xpLevelRange > 0 ? xpIntoLevel / xpLevelRange : 0.0;

    setState(() {
      _xp = xpTotal;
      _nivel = nivelActual;
      _currentLevelXP = xpThresholdCurrent;
      _nextLevelXP = xpThresholdNext;
      _progress = progressValue;
      _rankName = _getRankName(nivelActual);
    });
  }

  String _getRankName(int level) {
    for (var rank in _rankThresholds) {
      final min = rank['minLevel'] as int;
      final max = rank['maxLevel'] as int;
      if (level >= min && level <= max) return rank['name'] as String;
    }
    return 'Desconocido';
  }

  @override
  Widget build(BuildContext context) {
    double drawerWidth = MediaQuery.of(context).size.width * 0.70;
    return SizedBox(
      width: drawerWidth,
      child: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              child: Column(
                children: [
                  if (widget.user != null)
                    Row(
                      children: [
                        Image.asset(widget.logo, width: 80, height: 70),
                        SizedBox(width: 8),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "PocketMetrics",
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Bienvenido, ${widget.user!.displayName ?? widget.user!.email}',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  const SizedBox(height: 2),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Rango: $_rankName',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Nivel $_nivel',
                        style: const TextStyle(
                            fontSize: 12,
                            color: Colors.green,
                            fontWeight: FontWeight.bold),
                      ),
                      LinearProgressIndicator(
                        value: _progress,
                        backgroundColor: Colors.grey.shade300,
                        color: Colors.green,
                        minHeight: 8,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'XP: ${_xp - _currentLevelXP} / ${_nextLevelXP - _currentLevelXP}',
                        style: const TextStyle(
                            fontSize: 12, color: Colors.black87),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  _menuOption(context, FontAwesomeIcons.house, "Inicio",
                      const PantallaPrincipal()),
                  _menuOption(context, FontAwesomeIcons.piggyBank, "Alcancía",
                      const Alcancia()),
                  _menuOption(context, FontAwesomeIcons.clockRotateLeft,
                      "Historial", const Historial()),
                  _menuOption(context, Icons.equalizer, "Estadísticos",
                      const Estadisticos()),
                  _menuOption(context, FontAwesomeIcons.flagCheckered, "Metas",
                      const Metas()),
                  _menuOption(context, FontAwesomeIcons.buildingUser,
                      "Financiamiento", const FinanciamientoScreen()),
                  _menuOption(context, FontAwesomeIcons.buildingColumns,
                      "Ahorros en Banco", const BankSavingsScreen()),
                  _menuOption(context, FontAwesomeIcons.moneyBills, "Gastos",
                      const PantallaGastos()),
                  _menuOption(context, Icons.currency_exchange, "Divisas",
                      const Divisas()),
                  _menuOption(context, FontAwesomeIcons.gear, "Ajustes",
                      const Ajustes()),
                  _menuOption(context, FontAwesomeIcons.person, "Perfil",
                      const PerfilScreen()),
                  const Divider(),
                  _menuOption(context, Icons.logout, "Cerrar Sesión",
                      const PantallaCerrarSesion()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuOption(
      BuildContext context, IconData icon, String title, Widget destination) {
    return ListTile(
      leading: Icon(icon, color: Colors.green, size: 28),
      title: Text(
        title,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
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
