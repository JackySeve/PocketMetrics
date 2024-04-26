import 'package:flutter/material.dart';

class Moneda {
  final int valor;
  int cantidad;

  Moneda(this.valor, {this.cantidad = 0});

  int get total => valor * cantidad;
}

class Billete {
  final int valor;
  int cantidad;

  Billete(this.valor, {this.cantidad = 0});

  int get total => valor * cantidad;
}

class AlcanciaProvider with ChangeNotifier {
  List<Transaccion> _transacciones = [];

  List<Transaccion> get transacciones => _transacciones;

  List<Moneda> _monedas = [
    Moneda(50),
    Moneda(100),
    Moneda(200),
    Moneda(500),
    Moneda(1000),
  ];

  List<Billete> _billetes = [
    Billete(1000),
    Billete(2000),
    Billete(5000),
    Billete(10000),
    Billete(20000),
    Billete(50000),
    Billete(100000),
  ];

  List<Moneda> get monedas => _monedas;
  List<Billete> get billetes => _billetes;

  double _montoTotalAhorrado = 0.0;

  double get montoTotalAhorrado => _montoTotalAhorrado;

  void actualizarCantidadMoneda(int index, int cantidad) {
    _monedas[index].cantidad = cantidad < 0 ? 0 : cantidad;
    notifyListeners();
  }

  void actualizarCantidadBillete(int index, int cantidad) {
    _billetes[index].cantidad = cantidad < 0 ? 0 : cantidad;
    notifyListeners();
  }

  int get totalAhorrado {
    int total = 0;
    for (var moneda in _monedas) {
      total += moneda.total;
    }
    for (var billete in _billetes) {
      total += billete.total;
    }
    return total;
  }

  int get totalAhorradoMonedas {
    int total = 0;
    for (var moneda in _monedas) {
      total += moneda.total;
    }
    return total;
  }

  int get totalAhorradoBilletes {
    int total = 0;
    for (var billete in _billetes) {
      total += billete.total;
    }
    return total;
  }

  void agregarTransaccion(double monto, bool esIngreso) {
    if (esIngreso) {
      _montoTotalAhorrado += monto;
    } else {
      if (_montoTotalAhorrado >= monto) {
        _montoTotalAhorrado -= monto;
      } else {
        print("No hay suficiente dinero ahorrado para retirar $monto");
        return;
      }
    }
    _transacciones.add(Transaccion(monto, esIngreso, DateTime.now()));
    notifyListeners();
  }
}

class Transaccion {
  final double monto;
  final bool esIngreso;
  final DateTime fecha;

  Transaccion(this.monto, this.esIngreso, this.fecha);
}
