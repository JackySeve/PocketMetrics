import 'package:flutter/material.dart';

class alcanciaData extends ChangeNotifier {
  int _moneda50 = 0;
  int _moneda100 = 0;

  int get moneda50 => _moneda50;
  int get moneda100 => _moneda100;
  int get valorTotalAhorrado => _moneda50 * 50 + _moneda100 * 100;

  void incrementMoneda50() {
    _moneda50++;
    notifyListeners();
  }

  void decrementMoneda50() {
    _moneda50 = _moneda50 > 0 ? _moneda50 - 1 : 0;
    notifyListeners();
  }

  void incrementMoneda100() {
    _moneda100++;
    notifyListeners();
  }

  void decrementMoneda100() {
    _moneda100 = _moneda100 > 0 ? _moneda100 - 1 : 0;
    notifyListeners();
  }
}
