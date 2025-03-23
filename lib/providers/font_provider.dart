//Temporalmente en Desuso mientras se hace la segregación del Provider "alcancia_provider"

import 'package:flutter/material.dart';

class FontProvider with ChangeNotifier {
  double _fontSize = 18; // Tamaño de fuente predeterminado
  String _fontFamily = 'Asap'; // Fuente predeterminada

  double get fontSize => _fontSize;
  String get fontFamily => _fontFamily;

  void setFontSize(double newSize) {
    _fontSize = newSize;
    notifyListeners(); // Notifica a todos los listeners
  }

  void setFontFamily(String newFont) {
    _fontFamily = newFont;
    notifyListeners(); // Notifica a todos los listeners
  }
}
