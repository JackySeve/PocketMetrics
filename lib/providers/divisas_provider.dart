import 'package:alcancia_movil/Models/divisa_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DivisasProvider extends ChangeNotifier {
  List<DivisaModel> divisas = [];

  /// 🔹 Obtiene el total ahorrado en divisas
  int get totalAhorradoDivisas =>
      divisas.fold(0, (sum, item) => sum + (item.valor * item.cantidad));

  /// 🔹 Agrega o resta cantidad de una divisa
  void actualizarCantidadDivisa(int index, bool isAddition, String userEmail) {
    if (index >= 0 && index < divisas.length) {
      if (isAddition) {
        divisas[index].cantidad += 1;
      } else {
        if (divisas[index].cantidad > 0) {
          divisas[index].cantidad -= 1;
        }
      }
      notifyListeners();
      guardarDivisasEnFirebase(userEmail);
    }
  }

  /// 🔹 Agrega una nueva divisa a la lista
  void agregarDivisa(DivisaModel nuevaDivisa, String userEmail) {
    divisas.add(nuevaDivisa);
    notifyListeners();
    guardarDivisasEnFirebase(userEmail);
  }

  /// 🔹 Guarda las divisas en Firebase Firestore
  Future<void> guardarDivisasEnFirebase(String userEmail) async {
    final firestore = FirebaseFirestore.instance;
    final userDoc = firestore.collection('usuarios').doc(userEmail);

    final divisasMap = divisas.map((d) => d.toMap()).toList();

    try {
      print("📤 Guardando en Firebase: $divisasMap"); // 🔍 Depuración
      await userDoc.set({'divisas': divisasMap}, SetOptions(merge: true));
      print("✅ Datos guardados correctamente");
    } catch (e) {
      print("❌ Error al guardar en Firebase: $e");
    }
  }

  /// 🔹 Carga las divisas desde Firebase Firestore
  Future<void> cargarDivisasDesdeFirebase(String userEmail) async {
    final firestore = FirebaseFirestore.instance;
    final userDoc = firestore.collection('usuarios').doc(userEmail);

    final snapshot = await userDoc.get();
    if (snapshot.exists && snapshot.data()!.containsKey('divisas')) {
      List<dynamic> divisasData = snapshot.data()!['divisas'];
      print("📥 Datos cargados desde Firebase: $divisasData");
      divisas = divisasData.map((d) => DivisaModel.fromMap(d)).toList();
    } else {
      print("⚠️ No se encontraron datos en Firebase");
      divisas = [];
    }
    notifyListeners();
  }
}
