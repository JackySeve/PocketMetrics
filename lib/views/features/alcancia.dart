import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../../providers/alcancia_provider.dart';
import '../home/menuDesplegablePrincipal.dart';

class Alcancia extends StatefulWidget {
  const Alcancia({super.key});

  @override
  _AlcanciaState createState() => _AlcanciaState();
}

class _AlcanciaState extends State<Alcancia> {
  int _selectedIndex = 0;

  final List<String> _sections = ['Monedas', 'Billetes', 'Otras Divisas'];

  @override
  Widget build(BuildContext context) {
    final userEmail = FirebaseAuth.instance.currentUser?.email;

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Alcancía'),
        ),
        drawer: MenuDesplegable(
          logo: 'lib/assets/images/logo.png',
          user: FirebaseAuth.instance.currentUser,
        ),
        body: _selectedIndex == 2
            ? Center(
                child: Text('Próximamente',
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)))
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildSectionTitle(_sections[_selectedIndex]),
                    const SizedBox(height: 10),
                    _buildTableHeader(),
                    Expanded(
                      child: Consumer<AlcanciaProvider>(
                        builder: (context, alcanciaProvider, child) {
                          return ListView.builder(
                            itemCount: _getItemCount(alcanciaProvider),
                            itemBuilder: (context, index) {
                              final item = _getItem(alcanciaProvider, index);
                              return _buildMoneyRow(
                                value: item.valor,
                                quantity: item.cantidad,
                                total: item.valor * item.cantidad,
                                onAdd: () {
                                  _addTransaction(
                                      alcanciaProvider,
                                      item.valor.toDouble(),
                                      true,
                                      userEmail!,
                                      index);
                                },
                                onRemove: () {
                                  if (item.cantidad > 0) {
                                    _addTransaction(
                                        alcanciaProvider,
                                        item.valor.toDouble(),
                                        false,
                                        userEmail!,
                                        index);
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
                          'Total Ahorrado (${_sections[_selectedIndex]}):',
                          _getTotal(alcanciaProvider),
                        );
                      },
                    ),
                  ],
                ),
              ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          selectedItemColor: Colors.green, // Color para el ítem seleccionado
          unselectedItemColor: Colors.grey, // Color para los no seleccionados
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.monetization_on),
              label: 'Monedas',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.attach_money),
              label: 'Billetes',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.currency_exchange),
              label: 'Otras Divisas',
            ),
          ],
        ));
  }

  void _addTransaction(AlcanciaProvider provider, double amount,
      bool isAddition, String userEmail, int index) {
    provider.agregarTransaccion(amount, isAddition, userEmail);
    if (_selectedIndex == 0) {
      provider.actualizarCantidadMoneda(
          index,
          isAddition
              ? provider.monedas[index].cantidad + 1
              : provider.monedas[index].cantidad - 1,
          userEmail);
    } else if (_selectedIndex == 1) {
      provider.actualizarCantidadBillete(
          index,
          isAddition
              ? provider.billetes[index].cantidad + 1
              : provider.billetes[index].cantidad - 1,
          userEmail);
    }
    provider.guardarDatosEnFirebase(provider.monedas, provider.billetes,
        provider.totalAhorrado.toDouble(), userEmail);
  }

  int _getItemCount(AlcanciaProvider provider) {
    if (_selectedIndex == 0) return provider.monedas.length;
    return provider.billetes.length;
  }

  dynamic _getItem(AlcanciaProvider provider, int index) {
    if (_selectedIndex == 0) return provider.monedas[index];
    return provider.billetes[index];
  }

  int _getTotal(AlcanciaProvider provider) {
    if (_selectedIndex == 0) return provider.totalAhorradoMonedas;
    return provider.totalAhorradoBilletes;
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.green,
      ),
    );
  }

  Widget _buildTableHeader() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text('Valor',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Text('Cantidad',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Text('Total',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildMoneyRow(
      {required int value,
      required int quantity,
      required int total,
      required VoidCallback onAdd,
      required VoidCallback onRemove}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text('\$${formatCurrency(value)}'),
          Row(
            children: [
              IconButton(
                  icon: const Icon(Icons.remove),
                  color: Colors.red,
                  onPressed: onRemove),
              Text("$quantity"),
              IconButton(
                  icon: const Icon(Icons.add),
                  color: Colors.green,
                  onPressed: onAdd),
            ],
          ),
          Text("\$${formatCurrency(total)}"),
        ],
      ),
    );
  }

  Widget _buildTotalText(
    String label,
    int amount, {
    bool isBold = true,
    double fontSize = 18,
  }) {
    return Text(
      '$label \$ ${formatCurrency(amount)}',
      style: TextStyle(
        color: Colors.green,
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
