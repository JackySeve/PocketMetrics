import 'package:flutter/material.dart';

class MetaProvider with ChangeNotifier {
  final List<Meta> _metas = [];

  List<Meta> get metas => _metas;

  void addMeta(Meta meta) {
    _metas.add(meta);
    notifyListeners();
  }

  void updateMeta(Meta meta) {
    int index = _metas.indexWhere((m) => m.id == meta.id);
    if (index != -1) {
      _metas[index] = meta;
      notifyListeners();
    }
  }

  void deleteMeta(String id) {
    _metas.removeWhere((m) => m.id == id);
    notifyListeners();
  }
}

class Meta {
  final String id;
  final String nombre;
  final double monto;
  double? montoAhorrado;
  bool isCompleted;

  Meta(
    this.id,
    this.nombre,
    this.monto, {
    this.montoAhorrado = 0.0,
    this.isCompleted = false,
  });
}
