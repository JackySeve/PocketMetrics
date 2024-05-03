import 'package:alcancia_movil/views/widgets/menuDesplegablePrincipal.dart';
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
    final alcanciaProvider = Provider.of<AlcanciaProvider>(context);
    const logo = 'lib/assets/images/logo.png';

    return Scaffold(
      appBar: AppBar(),
      drawer: menuDesplegablePrincipal(logo, context),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: alcanciaProvider.metas.length,
              itemBuilder: (context, index) {
                final meta = alcanciaProvider.metas[index];
                return ListTile(
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
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _mostrarDialogoMeta(meta);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
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
              child: Text('Agregar Meta'),
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
                  decoration: InputDecoration(
                    labelText: 'Nombre de la meta',
                  ),
                  onSaved: (value) {
                    _nombreMeta = value!;
                  },
                ),
                TextFormField(
                  initialValue: _valorObjetivo.toString(),
                  decoration: InputDecoration(
                    labelText: 'Valor Objetivo',
                  ),
                  keyboardType: TextInputType.number,
                  onSaved: (value) {
                    _valorObjetivo = int.tryParse(value!) ?? 0;
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
                      style: TextStyle(
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
              child: Text('Cancelar'),
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
                    final metaEditada = Meta(
                      id: _metaEditando!.id,
                      nombre: _nombreMeta,
                      valorObjetivo: _valorObjetivo,
                      valorAhorrado: _metaEditando!.valorAhorrado,
                      fechaLimite: _fechaLimite,
                      cumplida: _metaEditando!.cumplida,
                    );
                    alcanciaProvider.editarMeta(metaEditada);
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
    final DateTime? fechaSeleccionada = await showDatePicker(
      context: context,
      initialDate: _fechaLimite,
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
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Eliminar Meta'),
          content: Text('¿Estás seguro de que deseas eliminar esta meta?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                alcanciaProvider.eliminarMeta(idMeta);
                Navigator.of(context).pop();
              },
              child: Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }
}
