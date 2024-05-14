import 'package:flutter/material.dart';

class AlcanciaProvider with ChangeNotifier {
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

  int _totalAhorrado = 0;

  List<Moneda> get monedas => _monedas;
  List<Billete> get billetes => _billetes;
  int get totalAhorrado => _totalAhorrado;

  void addMoneda(int index, int cantidad) {
    _monedas[index].cantidad += cantidad;
    _totalAhorrado += cantidad * _monedas[index].valor;
    notifyListeners();
  }

  void removeMoneda(int index, int cantidad) {
    if (_monedas[index].cantidad >= cantidad) {
      _monedas[index].cantidad -= cantidad;
      _totalAhorrado -= cantidad * _monedas[index].valor;
      notifyListeners();
    }
  }

  void addBillete(int index, int cantidad) {
    _billetes[index].cantidad += cantidad;
    _totalAhorrado += cantidad * _billetes[index].valor;
    notifyListeners();
  }

  void removeBillete(int index, int cantidad) {
    if (_billetes[index].cantidad >= cantidad) {
      _billetes[index].cantidad -= cantidad;
      _totalAhorrado -= cantidad * _billetes[index].valor;
      notifyListeners();
    }
  }
}

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
