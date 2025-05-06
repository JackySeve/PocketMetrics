// ignore_for_file: library_private_types_in_public_api

import 'package:alcancia_movil/Models/divisa_model.dart';
import 'package:alcancia_movil/providers/divisas_provider.dart';
import 'package:alcancia_movil/services/nivel_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  late final XPService xpService;

  @override
  void initState() {
    super.initState();
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) xpService = XPService(userId: uid);
  }

  @override
  Widget build(BuildContext context) {
    final userEmail = FirebaseAuth.instance.currentUser?.email;
    final divisasProvider = Provider.of<DivisasProvider>(context);

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
          ? Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: divisasProvider.divisas.length,
                  itemBuilder: (context, index) {
                    final divisa = divisasProvider.divisas[index];
                    return ListTile(
                      title: Text(divisa.nombre),
                      subtitle:
                          Text('Cantidad: ${formatCurrency(divisa.cantidad)}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Botón único de editar cantidad:
                          IconButton(
                            icon: Icon(Icons.attach_money, color: Colors.green),
                            tooltip: 'Editar cantidad',
                            onPressed: () => _mostrarDialogoModificarCantidad(
                              context,
                              divisasProvider,
                              index,
                              userEmail!,
                              null, // le pasamos null para indicar edición “completa”
                            ),
                          ),
                          // Y el botón de eliminar:
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            tooltip: 'Eliminar divisa',
                            onPressed: () => _mostrarDialogoEliminarDivisa(
                              context,
                              divisasProvider,
                              index,
                              userEmail!,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                ElevatedButton(
                  onPressed: () => _mostrarDialogoAgregarDivisa(
                      context, divisasProvider, userEmail!),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 5,
                  ),
                  child: const Text(
                    'Agregar Divisa',
                    style: TextStyle(fontSize: 16.0, color: Colors.white),
                  ),
                ),
              ],
            )
          : _buildMainContent(context, userEmail),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  void _mostrarDialogoEliminarDivisa(BuildContext context,
      DivisasProvider provider, int index, String userEmail) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Eliminar Divisa'),
        content: Text('¿Estás seguro de que deseas eliminar esta divisa?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              provider.eliminarDivisa(index, userEmail);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Eliminar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _mostrarDialogoModificarCantidad(BuildContext context,
      DivisasProvider provider, int index, String userEmail, bool? isAddition) {
    final cantidadController = TextEditingController(
      text: provider.divisas[index].cantidad.toString(),
    );

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Editar Cantidad'),
        content: TextField(
          controller: cantidadController,
          decoration: InputDecoration(labelText: 'Cantidad'),
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              final nuevaCantidad = int.tryParse(cantidadController.text) ?? 0;
              if (nuevaCantidad > 0) {
                if (isAddition == true) {
                  // Sigue usando tu método existente para suma
                  provider.actualizarCantidadDivisa(
                      index, true, userEmail, nuevaCantidad);
                } else if (isAddition == false) {
                  // ...y para resta
                  provider.actualizarCantidadDivisa(
                      index, false, userEmail, nuevaCantidad);
                } else {
                  // Modo edición completa: llamamos al nuevo método
                  provider.editarCantidadDivisa(
                      index, nuevaCantidad, userEmail);
                }
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Ingresa una cantidad válida.')),
                );
              }
            },
            child: Text('Guardar'),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(BuildContext context, String? userEmail) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildSectionTitle(_sections[_selectedIndex]),
          const SizedBox(height: 10),
          _buildTableHeader(),
          Expanded(
            child: Consumer2<AlcanciaProvider, DivisasProvider>(
              builder: (context, alcanciaProvider, divisasProvider, child) {
                return ListView.builder(
                  itemCount: _getItemCount(alcanciaProvider, divisasProvider),
                  itemBuilder: (context, index) {
                    final item =
                        _getItem(alcanciaProvider, divisasProvider, index);
                    return _buildMoneyRow(
                      value: item.valor,
                      quantity: item.cantidad,
                      total: item.valor * item.cantidad,
                      onAdd: () {
                        if (_selectedIndex == 2) {
                          _mostrarDialogoModificarCantidad(
                            context,
                            divisasProvider,
                            index,
                            userEmail!,
                            true,
                          );
                        } else {
                          _addTransaction(alcanciaProvider, divisasProvider,
                              item.valor.toDouble(), true, userEmail!, index);
                        }
                      },
                      onRemove: () {
                        if (_selectedIndex == 2) {
                          _mostrarDialogoModificarCantidad(
                            context,
                            divisasProvider,
                            index,
                            userEmail!,
                            false,
                          );
                        } else if (item.cantidad > 0) {
                          _addTransaction(alcanciaProvider, divisasProvider,
                              item.valor.toDouble(), false, userEmail!, index);
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
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
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
          icon: Icon(Icons.monetization_on),
          label: 'Monedas',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.attach_money),
          label: 'Billetes',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_balance),
          label: 'Otras Divisas',
        ),
      ],
    );
  }

  Future<void> _addTransaction(
      AlcanciaProvider alcanciaProvider,
      DivisasProvider divisasProvider,
      double amount,
      bool isAddition,
      String userEmail,
      int index) async {
    if (_selectedIndex == 0) {
      alcanciaProvider.actualizarCantidadMoneda(
          index,
          isAddition
              ? alcanciaProvider.monedas[index].cantidad + 1
              : alcanciaProvider.monedas[index].cantidad - 1,
          userEmail);
    } else if (_selectedIndex == 1) {
      alcanciaProvider.actualizarCantidadBillete(
          index,
          isAddition
              ? alcanciaProvider.billetes[index].cantidad + 1
              : alcanciaProvider.billetes[index].cantidad - 1,
          userEmail);
    }
    // Guarda los datos actualizados en Firebase (si corresponde)
    alcanciaProvider.guardarDatosEnFirebase(
        alcanciaProvider.monedas,
        alcanciaProvider.billetes,
        alcanciaProvider.totalAhorrado.toDouble(),
        userEmail);

    if (isAddition == true && _selectedIndex != 2) {
      Provider.of<AlcanciaProvider>(context, listen: false)
          .agregarTransaccion(amount, true, userEmail);

      try {
        final dinero = <int, int>{};
        final int valor = amount.toInt();
        dinero[valor] = 1;

        await xpService.registrarAhorro(dinero);
      } catch (e) {
        debugPrint('Error actualizando XP: $e');
      }
    }

    setState(() {});
  }

  int _getItemCount(
      AlcanciaProvider alcanciaProvider, DivisasProvider divisasProvider) {
    if (_selectedIndex == 0) return alcanciaProvider.monedas.length;
    if (_selectedIndex == 1) return alcanciaProvider.billetes.length;
    return divisasProvider.divisas.length;
  }

  dynamic _getItem(AlcanciaProvider alcanciaProvider,
      DivisasProvider divisasProvider, int index) {
    if (_selectedIndex == 0) return alcanciaProvider.monedas[index];
    if (_selectedIndex == 1) return alcanciaProvider.billetes[index];
    return divisasProvider.divisas[index];
  }

  int _getTotal(AlcanciaProvider alcanciaProvider) {
    if (_selectedIndex == 0) return alcanciaProvider.totalAhorradoMonedas;
    if (_selectedIndex == 1) return alcanciaProvider.totalAhorradoBilletes;
    return 0;
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
          Text(formatCurrency(value)),
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
          Text(formatCurrency(total)),
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
      '$label ${formatCurrency(amount)}',
      style: TextStyle(
        color: Colors.green,
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        fontSize: fontSize,
      ),
    );
  }

  String formatCurrency(num amount) {
    final format =
        NumberFormat.currency(locale: 'es_CO', symbol: '\$', decimalDigits: 0);
    return format.format(amount);
  }

  void _mostrarDialogoAgregarDivisa(
      BuildContext context, DivisasProvider provider, String userEmail) {
    TextEditingController nombreController = TextEditingController();
    TextEditingController cantidadController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Agregar Divisa'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nombreController,
              decoration: InputDecoration(labelText: 'Nombre de la Divisa'),
            ),
            TextField(
              controller: cantidadController,
              decoration: InputDecoration(labelText: 'Cantidad'),
              keyboardType: TextInputType.number,
              inputFormatters: [ThousandsSeparatorInputFormatter()],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              final nombre = nombreController.text;
              final cantidad = int.tryParse(cantidadController.text
                      .replaceAll(RegExp(r'[,.]'), '')) ??
                  0;

              if (nombre.isNotEmpty && cantidad > 0) {
                // Agregar la divisa solo si la cantidad es válida
                provider.agregarDivisa(
                  DivisaModel(nombre: nombre, valor: 1, cantidad: cantidad),
                  userEmail,
                );
                Navigator.pop(context);
              } else {
                // Mostrar un mensaje si la cantidad no es válida
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('Por favor, ingresa una cantidad válida.')),
                );
              }
            },
            child: Text('Guardar'),
          ),
        ],
      ),
    );
  }
}

class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final int selectionIndexFromTheRight =
        newValue.text.length - newValue.selection.end;

    final number = int.tryParse(newValue.text.replaceAll(RegExp(r'[.,]'), ''));
    if (number == null) return newValue;

    final newString = NumberFormat.decimalPattern('es_CO').format(number);

    return TextEditingValue(
      text: newString,
      selection: TextSelection.collapsed(
          offset: newString.length - selectionIndexFromTheRight),
    );
  }
}
