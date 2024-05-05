import 'package:alcancia_movil/providers/alcancia_provider.dart';
import 'package:alcancia_movil/views/widgets/menuDesplegablePrincipal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Estadisticos extends StatelessWidget {
  const Estadisticos({super.key});

  @override
  Widget build(BuildContext context) {
    final alcanciaProvider = context.watch<AlcanciaProvider>();
    const logo = 'lib/assets/images/logo.png';

    if (alcanciaProvider.monedas.isEmpty && alcanciaProvider.billetes.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Estadísticos'),
        ),
        drawer: menuDesplegablePrincipal(logo, context),
        body: const Center(
          child: Text(
            'No hay datos disponibles para mostrar estadísticas.',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Estadísticos'),
      ),
      drawer: menuDesplegablePrincipal(logo, context),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Estadísticos de Ahorros',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _estadisticoItem(
                      'Media',
                      alcanciaProvider.calcularMedia().toStringAsFixed(2),
                    ),
                    const SizedBox(height: 16),
                    _estadisticoItem(
                      'Mediana',
                      alcanciaProvider.calcularMediana().toStringAsFixed(2),
                    ),
                    const SizedBox(height: 16),
                    _estadisticoItem(
                      'Moda',
                      alcanciaProvider.calcularModa().toStringAsFixed(2),
                    ),
                    const SizedBox(height: 16),
                    _estadisticoItem(
                      'Desviación Estándar',
                      alcanciaProvider
                          .calcularDesviacionEstandar()
                          .toStringAsFixed(2),
                    ),
                    const SizedBox(height: 16),
                    _estadisticoItem(
                      'Rango Intercuartil',
                      alcanciaProvider
                          .calcularRangoIntercuartil()
                          .toStringAsFixed(2),
                    ),
                    const SizedBox(height: 16),
                    _estadisticoItem(
                      'Coeficiente de Variación',
                      alcanciaProvider
                          .calcularCoeficienteVariacion()
                          .toStringAsFixed(2),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _estadisticoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
