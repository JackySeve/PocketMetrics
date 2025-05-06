// ignore_for_file: library_private_types_in_public_api

import 'package:alcancia_movil/models/gastos_model.dart';
import 'package:alcancia_movil/providers/gastos_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../home/menuDesplegablePrincipal.dart';
import 'package:flutter/services.dart';

class PantallaGastos extends StatefulWidget {
  const PantallaGastos({super.key});

  @override
  _PantallaGastosState createState() => _PantallaGastosState();
}

class _PantallaGastosState extends State<PantallaGastos> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _valorController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // FormKey
  DateTime _fechaSeleccionada = DateTime.now();

  @override
  void initState() {
    super.initState();
    final userEmail = FirebaseAuth.instance.currentUser?.email;
    if (userEmail != null) {
      Provider.of<GastosProvider>(context, listen: false)
          .cargarGastos(userEmail);
    }
  }

  @override
  Widget build(BuildContext context) {
    final gastosProvider = Provider.of<GastosProvider>(context);
    final userEmail = FirebaseAuth.instance.currentUser?.email;

    return Scaffold(
      appBar: AppBar(title: const Text('Gastos')),
      drawer: MenuDesplegable(
        logo: 'lib/assets/images/logo.png',
        user: FirebaseAuth.instance.currentUser,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: gastosProvider.gastos.length,
              itemBuilder: (context, index) {
                final gasto = gastosProvider.gastos[index];
                final nombreMes = obtenerNombreMes(gasto.fecha.month);
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(gasto.nombre,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Descripción: ${gasto.descripcion}'),
                        Text(
                            'Fecha: ${gasto.fecha.day} de $nombreMes de ${gasto.fecha.year}'),
                        Text('Valor: ${formatCurrency(gasto.valor)}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.green),
                          onPressed: () => _mostrarDialogoGasto(
                              context, gastosProvider, userEmail, gasto),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            if (userEmail != null) {
                              gastosProvider.eliminarGasto(
                                  gasto.id, userEmail, context);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom + 16.0),
            child: ElevatedButton(
              onPressed: () => _mostrarDialogoGasto(
                  context, gastosProvider, userEmail, null),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 5,
              ),
              child: const Text('Agregar Gasto'),
            ),
          ),
        ],
      ),
    );
  }

  void _mostrarDialogoGasto(BuildContext context, GastosProvider gastosProvider,
      String? userEmail, Gasto? gastoEditando) {
    if (gastoEditando != null) {
      _nombreController.text = gastoEditando.nombre;
      _descripcionController.text = gastoEditando.descripcion;
      _valorController.text = gastoEditando.valor.toString();
      _fechaSeleccionada = gastoEditando.fecha;
    } else {
      _nombreController.clear();
      _descripcionController.clear();
      _valorController.clear();
      _fechaSeleccionada = DateTime.now();
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(gastoEditando == null ? 'Agregar Gasto' : 'Editar Gasto'),
          content: Form(
            // Se envuelve el contenido en un Form
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nombreController,
                  decoration: const InputDecoration(labelText: 'Nombre'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El nombre es obligatorio';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _descripcionController,
                  decoration: const InputDecoration(labelText: 'Descripción'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'La descripción es obligatoria';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _valorController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Valor'),
                  inputFormatters: [ThousandsSeparatorInputFormatter()],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El valor es obligatorio';
                    }

                    final parsedValue =
                        int.tryParse(value.replaceAll(RegExp(r'[,.]'), ''));
                    if (parsedValue == null || parsedValue <= 0) {
                      return 'Debe ser un número mayor a cero';
                    }
                    return null;
                  },
                ),
                GestureDetector(
                  onTap: () async {
                    DateTime? fechaSeleccionada = await showDatePicker(
                      context: context,
                      initialDate: _fechaSeleccionada,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (fechaSeleccionada != null) {
                      setState(() => _fechaSeleccionada = fechaSeleccionada);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        'Fecha: ${DateFormat('dd/MM/yyyy').format(_fechaSeleccionada)}'),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child:
                  const Text('Cancelar', style: TextStyle(color: Colors.white)),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  final nuevoGasto = Gasto(
                    id: gastoEditando?.id ??
                        DateTime.now().millisecondsSinceEpoch.toString(),
                    nombre: _nombreController.text,
                    descripcion: _descripcionController.text,
                    fecha: _fechaSeleccionada,
                    valor: int.parse(
                        _valorController.text.replaceAll(RegExp(r'[,.]'), '')),
                  );

                  if (gastoEditando == null) {
                    gastosProvider.agregarGasto(nuevoGasto, userEmail!);
                  } else {
                    gastosProvider.editarGasto(nuevoGasto, userEmail!);
                  }

                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child:
                  const Text('Guardar', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

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

    return (numeroMes >= 1 && numeroMes <= 12)
        ? meses[numeroMes - 1]
        : 'Mes inválido';
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
