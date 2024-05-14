import 'package:alcancia_movil/providers/alcancia_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'widgets/menuDesplegablePrincipal.dart';

class Historial extends StatelessWidget {
  const Historial({super.key});

  @override
  Widget build(BuildContext context) {
    const logo = 'lib/assets/images/logo.png';

    // Get the AlcanciaProvider instance
    final alcanciaProvider =
        Provider.of<AlcanciaProvider>(context, listen: false);

    final transaccionesOrdenadas = alcanciaProvider.transacciones
      ..sort((a, b) {
        return b.fecha.compareTo(a.fecha);
      });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial'),
      ),
      drawer: menuDesplegablePrincipal(
        logo,
        context,
        user: FirebaseAuth.instance.currentUser,
      ),
      body: Consumer<AlcanciaProvider>(
        builder: (context, alcanciaProvider, child) {
          return ListView.builder(
            itemCount: transaccionesOrdenadas.length,
            itemBuilder: (context, index) {
              final transaccion = transaccionesOrdenadas[index];
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
