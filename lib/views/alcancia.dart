import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart'; // Importa el paquete intl

import '../providers/alcancia_provider.dart';
import 'widgets/menuDesplegablePrincipal.dart';

class Alcancia extends StatelessWidget {
  const Alcancia({super.key});

  @override
  Widget build(BuildContext context) {
    const logo = 'lib/assets/images/logo.png';
    final userEmail = FirebaseAuth.instance.currentUser?.email;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Alcancía'),
      ),
      drawer: menuDesplegablePrincipal(
        logo,
        context,
        user: FirebaseAuth.instance.currentUser,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSectionTitle('Monedas:'),
            const SizedBox(height: 10),
            _buildTableHeader(),
            Expanded(
              child: Consumer<AlcanciaProvider>(
                builder: (context, alcanciaProvider, child) {
                  return ListView.builder(
                    itemCount: alcanciaProvider.monedas.length,
                    itemBuilder: (context, index) {
                      final moneda = alcanciaProvider.monedas[index];
                      return _buildMoneyRow(
                        context,
                        value: moneda.valor,
                        quantity: moneda.cantidad,
                        total: moneda.valor * moneda.cantidad,
                        onAdd: () {
                          _addTransaction(
                            alcanciaProvider,
                            moneda.valor.toDouble(),
                            true,
                            userEmail!,
                            index,
                            true,
                          );
                        },
                        onRemove: () {
                          if (moneda.cantidad > 0) {
                            _addTransaction(
                              alcanciaProvider,
                              moneda.valor.toDouble(),
                              false,
                              userEmail!,
                              index,
                              true,
                            );
                          }
                        },
                      );
                    },
                  );
                },
              ),
            ),
            Consumer<AlcanciaProvider>(
              builder: (context, alcanciaProvider, child) {
                return _buildTotalText(
                  'Total Ahorrado (Monedas):',
                  alcanciaProvider.totalAhorradoMonedas,
                );
              },
            ),
            const SizedBox(height: 20),
            _buildSectionTitle('Billetes:'),
            const SizedBox(height: 10),
            _buildTableHeader(),
            Expanded(
              child: Consumer<AlcanciaProvider>(
                builder: (context, alcanciaProvider, child) {
                  return ListView.builder(
                    itemCount: alcanciaProvider.billetes.length,
                    itemBuilder: (context, index) {
                      final billete = alcanciaProvider.billetes[index];
                      return _buildMoneyRow(
                        context,
                        value: billete.valor,
                        quantity: billete.cantidad,
                        total: billete.valor * billete.cantidad,
                        onAdd: () {
                          _addTransaction(
                            alcanciaProvider,
                            billete.valor.toDouble(),
                            true,
                            userEmail!,
                            index,
                            false,
                          );
                        },
                        onRemove: () {
                          if (billete.cantidad > 0) {
                            _addTransaction(
                              alcanciaProvider,
                              billete.valor.toDouble(),
                              false,
                              userEmail!,
                              index,
                              false,
                            );
                          }
                        },
                      );
                    },
                  );
                },
              ),
            ),
            Consumer<AlcanciaProvider>(
              builder: (context, alcanciaProvider, child) {
                return _buildTotalText(
                  'Total Ahorrado (Billetes):',
                  alcanciaProvider.totalAhorradoBilletes,
                );
              },
            ),
            const SizedBox(height: 20),
            Consumer<AlcanciaProvider>(
              builder: (context, alcanciaProvider, child) {
                return _buildTotalText(
                  'Total Ahorrado:',
                  alcanciaProvider.totalAhorrado,
                  isBold: true,
                  fontSize: 18,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _addTransaction(
    AlcanciaProvider provider,
    double amount,
    bool isAddition,
    String userEmail,
    int index,
    bool isCoin,
  ) {
    provider.agregarTransaccion(amount, isAddition, userEmail);
    if (isCoin) {
      provider.actualizarCantidadMoneda(
          index,
          isAddition
              ? provider.monedas[index].cantidad + 1
              : provider.monedas[index].cantidad - 1,
          userEmail);
    } else {
      provider.actualizarCantidadBillete(
          index,
          isAddition
              ? provider.billetes[index].cantidad + 1
              : provider.billetes[index].cantidad - 1,
          userEmail);
    }
    provider.guardarDatosEnFirebase(
      provider.monedas,
      provider.billetes,
      provider.totalAhorrado.toDouble(),
      userEmail,
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.teal,
      ),
    );
  }

  Widget _buildTableHeader() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text('Valor', style: TextStyle(fontWeight: FontWeight.bold)),
        Text('Cantidad', style: TextStyle(fontWeight: FontWeight.bold)),
        Text('Total', style: TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildMoneyRow(
    BuildContext context, {
    required int value,
    required int quantity,
    required int total,
    required VoidCallback onAdd,
    required VoidCallback onRemove,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text('${formatCurrency(value)}'),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.add),
                color: Colors.green,
                onPressed: onAdd,
              ),
              Text("$quantity"),
              IconButton(
                icon: const Icon(Icons.remove),
                color: Colors.red,
                onPressed: onRemove,
              ),
            ],
          ),
          Text("\$ ${formatCurrency(total)}"),
        ],
      ),
    );
  }

  Widget _buildTotalText(
    String label,
    int amount, {
    bool isBold = false,
    double fontSize = 16,
  }) {
    return Text(
      '$label \$ ${formatCurrency(amount)}',
      style: TextStyle(
        color: Colors.teal,
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        fontSize: fontSize,
      ),
    );
  }

  String formatCurrency(int amount) {
    final formatter = NumberFormat('#,###', 'es_ES');
    return formatter.format(amount);
  }
}
