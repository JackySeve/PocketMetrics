import 'package:alcancia_movil/providers/alcancia_provider.dart';
import 'package:alcancia_movil/views/features/metas.dart';
import 'package:alcancia_movil/views/home/menuDesplegablePrincipal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:fl_chart/fl_chart.dart';

class Estadisticos extends StatefulWidget {
  const Estadisticos({super.key});

  @override
  _EstadisticosState createState() => _EstadisticosState();
}

class _EstadisticosState extends State<Estadisticos> {
  int _selectedIndex = 0;

  List<charts.Series<TransaccionPorDia, String>> _seriesIngresos = [];
  List<charts.Series<TransaccionPorDia, String>> _seriesEgresos = [];

  @override
  void initState() {
    super.initState();
    _agruparTransaccionesPorDia();
  }

  void _agruparTransaccionesPorDia() {
    final provider = Provider.of<AlcanciaProvider>(context, listen: false);
    final transacciones = provider.transacciones;

    Map<String, double> ingresosPorDia = {
      'Lunes': 0,
      'Martes': 0,
      'Miércoles': 0,
      'Jueves': 0,
      'Viernes': 0,
      'Sábado': 0,
      'Domingo': 0
    };
    Map<String, double> egresosPorDia = {
      'Lunes': 0,
      'Martes': 0,
      'Miércoles': 0,
      'Jueves': 0,
      'Viernes': 0,
      'Sábado': 0,
      'Domingo': 0
    };

    for (var transaccion in transacciones) {
      String dia = _obtenerDiaDeSemana(transaccion.fecha);
      if (transaccion.esIngreso) {
        ingresosPorDia[dia] = ingresosPorDia[dia]! + 1;
      } else {
        egresosPorDia[dia] = egresosPorDia[dia]! + 1;
      }
    }

    setState(() {
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
    });
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

  Widget _buildContent() {
    switch (_selectedIndex) {
      case 0:
        return _buildEstadisticas();
      case 1:
        return _buildGraficaDiaria();
      case 2:
        return _buildGraficaMetas();
      default:
        return _buildEstadisticas();
    }
  }

  Widget _buildEstadisticas() {
    final alcanciaProvider = Provider.of<AlcanciaProvider>(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _estadisticoItem('Promedio de Transacciones',
              alcanciaProvider.calcularMedia().toStringAsFixed(2)),
          _estadisticoItem('Variabilidad de Transacciones',
              alcanciaProvider.calcularDesviacionEstandar().toStringAsFixed(2)),
        ],
      ),
    );
  }

  Widget _buildGraficaDiaria() {
    return Column(
      children: [
        const Text(
          'Histograma de Ingresos',
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16.0),
        Expanded(child: charts.BarChart(_seriesIngresos, animate: true)),
        const SizedBox(height: 16.0),
        const Text(
          'Histograma de Egresos',
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16.0),
        Expanded(child: charts.BarChart(_seriesEgresos, animate: true)),
      ],
    );
  }

  Widget _buildGraficaMetas() {
    int totalMetas = _metasCumplidas().length + _metasIncumplidas().length;
    return totalMetas > 0
        ? PieChart(
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
          )
        : const Center(child: Text('No hay metas aún'));
  }

  Widget _estadisticoItem(String label, String value) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(value,
                style: const TextStyle(fontSize: 16, color: Colors.blueGrey)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Estadísticos')),
      drawer: MenuDesplegable(
          logo: 'lib/assets/images/logo.png',
          user: FirebaseAuth.instance.currentUser),
      body: _buildContent(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.analytics), label: 'Estadísticas'),
          BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart), label: 'Gráficas de Ahorro'),
          BottomNavigationBarItem(
              icon: Icon(Icons.pie_chart), label: 'Gráfica de Metas'),
        ],
      ),
    );
  }
}

class TransaccionPorDia {
  final String dia;
  final double monto;
  TransaccionPorDia(this.dia, this.monto);
}
