import 'package:alcancia_movil/providers/alcancia_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../home/menuDesplegablePrincipal.dart';

class Historial extends StatefulWidget {
  const Historial({super.key});

  @override
  _HistorialState createState() => _HistorialState();
}

class _HistorialState extends State<Historial> {
  final int _itemsPerPage = 10;
  int _currentMax = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial'),
      ),
      drawer: MenuDesplegable(
        logo: 'lib/assets/images/logo.png',
        user: FirebaseAuth.instance.currentUser,
      ),
      body: Consumer<AlcanciaProvider>(
        builder: (context, alcanciaProvider, child) {
          final transaccionesOrdenadas =
              List.from(alcanciaProvider.transacciones)
                ..sort((a, b) => b.fecha.compareTo(a.fecha));

          final visibleTransactions =
              transaccionesOrdenadas.take(_currentMax).toList();

          return ListView.builder(
            itemCount: visibleTransactions.length + 1,
            itemBuilder: (context, index) {
              if (index == visibleTransactions.length) {
                return (visibleTransactions.length <
                        transaccionesOrdenadas.length)
                    ? TextButton(
                        onPressed: () {
                          setState(() {
                            _currentMax += _itemsPerPage;
                          });
                        },
                        child: const Text('Cargar más'),
                      )
                    : const SizedBox.shrink();
              }

              final transaccion = visibleTransactions[index];
              return ListTile(
                title: Text(
                  '${transaccion.esIngreso ? 'Ingreso' : 'Egreso'}: ${formatCurrency(transaccion.monto)}',
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

  String formatCurrency(double amount) {
    final format = NumberFormat.currency(locale: 'es_CO', symbol: '\$');
    return format.format(amount);
  }
}
