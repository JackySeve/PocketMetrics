import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

import '../providers/alcancia_provider.dart';
import '../views/widgets/menuDesplegablePrincipal.dart';

class Meta {
  String id;
  String nombre;
  int valorObjetivo;
  int valorAhorrado;
  DateTime fechaLimite;
  bool cumplida;

  Meta({
    required this.id,
    required this.nombre,
    required this.valorObjetivo,
    this.valorAhorrado = 0,
    required this.fechaLimite,
    this.cumplida = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'valorObjetivo': valorObjetivo,
      'valorAhorrado': valorAhorrado,
      'fechaLimite': fechaLimite.millisecondsSinceEpoch,
      'cumplida': cumplida,
    };
  }

  factory Meta.fromMap(Map<String, dynamic> map) {
    return Meta(
      id: map['id'] ?? '',
      nombre: map['nombre'] ?? '',
      valorObjetivo: map['valorObjetivo'] ?? 0,
      valorAhorrado: map['valorAhorrado'] ?? 0,
      fechaLimite: map['fechaLimite'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['fechaLimite'])
          : DateTime.now(),
      cumplida: map['cumplida'] ?? false,
    );
  }
}

class Metas extends StatefulWidget {
  const Metas({super.key});

  @override
  _MetasState createState() => _MetasState();
}

class _MetasState extends State<Metas> {
  final _formKey = GlobalKey<FormState>();
  String _nombreMeta = '';
  int _valorObjetivo = 0;
  DateTime _fechaLimite = DateTime.now();
  Meta? _metaEditando;
  final userEmail = FirebaseAuth.instance.currentUser?.email;

  @override
  Widget build(BuildContext context) {
    final alcanciaProvider =
        Provider.of<AlcanciaProvider>(context, listen: true);
    const logo = 'lib/assets/images/logo.png';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis metas'),
        centerTitle: true,
      ),
      drawer: menuDesplegablePrincipal(
        logo,
        context,
        user: FirebaseAuth.instance.currentUser,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: alcanciaProvider.metas.length,
              itemBuilder: (context, index) {
                final meta = alcanciaProvider.metas[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  elevation: 4.0,
                  child: ListTile(
                    title: Text(
                      meta.nombre,
                      style: TextStyle(
                        color: meta.cumplida
                            ? Colors.green
                            : meta.fechaLimite.isBefore(DateTime.now()) &&
                                    meta.valorAhorrado < meta.valorObjetivo
                                ? Colors.red
                                : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'Valor Objetivo: ${formatCurrency(meta.valorObjetivo)}'),
                        Text(
                            'Valor Ahorrado: ${formatCurrency(meta.valorAhorrado)}'),
                        const SizedBox(height: 8.0),
                        LinearProgressIndicator(
                          value: meta.valorAhorrado / meta.valorObjetivo,
                          backgroundColor: Colors.grey[300],
                          valueColor: AlwaysStoppedAnimation<Color>(
                              meta.valorAhorrado / meta.valorObjetivo >= 1
                                  ? Colors.green
                                  : Colors.teal),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          color: Colors.blue,
                          onPressed: () {
                            _mostrarDialogoMeta(meta);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          color: Colors.red,
                          onPressed: () {
                            _mostrarDialogoConfirmacion(
                              context,
                              alcanciaProvider,
                              meta.id,
                            );
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
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                _mostrarDialogoMeta(null);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 18.0),
              ),
              child: const Text(
                'Agregar Meta',
                style: TextStyle(fontSize: 16.0, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _mostrarDialogoMeta(Meta? meta) {
    _metaEditando = meta;
    _nombreMeta = meta?.nombre ?? '';
    _valorObjetivo = meta?.valorObjetivo ?? 0;
    _fechaLimite = meta?.fechaLimite ?? DateTime.now();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(meta == null ? 'Agregar Meta' : 'Editar Meta'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: _nombreMeta,
                  decoration: const InputDecoration(
                    labelText: 'Nombre de la meta',
                    border: OutlineInputBorder(),
                  ),
                  onSaved: (value) {
                    _nombreMeta = value!;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  initialValue: _valorObjetivo.toString(),
                  decoration: const InputDecoration(
                    labelText: 'Valor Objetivo',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [ThousandsSeparatorInputFormatter()],
                  onSaved: (value) {
                    _valorObjetivo =
                        int.tryParse(value!.replaceAll(RegExp(r'[,.]'), '')) ??
                            0;
                  },
                  validator: (value) {
                    final parsedValue =
                        int.tryParse(value!.replaceAll(RegExp(r'[,.]'), ''));
                    if (parsedValue == null || parsedValue <= 0) {
                      return 'El valor objetivo debe ser mayor a cero';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    _seleccionarFechaLimite(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Fecha Límite: ${_fechaLimite.toString().split(' ')[0]}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  final alcanciaProvider =
                      Provider.of<AlcanciaProvider>(context, listen: false);
                  if (_metaEditando == null) {
                    final meta = Meta(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      nombre: _nombreMeta,
                      valorObjetivo: _valorObjetivo,
                      fechaLimite: _fechaLimite,
                    );
                    alcanciaProvider.agregarMeta(meta);
                    if (userEmail != null) {
                      alcanciaProvider.guardarMetasEnFirebase(
                          alcanciaProvider.metas, userEmail!);
                    }
                  } else {
                    _metaEditando!.nombre = _nombreMeta;
                    _metaEditando!.valorObjetivo = _valorObjetivo;
                    _metaEditando!.fechaLimite = _fechaLimite;
                    alcanciaProvider.editarMeta(_metaEditando!);
                    if (userEmail != null) {
                      alcanciaProvider.guardarMetasEnFirebase(
                          alcanciaProvider.metas, userEmail!);
                    }
                  }
                  Navigator.of(context).pop();
                }
              },
              child: Text(meta == null ? 'Agregar' : 'Guardar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _seleccionarFechaLimite(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime initialDate =
        _fechaLimite.isBefore(now) ? now : _fechaLimite;
    final DateTime? fechaSeleccionada = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (fechaSeleccionada != null) {
      setState(() {
        _fechaLimite = fechaSeleccionada;
      });
    }
  }

  String formatCurrency(int value) {
    final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 0);
    return formatter.format(value);
  }

  void _mostrarDialogoConfirmacion(
      BuildContext context, AlcanciaProvider alcanciaProvider, String metaId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmación'),
          content:
              const Text('¿Estás seguro de que quieres eliminar esta meta?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                alcanciaProvider.eliminarMeta(metaId);
                if (userEmail != null) {
                  alcanciaProvider.eliminarMetaEnFirebase(metaId, userEmail!);
                }
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }
}

class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final int selectionIndexFromTheRight =
        newValue.text.length - newValue.selection.end;
    final number = int.tryParse(newValue.text.replaceAll(RegExp(r'[,.]'), ''));
    if (number == null) return newValue;

    final newString = NumberFormat.decimalPattern().format(number);
    return TextEditingValue(
      text: newString,
      selection: TextSelection.collapsed(
          offset: newString.length - selectionIndexFromTheRight),
    );
  }
}
