import 'package:flutter/material.dart';

class TransaccionProvider with ChangeNotifier {
  final List<Transaccion> _transacciones = [];

  List<Transaccion> get transacciones => _transacciones;

  void addTransaccion(Transaccion transaccion) {
    _transacciones.add(transaccion);
    notifyListeners();
  }
}

class Transaccion {
  final String id;
  final String nombre;
  final double monto;
  final DateTime fecha;

  Transaccion(
    this.id,
    this.nombre,
    this.monto,
    this.fecha,
  );
}
