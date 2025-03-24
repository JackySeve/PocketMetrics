// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

import '../../providers/alcancia_provider.dart';
import '../home/menuDesplegablePrincipal.dart';

enum CategoriaMeta {
  Viaje,
  Educacion,
  Vivienda,
  Inversion,
  Ahorro,
  Otro,
}

class Meta {
  String id;
  String nombre;
  int valorObjetivo;
  int valorAhorrado;
  String detalle;
  DateTime fechaLimite;
  bool cumplida;
  CategoriaMeta categoria;

  Meta({
    required this.id,
    required this.nombre,
    required this.valorObjetivo,
    this.valorAhorrado = 0,
    required this.fechaLimite,
    this.cumplida = false,
    required this.detalle,
    required this.categoria,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'valorObjetivo': valorObjetivo,
      'valorAhorrado': valorAhorrado,
      'fechaLimite': fechaLimite.millisecondsSinceEpoch,
      'cumplida': cumplida,
      'detalle': detalle,
      'categoria': categoria.name,
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
      detalle: map['detalle'] ?? '',
      categoria: CategoriaMeta.values.firstWhere(
        (c) => c.name == (map['categoria'] ?? 'otro'),
        orElse: () => CategoriaMeta.Otro,
      ),
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
  String _detalleMeta = '';
  CategoriaMeta _categoriaMeta = CategoriaMeta.Otro;
  final userEmail = FirebaseAuth.instance.currentUser?.email;
  final TextEditingController _searchController = TextEditingController();
  final List<CategoriaMeta> _categoriasSeleccionadas = [];

  @override
  Widget build(BuildContext context) {
    final alcanciaProvider =
        Provider.of<AlcanciaProvider>(context, listen: true);
    final metasFiltradas = alcanciaProvider.metas.where((meta) {
      final coincideNombre = meta.nombre
          .toLowerCase()
          .contains(_searchController.text.toLowerCase());
      final coincideCategoria = _categoriasSeleccionadas.isEmpty ||
          _categoriasSeleccionadas.contains(meta.categoria);
      return coincideNombre && coincideCategoria;
    }).toList();
    return GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Mis metas'),
            centerTitle: true,
          ),
          drawer: MenuDesplegable(
              logo: 'lib/assets/images/logo.png',
              user: FirebaseAuth.instance.currentUser),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Buscar meta...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ),
              Wrap(
                spacing: 8.0,
                children: CategoriaMeta.values.map((categoria) {
                  final seleccionado =
                      _categoriasSeleccionadas.contains(categoria);
                  return FilterChip(
                    label: Text(categoria.name),
                    selected: seleccionado,
                    onSelected: (bool selected) {
                      setState(() {
                        if (selected) {
                          _categoriasSeleccionadas.add(categoria);
                        } else {
                          _categoriasSeleccionadas.remove(categoria);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: metasFiltradas.length,
                  itemBuilder: (context, index) {
                    final meta = metasFiltradas[index];
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
                                    ? Colors.black
                                    : Colors.red,
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
                            Text('Detalle: ${meta.detalle}'),
                            Text('Categoría: ${meta.categoria.name}'),
                            Text(
                                'Fecha Límite: ${DateFormat('dd/MM/yyyy').format(meta.fechaLimite)}'),
                            const SizedBox(height: 8.0),
                            LinearProgressIndicator(
                              value: meta.valorAhorrado / meta.valorObjetivo,
                              backgroundColor: Colors.grey[300],
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  meta.valorAhorrado / meta.valorObjetivo >= 1
                                      ? Colors.green
                                      : Colors.green),
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
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 5,
                  ),
                  child: const Text(
                    'Agregar Meta',
                    style: TextStyle(fontSize: 16.0, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  void _mostrarDialogoMeta(Meta? meta) {
    _metaEditando = meta;
    _nombreMeta = meta?.nombre ?? '';
    _valorObjetivo = meta?.valorObjetivo ?? 0;
    _detalleMeta = meta?.detalle ?? '';
    _categoriaMeta = meta?.categoria ?? CategoriaMeta.Otro;
    _fechaLimite = meta?.fechaLimite ?? DateTime.now();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(meta == null ? 'Agregar Meta' : 'Editar Meta'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      // Nombre de la meta
                      Expanded(
                        child: TextFormField(
                          initialValue: _nombreMeta,
                          decoration: const InputDecoration(
                            labelText: 'Nombre',
                            border: OutlineInputBorder(),
                          ),
                          onSaved: (value) {
                            _nombreMeta = value!;
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Valor objetivo
                      Expanded(
                        child: TextFormField(
                          initialValue: _valorObjetivo.toString(),
                          decoration: const InputDecoration(
                            labelText: 'Valor Objetivo',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [ThousandsSeparatorInputFormatter()],
                          onSaved: (value) {
                            _valorObjetivo = int.tryParse(
                                  value!.replaceAll(RegExp(r'[,.]'), ''),
                                ) ??
                                0;
                          },
                          validator: (value) {
                            final parsedValue = int.tryParse(
                              value!.replaceAll(RegExp(r'[,.]'), ''),
                            );
                            if (parsedValue == null || parsedValue <= 0) {
                              return 'Debe ser mayor a cero';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Categoría y Fecha Límite
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<CategoriaMeta>(
                          value: _categoriaMeta,
                          items: CategoriaMeta.values
                              .map((CategoriaMeta categoria) {
                            return DropdownMenuItem<CategoriaMeta>(
                              value: categoria,
                              child: Text(categoria.name),
                            );
                          }).toList(),
                          onChanged: (value) {
                            _categoriaMeta = value!;
                          },
                          decoration: const InputDecoration(
                            labelText: 'Categoría',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            _seleccionarFechaLimite(context);
                          },
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'Fecha Límite',
                              border: OutlineInputBorder(),
                            ),
                            child: Text(
                              _fechaLimite != null
                                  ? DateFormat('dd/MM/yyyy')
                                      .format(_fechaLimite)
                                  : 'Seleccionar fecha',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Detalles (en un ExpansionTile para ahorrar espacio)
                  ExpansionTile(
                    title: const Text("Detalles adicionales"),
                    children: [
                      TextFormField(
                        initialValue: _detalleMeta,
                        decoration: const InputDecoration(
                          labelText: 'Detalle',
                          border: OutlineInputBorder(),
                        ),
                        onSaved: (value) {
                          _detalleMeta = value!;
                        },
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 5,
              ),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  final alcanciaProvider =
                      Provider.of<AlcanciaProvider>(context, listen: false);

                  setState(() {
                    if (_metaEditando == null) {
                      final meta = Meta(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        nombre: _nombreMeta,
                        valorObjetivo: _valorObjetivo,
                        detalle: _detalleMeta,
                        categoria: _categoriaMeta,
                        fechaLimite: _fechaLimite,
                      );
                      alcanciaProvider.agregarMeta(meta);
                    } else {
                      _metaEditando!.nombre = _nombreMeta;
                      _metaEditando!.valorObjetivo = _valorObjetivo;
                      _metaEditando!.fechaLimite = _fechaLimite;
                      _metaEditando!.detalle = _detalleMeta;
                      _metaEditando!.categoria = _categoriaMeta;
                      alcanciaProvider.editarMeta(_metaEditando!);
                    }

                    if (userEmail != null) {
                      alcanciaProvider.guardarMetasEnFirebase(
                          alcanciaProvider.metas, userEmail!);
                    }
                  });

                  Navigator.of(context).pop();
                }
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 5,
              ),
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
