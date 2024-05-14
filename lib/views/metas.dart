import 'package:alcancia_movil/views/widgets/menuDesplegablePrincipal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/alcancia_provider.dart';

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
      id: map['id'],
      nombre: map['nombre'],
      valorObjetivo: map['valorObjetivo'],
      valorAhorrado: map['valorAhorrado'] ?? 0,
      fechaLimite: DateTime.fromMillisecondsSinceEpoch(map['fechaLimite']),
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

  @override
  Widget build(BuildContext context) {
    final alcanciaProvider =
        Provider.of<AlcanciaProvider>(context, listen: true);
    const logo = 'lib/assets/images/logo.png';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis metas'),
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
                return Column(
                  children: [
                    ListTile(
                      title: Text(
                        meta.nombre,
                        style: TextStyle(
                          color: meta.cumplida == true
                              ? Colors.green
                              : meta.fechaLimite.isBefore(DateTime.now()) &&
                                      meta.valorAhorrado < meta.valorObjetivo
                                  ? Colors.red
                                  : Colors.green,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Valor Objetivo: ${meta.valorObjetivo}'),
                          Text('Valor Ahorrado: ${meta.valorAhorrado}'),
                          LinearProgressIndicator(
                            value: meta.valorAhorrado / meta.valorObjetivo,
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              _mostrarDialogoMeta(meta);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
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
                    const Divider(),
                  ],
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
              child: const Text('Agregar Meta'),
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
                  ),
                  onSaved: (value) {
                    _nombreMeta = value!;
                  },
                ),
                TextFormField(
                  initialValue: _valorObjetivo.toString(),
                  decoration: const InputDecoration(
                    labelText: 'Valor Objetivo',
                  ),
                  keyboardType: TextInputType.number,
                  onSaved: (value) {
                    _valorObjetivo = int.tryParse(value!) ?? 0;
                  },
                  validator: (value) {
                    if (int.tryParse(value!) == null || int.parse(value) <= 0) {
                      return 'El valor objetivo debe ser mayor a cero';
                    }
                    return null;
                  },
                ),
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
                  } else {
                    _metaEditando!.nombre = _nombreMeta;
                    _metaEditando!.valorObjetivo = _valorObjetivo;
                    _metaEditando!.fechaLimite = _fechaLimite;
                    alcanciaProvider.editarMeta(_metaEditando!);
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

    if (fechaSeleccionada != null && fechaSeleccionada != _fechaLimite) {
      setState(() {
        _fechaLimite = fechaSeleccionada;
      });
    }
  }

  void _mostrarDialogoConfirmacion(
    BuildContext context,
    AlcanciaProvider alcanciaProvider,
    String idMeta,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar Meta'),
          content:
              const Text('¿Estás seguro de que deseas eliminar esta meta?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                alcanciaProvider.eliminarMeta(idMeta);
                Navigator.of(context).pop();
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }
}
