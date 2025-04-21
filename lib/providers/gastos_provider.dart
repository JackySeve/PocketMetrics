import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/gastos_model.dart';

class GastosProvider with ChangeNotifier {
  List<Gasto> _gastos = [];

  List<Gasto> get gastos => _gastos;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> cargarGastos(String userEmail) async {
    final snapshot = await _firestore
        .collection('usuarios')
        .doc(userEmail)
        .collection('gastos')
        .get();

    _gastos = snapshot.docs
        .map((doc) => Gasto.fromMap(doc.data()..['id'] = doc.id))
        .toList();

    notifyListeners();
  }

  Future<void> agregarGasto(Gasto gasto, String userEmail) async {
    final docRef = await _firestore
        .collection('usuarios')
        .doc(userEmail)
        .collection('gastos')
        .add(gasto.toMap());

    gasto.id = docRef.id;
    _gastos.add(gasto);
    notifyListeners();
  }

  Future<void> eliminarGasto(
      String id, String userEmail, BuildContext context) async {
    bool confirmar = await _confirmarEliminacion(context);
    if (!confirmar) return;

    await _firestore
        .collection('usuarios')
        .doc(userEmail)
        .collection('gastos')
        .doc(id)
        .delete();

    _gastos.removeWhere((gasto) => gasto.id == id);
    notifyListeners();
  }

  Future<void> editarGasto(Gasto gasto, String userEmail) async {
    await _firestore
        .collection('usuarios')
        .doc(userEmail)
        .collection('gastos')
        .doc(gasto.id)
        .update(gasto.toMap());

    int index = _gastos.indexWhere((g) => g.id == gasto.id);
    if (index != -1) {
      _gastos[index] = gasto;
      notifyListeners();
    }
  }

  Future<bool> _confirmarEliminacion(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Confirmar eliminación'),
            content: Text('¿Estás seguro de que deseas eliminar este gasto?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: Text('Cancelar', style: TextStyle(color: Colors.white)),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: Text('Eliminar', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ) ??
        false;
  }
}
