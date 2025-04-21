// ignore_for_file: use_build_context_synchronously

import 'package:alcancia_movil/Forms/financiamientoForm.dart';
import 'package:alcancia_movil/providers/financiamiento_provider.dart';
import 'package:alcancia_movil/views/home/menuDesplegablePrincipal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class FinanciamientoScreen extends StatefulWidget {
  const FinanciamientoScreen({super.key});

  @override
  State<FinanciamientoScreen> createState() => _FinanciamientoScreenState();
}

class _FinanciamientoScreenState extends State<FinanciamientoScreen> {
  late String userEmail;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userEmail = user.email!;
      Future.microtask(() {
        Provider.of<FinanciamientoProvider>(context, listen: false)
            .fetchFinanciamientos(userEmail);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final financiamientos =
        Provider.of<FinanciamientoProvider>(context).financiamientos;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Financiamiento'),
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline),
            tooltip: '¿Cómo se calcula el financiamiento?',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('¿Cómo funciona el cálculo?'),
                  content: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Tu cuota mensual se calcula con base en la fórmula de amortización de préstamos con cuotas fijas. Esto te dice cuánto debes pagar cada mes para cubrir un préstamo dado, considerando el plazo y la tasa de interés.',
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Ejemplo:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        const Text('• Monto del préstamo: \$21,151'),
                        const Text('• Tasa de interés anual: 12%'),
                        const Text('• Plazo: 24 meses'),
                        const SizedBox(height: 8),
                        const Text(
                            'Con estos valores, pagarías una cuota mensual de aproximadamente \$1,000. Esto te permite saber si tu capacidad de pago es suficiente para cubrir el préstamo y planificar mejor tus finanzas.'),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      child: Text('Entendido'),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      drawer: MenuDesplegable(
          logo: 'lib/assets/images/logo.png',
          user: FirebaseAuth.instance.currentUser),
      body: financiamientos.isEmpty
          ? const Center(child: Text('No hay financiamientos aún.'))
          : ListView.builder(
              itemCount: financiamientos.length,
              itemBuilder: (context, index) {
                final f = financiamientos[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text('Monto: \$${formatCurrency(f.montoPrestamo)}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Tasa Anual: ${f.tasaInteresAnual}%'),
                        Text('Plazo: ${f.plazoEnMeses} meses'),
                        Text(
                            'Cuota mensual: ${formatCurrency(f.cuotaMensual)}'),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        Provider.of<FinanciamientoProvider>(context,
                                listen: false)
                            .deleteFinanciamiento(f.id, userEmail);
                      },
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const FinanciamientoForm()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  String formatCurrency(double value) {
    final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 0);
    return formatter.format(value);
  }
}
