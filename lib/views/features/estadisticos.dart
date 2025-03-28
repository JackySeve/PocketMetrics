import 'package:alcancia_movil/providers/alcancia_provider.dart';
import 'package:alcancia_movil/views/features/metas.dart';
import 'package:alcancia_movil/views/home/menuDesplegablePrincipal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart'; // Cambié aquí para fl_chart

class Estadisticos extends StatefulWidget {
  const Estadisticos({super.key});

  @override
  _EstadisticosState createState() => _EstadisticosState();
}

class _EstadisticosState extends State<Estadisticos> {
  int _selectedIndex = 0;

  List<BarChartGroupData> _ingresosData = [];
  List<BarChartGroupData> _egresosData = [];

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<AlcanciaProvider>(context, listen: false);
    provider.addListener(_actualizarDatos);
    _agruparTransaccionesPorDia();
  }

  void _actualizarDatos() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _agruparTransaccionesPorDia();
        });
      }
    });
  }

  @override
  void dispose() {
    final provider = Provider.of<AlcanciaProvider>(context, listen: false);
    provider.removeListener(_actualizarDatos);
    super.dispose();
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

    /// 🚀 **Ejecución después de que Flutter termine el frame actual**
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _ingresosData = ingresosPorDia.entries
              .map((entry) => BarChartGroupData(
                    x: _obtenerIndiceDia(entry.key),
                    barRods: [
                      BarChartRodData(
                        toY: entry.value,
                        color: Colors.green,
                        width: 20,
                      ),
                    ],
                  ))
              .toList();

          _egresosData = egresosPorDia.entries
              .map((entry) => BarChartGroupData(
                    x: _obtenerIndiceDia(entry.key),
                    barRods: [
                      BarChartRodData(
                        toY: entry.value,
                        color: Colors.red,
                        width: 20,
                      ),
                    ],
                  ))
              .toList();
        });
      }
    });
  }

  int _obtenerIndiceDia(String dia) {
    switch (dia) {
      case 'Lunes':
        return 0;
      case 'Martes':
        return 1;
      case 'Miércoles':
        return 2;
      case 'Jueves':
        return 3;
      case 'Viernes':
        return 4;
      case 'Sábado':
        return 5;
      case 'Domingo':
        return 6;
      default:
        return 7;
    }
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
        Expanded(
          child: BarChart(
            BarChartData(
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      List<String> dias = [
                        'Lun',
                        'Mar',
                        'Mié',
                        'Jue',
                        'Vie',
                        'Sáb',
                        'Dom'
                      ];
                      return Text(
                        dias[value.toInt()],
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      );
                    },
                  ),
                ),
              ),
              barGroups: _ingresosData,
            ),
          ),
        ),
        const SizedBox(height: 16.0),
        const Text(
          'Histograma de Egresos',
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16.0),
        Expanded(
          child: BarChart(
            BarChartData(
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      List<String> dias = [
                        'Lun',
                        'Mar',
                        'Mié',
                        'Jue',
                        'Vie',
                        'Sáb',
                        'Dom'
                      ];
                      return Text(
                        dias[value.toInt()],
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      );
                    },
                  ),
                ),
              ),
              barGroups: _egresosData,
            ),
          ),
        ),
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
      appBar: AppBar(title: const Text('Estadísticas')),
      drawer: MenuDesplegable(
        logo: 'lib/assets/images/logo.png',
        user: FirebaseAuth.instance.currentUser,
      ),
      body: Consumer<AlcanciaProvider>(
        builder: (context, provider, child) {
          _agruparTransaccionesPorDia(); // Llamamos cada vez que el provider cambia
          return _buildContent();
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.assessment),
            label: 'Estadísticas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Gráfica',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle_outline),
            label: 'Metas',
          ),
        ],
      ),
    );
  }
}
