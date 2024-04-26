import 'package:alcancia_movil/providers/alcancia_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'widgets/menuDesplegablePrincipal.dart';

class Historial extends StatelessWidget {
  const Historial({super.key});

  @override
  Widget build(BuildContext context) {
    const logo = 'lib/assets/images/logo.png';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial'),
      ),
      drawer: menuDesplegablePrincipal(logo, context),
      body: Consumer<AlcanciaProvider>(
        builder: (context, alcanciaProvider, child) {
          return ListView.builder(
            itemCount: alcanciaProvider.transacciones.length,
            itemBuilder: (context, index) {
              final transaccion = alcanciaProvider.transacciones[index];
              return ListTile(
                title: Text(
                  '${transaccion.esIngreso ? 'Ingreso' : 'Egreso'}: ${transaccion.monto}',
                  style: TextStyle(
                    color: transaccion.esIngreso ? Colors.green : Colors.red,
                  ),
                ),
                subtitle: Text(
                  transaccion.fecha.toString(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
