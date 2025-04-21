// ignore_for_file: avoid_types_as_parameter_names

import 'package:alcancia_movil/Models/bank_saving_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BankSavingsProvider with ChangeNotifier {
  final _db = FirebaseFirestore.instance;
  List<BankSaving> _savings = [];

  List<BankSaving> get savings => _savings;

  double get totalSavings =>
      _savings.fold(0.0, (sum, item) => sum + item.amount);

  List<BankSaving> filterByAccountType(String type) {
    return _savings.where((s) => s.accountType == type).toList();
  }

  /// 🔹 Cargar ahorros desde Firebase
  Future<void> fetchSavings(String userEmail) async {
    final collection = _db
        .collection('usuarios')
        .doc(userEmail)
        .collection('bank_savings');

    final snapshot = await collection.get();

    _savings = snapshot.docs
        .map((doc) => BankSaving.fromJson(doc.data(), doc.id))
        .toList();

    notifyListeners();
  }

  /// 🔹 Guardar un nuevo ahorro
  Future<void> addSaving(BankSaving saving, String userEmail) async {
    final collection = _db
        .collection('usuarios')
        .doc(userEmail)
        .collection('bank_savings');

    final docRef = await collection.add(saving.toJson());

    final newSaving = BankSaving(
      id: docRef.id,
      bankName: saving.bankName,
      accountType: saving.accountType,
      amount: saving.amount,
      lastUpdated: saving.lastUpdated,
    );

    _savings.add(newSaving);
    notifyListeners();
  }

  /// 🔹 Actualizar ahorro existente
  Future<void> updateSaving(BankSaving saving, String userEmail) async {
    final docRef = _db
        .collection('usuarios')
        .doc(userEmail)
        .collection('bank_savings')
        .doc(saving.id);

    await docRef.update(saving.toJson());

    final index = _savings.indexWhere((s) => s.id == saving.id);
    if (index != -1) {
      _savings[index] = saving;
      notifyListeners();
    }
  }

  /// 🔹 Eliminar ahorro
  Future<void> deleteSaving(String id, String userEmail) async {
    final docRef = _db
        .collection('usuarios')
        .doc(userEmail)
        .collection('bank_savings')
        .doc(id);

    await docRef.delete();

    _savings.removeWhere((s) => s.id == id);
    notifyListeners();
  }
}
