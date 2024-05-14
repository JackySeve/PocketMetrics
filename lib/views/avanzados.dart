import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:provider/provider.dart';
import '../providers/alcancia_provider.dart';
import 'metas.dart';
import 'widgets/menuDesplegablePrincipal.dart';
import 'package:fl_chart/fl_chart.dart';

class Avanzados extends StatefulWidget {
  const Avanzados({super.key});

  @override
  _AvanzadosState createState() => _AvanzadosState();
}

class _AvanzadosState extends State<Avanzados> {
  List<Meta> _metasCumplidas() {
    return Provider.of<AlcanciaProvider>(context, listen: false)
        .metas
        .where((meta) => meta.valorAhorrado == meta.valorObjetivo)
        .toList();
  }

  List<Meta> _metasIncumplidas() {
    return Provider.of<AlcanciaProvider>(context, listen: false)
        .metas
        .where((meta) => meta.valorAhorrado < meta.valorObjetivo)
        .toList();
  }

  late List<charts.Series<TransaccionPorDia, String>> _seriesIngresos;
  late List<charts.Series<TransaccionPorDia, String>> _seriesEgresos;

  @override
  void initState() {
    super.initState();
    _seriesIngresos = [];
    _seriesEgresos = [];
    _agruparTransaccionesPorDia();
  }

  void _agruparTransaccionesPorDia() {
    final provider = Provider.of<AlcanciaProvider>(context, listen: false);
    final transacciones = provider.transacciones;

    Map<String, double> ingresosPorDia = {};
    Map<String, double> egresosPorDia = {};

    for (var transaccion in transacciones) {
      String dia = _obtenerDiaDeSemana(transaccion.fecha);
      if (transaccion.esIngreso) {
        ingresosPorDia[dia] = (ingresosPorDia[dia] ?? 0) + transaccion.monto;
      } else {
        egresosPorDia[dia] = (egresosPorDia[dia] ?? 0) + transaccion.monto;
      }
    }

    _seriesIngresos = [
      charts.Series<TransaccionPorDia, String>(
        id: 'Ingresos',
        domainFn: (TransaccionPorDia transaccion, _) => transaccion.dia,
        measureFn: (TransaccionPorDia transaccion, _) => transaccion.monto,
        data: ingresosPorDia.entries
            .map((entry) => TransaccionPorDia(entry.key, entry.value))
            .toList(),
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
      )
    ];

    _seriesEgresos = [
      charts.Series<TransaccionPorDia, String>(
        id: 'Egresos',
        domainFn: (TransaccionPorDia transaccion, _) => transaccion.dia,
        measureFn: (TransaccionPorDia transaccion, _) => transaccion.monto,
        data: egresosPorDia.entries
            .map((entry) => TransaccionPorDia(entry.key, entry.value))
            .toList(),
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
      )
    ];
  }

  String _obtenerDiaDeSemana(DateTime fecha) {
    switch (fecha.weekday) {
      case 1:
        return 'Lunes';
      case 2:
        return 'Martes';
      case 3:
        return 'Miércoles';
      case 4:
        return 'Jueves';
      case 5:
        return 'Viernes';
      case 6:
        return 'Sábado';
      case 7:
        return 'Domingo';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final alcanciaProvider = Provider.of<AlcanciaProvider>(context);
    final metasData = alcanciaProvider.obtenerMetasCumplidasEIncumplidas();
    final metasCumplidas = metasData['metasCumplidas'] ?? 0;
    final metasIncumplidas = metasData['metasIncumplidas'] ?? 0;
    final totalMetas = metasCumplidas + metasIncumplidas;

    const logo = 'lib/assets/images/logo.png';
    if (alcanciaProvider.transacciones.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Avanzados'),
        ),
        drawer: menuDesplegablePrincipal(
          logo,
          context,
          user: FirebaseAuth.instance.currentUser,
        ),
        body: const Center(
          child: Text('No hay transacciones aún'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Avanzados'),
      ),
      drawer: menuDesplegablePrincipal(logo, context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Histograma de Ingresos',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: charts.BarChart(
                _seriesIngresos,
                animate: true,
              ),
            ),
            const SizedBox(height: 32.0),
            const Text(
              'Histograma de Egresos',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: charts.BarChart(
                _seriesEgresos,
                animate: true,
              ),
            ),
            const SizedBox(height: 32.0),
            const Text(
              'Gráfico de Pastel de Metas',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            totalMetas > 0
                ? Flexible(
                    child: Consumer<AlcanciaProvider>(
                      builder: (context, provider, child) {
                        int totalMetas = _metasCumplidas().length +
                            _metasIncumplidas().length;
                        return PieChart(
                          PieChartData(
                            centerSpaceRadius: 0,
                            sections: [
                              PieChartSectionData(
                                  value: _metasCumplidas().length.toDouble(),
                                  color: Colors.green,
                                  title:
                                      '${((_metasCumplidas().length / totalMetas) * 100).toStringAsFixed(2)}%',
                                  radius: 100),
                              PieChartSectionData(
                                  value: _metasIncumplidas().length.toDouble(),
                                  color: Colors.red,
                                  title:
                                      '${((_metasIncumplidas().length / totalMetas) * 100).toStringAsFixed(2)}%',
                                  radius: 100),
                            ],
                          ),
                        );
                      },
                    ),
                  )
                : const Text('No hay metas aún'),
          ],
        ),
      ),
    );
  }
}

class TransaccionPorDia {
  final String dia;
  final double monto;

  TransaccionPorDia(this.dia, this.monto);
}
