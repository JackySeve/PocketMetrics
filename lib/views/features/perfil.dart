// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'package:alcancia_movil/Models/logro_model.dart';
import 'package:alcancia_movil/services/logro_service.dart';
import 'package:alcancia_movil/services/nivel_service.dart';
import 'package:alcancia_movil/providers/alcancia_provider.dart';
import 'package:alcancia_movil/views/home/menuDesplegablePrincipal.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  int _xp = 0;
  int _nivel = 0;
  double _progress = 0.0;
  int _currentLevelXP = 0;
  int _nextLevelXP = 100;
  String _rankName = 'Principiante';

  List<Logro> _logros = [];

  late LogrosService logrosService;
  late XPService xpService;
  User? user;

  final List<Map<String, dynamic>> _rankThresholds = [
    {'name': 'Principiante', 'minLevel': 0, 'maxLevel': 4},
    {'name': 'Aprendiz', 'minLevel': 5, 'maxLevel': 9},
    {'name': 'Intermedio', 'minLevel': 10, 'maxLevel': 14},
    {'name': 'Avanzado', 'minLevel': 15, 'maxLevel': 19},
    {'name': 'Experto', 'minLevel': 20, 'maxLevel': 29},
    {'name': 'Maestro', 'minLevel': 30, 'maxLevel': 49},
    {'name': 'Leyenda', 'minLevel': 50, 'maxLevel': 9999},
  ];

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      logrosService = LogrosService(userId: user!.uid);
      xpService = XPService(userId: user!.uid);

      _inicializarDatos();
    }
  }

  Future<void> _inicializarDatos() async {
    await _cargarProgreso();
    await _cargarLogros();
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

  Future<void> _cargarLogros() async {
    final provider = Provider.of<AlcanciaProvider>(context, listen: false);

    await logrosService.evaluarLogros(
      ahorroTotal: provider.totalAhorrado.toDouble(),
      transacciones: provider.transacciones.length,
      nivel: _nivel,
    );

    final logros = await logrosService.obtenerLogros();
    setState(() {
      _logros = logros.cast<Logro>();
    });
  }

  String _getRankName(int level) {
    for (var rank in _rankThresholds) {
      if (level >= rank['minLevel'] && level <= rank['maxLevel']) {
        return rank['name'];
      }
    }
    return 'Desconocido';
  }

  @override
  Widget build(BuildContext context) {
    final alcanciaProvider = Provider.of<AlcanciaProvider>(context);
    final nombre = user?.displayName ?? '';
    final correo = user?.email ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
      ),
      drawer: MenuDesplegable(
        logo: 'lib/assets/images/logo.png',
        user: FirebaseAuth.instance.currentUser,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildInfoItem('Nombre', nombre),
            _buildInfoItem('Correo electrónico', correo),
            const Divider(),
            _buildInfoItem('Total Ahorrado',
                '\$${alcanciaProvider.totalAhorrado.toStringAsFixed(2)}'),
            _buildInfoItem(
                'Transacciones', '${alcanciaProvider.transacciones.length}'),
            const Divider(),
            _buildInfoItem('Experiencia Acumulada', '$_xp XP'),
            _buildInfoItem('Nivel', '$_nivel'),
            _buildInfoItem('Rango', _rankName),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: _progress,
              minHeight: 8,
              backgroundColor: Colors.grey[300],
              color: Colors.green,
            ),
            const SizedBox(height: 4),
            Text(
              'XP: ${_xp - _currentLevelXP} / ${_nextLevelXP - _currentLevelXP}',
              style: const TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const Divider(),
            const Text('Logros',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _buildLogrosGaleria(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Text('$label:',
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(value, style: const TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  Widget _buildLogrosGaleria() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _logros.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // 3 por fila
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.8,
      ),
      itemBuilder: (context, index) {
        final logro = _logros[index];
        final icon = Icon(
          IconData(int.tryParse(logro.icono) ?? 0xe14c,
              fontFamily: 'MaterialIcons'),
          size: 40,
          color: logro.completado ? Colors.green : Colors.grey,
        );

        return Card(
          elevation: 2,
          color: logro.completado ? Colors.green[50] : Colors.grey[200],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon,
                const SizedBox(height: 8),
                Text(
                  logro.nombre,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  logro.descripcion,
                  style: const TextStyle(fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
