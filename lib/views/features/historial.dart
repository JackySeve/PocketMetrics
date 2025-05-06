// ignore_for_file: library_private_types_in_public_api

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
        actions: [
          // Ícono de la papelera en la parte superior derecha
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => _confirmarBorrarHistorial(
                Provider.of<AlcanciaProvider>(context, listen: false)),
          ),
        ],
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

          return Column(
            children: [
              // Listado de transacciones
              Expanded(
                child: ListView.builder(
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
                          color:
                              transaccion.esIngreso ? Colors.green : Colors.red,
                        ),
                      ),
                      subtitle: Text(
                        '${transaccion.fecha.day} de ${obtenerNombreMes(transaccion.fecha.month)} de ${transaccion.fecha.year} a las ${transaccion.fecha.hour}:${transaccion.fecha.minute}',
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Método para borrar el historial
  void _confirmarBorrarHistorial(AlcanciaProvider alcanciaProvider) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmar'),
          content: const Text(
              '¿Estás seguro de que quieres borrar todo el historial de transacciones?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                alcanciaProvider
                    .borrarHistorial(); // Llamamos el método de borrar historial
                Navigator.of(context).pop();
              },
              child: const Text('Borrar'),
            ),
          ],
        );
      },
    );
  }

  // Método para formatear la moneda
  String formatCurrency(num amount) {
    final format =
        NumberFormat.currency(locale: 'es_CO', symbol: '\$', decimalDigits: 0);
    return format.format(amount);
  }

  String obtenerNombreMes(int numeroMes) {
    const meses = [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre'
    ];

    if (numeroMes >= 1 && numeroMes <= 12) {
      return meses[numeroMes - 1];
    } else {
      return 'Mes inválido';
    }
  }
}
