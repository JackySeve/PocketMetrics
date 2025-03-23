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

  Future<void> eliminarGasto(String id, String userEmail) async {
    await _firestore
        .collection('usuarios')
        .doc(userEmail)
        .collection('gastos')
        .doc(id)
        .delete();

    _gastos.removeWhere((gasto) => gasto.id == id);
    notifyListeners();
  }
}
