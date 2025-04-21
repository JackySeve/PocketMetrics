import 'package:flutter/material.dart';
import 'package:alcancia_movil/Models/financiamiento_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FinanciamientoProvider with ChangeNotifier {
  List<FinanciamientoModel> _financiamientos = [];

  List<FinanciamientoModel> get financiamientos => _financiamientos;

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> fetchFinanciamientos(String userEmail) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final snapshot = await _db
        .collection('usuarios')
        .doc(userEmail)
        .collection('financiamientos')
        .get();

    _financiamientos = snapshot.docs
        .map((doc) => FinanciamientoModel.fromMap(doc.data()))
        .toList();

    notifyListeners();
  }

  Future<void> addFinanciamiento(
      FinanciamientoModel financiamiento, String userEmail) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _db
        .collection('usuarios')
        .doc(userEmail)
        .collection('financiamientos')
        .doc(financiamiento.id)
        .set(financiamiento.toMap());

    _financiamientos.add(financiamiento);
    notifyListeners();
  }

  Future<void> deleteFinanciamiento(String id, String userEmail) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _db
        .collection('usuarios')
        .doc(userEmail)
        .collection('financiamientos')
        .doc(id)
        .delete();

    _financiamientos.removeWhere((f) => f.id == id);
    notifyListeners();
  }

  FinanciamientoModel? obtenerUltimoFinanciamiento() {
    if (_financiamientos.isEmpty) return null;
    return _financiamientos.first;
  }
}
