// ignore_for_file: file_names

import 'package:alcancia_movil/providers/bank_savings_provider.dart';
import 'package:alcancia_movil/Forms/ahorroBancoForm.dart';
import 'package:alcancia_movil/views/home/menuDesplegablePrincipal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class BankSavingsScreen extends StatefulWidget {
  const BankSavingsScreen({super.key});

  @override
  State<BankSavingsScreen> createState() => _BankSavingsScreenState();
}

class _BankSavingsScreenState extends State<BankSavingsScreen> {
  String? _selectedFilter;
  final userEmail = FirebaseAuth.instance.currentUser?.email ?? '';

  @override
  void initState() {
    super.initState();
    final email = FirebaseAuth.instance.currentUser?.email;
    if (email != null) {
      Provider.of<BankSavingsProvider>(context, listen: false)
          .fetchSavings(email);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BankSavingsProvider>(context);
    final filteredList = _selectedFilter == null
        ? provider.savings
        : provider.filterByAccountType(_selectedFilter!);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ahorros en Banco'),
        actions: [
          DropdownButton<String>(
            value: _selectedFilter,
            hint: const Text('Filtrar'),
            onChanged: (value) {
              setState(() {
                _selectedFilter = value;
              });
            },
            items: const [
              DropdownMenuItem(value: 'Ahorros', child: Text('Ahorros')),
              DropdownMenuItem(value: 'Corriente', child: Text('Corriente')),
              DropdownMenuItem(value: null, child: Text('Todos')),
            ],
          ),
        ],
      ),
      drawer: MenuDesplegable(
          logo: 'lib/assets/images/logo.png',
          user: FirebaseAuth.instance.currentUser),
      body: filteredList.isEmpty
          ? const Center(child: Text('No hay ahorros registrados.'))
          : ListView.builder(
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                final saving = filteredList[index];
                final userEmail =
                    FirebaseAuth.instance.currentUser?.email ?? '';
                final nombreMes = obtenerNombreMes(saving.lastUpdated.month);

                return Dismissible(
                  key: Key(saving.id),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (_) async {
                    return await showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Confirmar eliminación'),
                        content: const Text(
                            '¿Estás seguro de que deseas eliminar este ahorro?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text('Cancelar'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text('Eliminar'),
                          ),
                        ],
                      ),
                    );
                  },
                  onDismissed: (_) {
                    Provider.of<BankSavingsProvider>(context, listen: false)
                        .deleteSaving(saving.id, userEmail);
                  },
                  child: ListTile(
                    title: Text(saving.bankName),
                    subtitle: Text(
                        '${saving.accountType} - \$${formatCurrency(saving.amount)}'),
                    trailing: Text(
                        '${saving.lastUpdated.day} de $nombreMes de ${saving.lastUpdated.year}'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BankSavingForm(
                            editSaving: saving,
                            userEmail: userEmail,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BankSavingForm(userEmail: userEmail),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  String formatCurrency(double value) {
    final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 0);
    return formatter.format(value);
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
