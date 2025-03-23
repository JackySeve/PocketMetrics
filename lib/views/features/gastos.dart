import 'package:alcancia_movil/models/gastos_model.dart';
import 'package:alcancia_movil/providers/gastos_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../home/menuDesplegablePrincipal.dart';

class PantallaGastos extends StatefulWidget {
  const PantallaGastos({super.key});

  @override
  _PantallaGastosState createState() => _PantallaGastosState();
}

class _PantallaGastosState extends State<PantallaGastos> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _valorController = TextEditingController();
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
                            'Fecha: ${DateFormat('dd/MM/yyyy').format(gasto.fecha)}'),
                        Text(
                            'Valor: ${NumberFormat.currency(symbol: '\$', decimalDigits: 0).format(gasto.valor)}'),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        if (userEmail != null) {
                          gastosProvider.eliminarGasto(gasto.id, userEmail);
                        }
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () =>
                  _mostrarDialogoGasto(context, gastosProvider, userEmail),
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

  void _mostrarDialogoGasto(
      BuildContext context, GastosProvider gastosProvider, String? userEmail) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Agregar Gasto'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),
              TextField(
                controller: _descripcionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
              ),
              TextField(
                controller: _valorController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Valor'),
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
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  elevation: 5,
                ),
                child: const Text('Cancelar')),
            ElevatedButton(
              onPressed: () {
                if (_nombreController.text.isNotEmpty &&
                    _descripcionController.text.isNotEmpty &&
                    _valorController.text.isNotEmpty &&
                    userEmail != null) {
                  final nuevoGasto = Gasto(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    nombre: _nombreController.text,
                    descripcion: _descripcionController.text,
                    fecha: _fechaSeleccionada,
                    valor: int.parse(_valorController.text),
                  );

                  gastosProvider.agregarGasto(nuevoGasto, userEmail);
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 5,
              ),
              child: const Text(
                'Guardar',
              ),
            ),
          ],
        );
      },
    );
  }
}
