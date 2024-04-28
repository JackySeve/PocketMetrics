import 'package:flutter/material.dart';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

class Moneda {
  final int valor;
  int cantidad;

  Moneda(this.valor, {this.cantidad = 0});

  int get total => valor * cantidad;

  Map<String, dynamic> toMap() {
    return {
      'valor': valor,
      'cantidad': cantidad,
    };
  }

  Moneda.fromMap(Map<String, dynamic> map)
      : valor = map['valor'],
        cantidad = map['cantidad'];
}

class Billete {
  final int valor;
  int cantidad;

  Billete(this.valor, {this.cantidad = 0});

  int get total => valor * cantidad;

  Map<String, dynamic> toMap() {
    return {
      'valor': valor,
      'cantidad': cantidad,
    };
  }

  Billete.fromMap(Map<String, dynamic> map)
      : valor = map['valor'],
        cantidad = map['cantidad'];
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

  double calcularMedia() {
    double total = 0;
    int count = 0;
    for (var moneda in _monedas) {
      total += moneda.valor * moneda.cantidad;
      count += moneda.cantidad;
    }
    for (var billete in _billetes) {
      total += billete.valor * billete.cantidad;
      count += billete.cantidad;
    }
    return total / count;
  }

  double calcularMediana() {
    List<double> valores = [];
    for (var moneda in _monedas) {
      for (int i = 0; i < moneda.cantidad; i++) {
        valores.add(moneda.valor.toDouble());
      }
    }
    for (var billete in _billetes) {
      for (int i = 0; i < billete.cantidad; i++) {
        valores.add(billete.valor.toDouble());
      }
    }
    valores.sort();
    int n = valores.length;
    if (n == 0) {
      return 0.0;
    } else if (n % 2 == 0) {
      return (valores[n ~/ 2 - 1] + valores[n ~/ 2]) / 2;
    } else {
      return valores[n ~/ 2];
    }
  }

  double calcularModa() {
    Map<double, int> frecuencias = {};
    for (var moneda in _monedas) {
      frecuencias[moneda.valor.toDouble()] =
          (frecuencias[moneda.valor.toDouble()] ?? 0) + moneda.cantidad;
    }
    for (var billete in _billetes) {
      frecuencias[billete.valor.toDouble()] =
          (frecuencias[billete.valor.toDouble()] ?? 0) + billete.cantidad;
    }
    double moda = 0;
    int maxFrecuencia = 0;
    frecuencias.forEach((valor, frecuencia) {
      if (frecuencia > maxFrecuencia) {
        maxFrecuencia = frecuencia;
        moda = valor;
      }
    });
    return moda;
  }

  double calcularDesviacionEstandar() {
    double media = calcularMedia();
    double suma = 0;
    int count = 0;
    for (var moneda in _monedas) {
      suma += pow(moneda.valor - media, 2) * moneda.cantidad;
      count += moneda.cantidad;
    }
    for (var billete in _billetes) {
      suma += pow(billete.valor - media, 2) * billete.cantidad;
      count += billete.cantidad;
    }
    return sqrt(suma / count);
  }

  double calcularRangoIntercuartil() {
    List<double> valores = [];
    for (var moneda in _monedas) {
      for (int i = 0; i < moneda.cantidad; i++) {
        valores.add(moneda.valor.toDouble());
      }
    }
    for (var billete in _billetes) {
      for (int i = 0; i < billete.cantidad; i++) {
        valores.add(billete.valor.toDouble());
      }
    }
    valores.sort();
    int n = valores.length;
    if (n == 0) {
      return 0.0;
    } else {
      int q1 = (n + 1) ~/ 4;
      int q3 = 3 * (n + 1) ~/ 4;
      return valores[q3 - 1] - valores[q1 - 1];
    }
  }

  double calcularCoeficienteVariacion() {
    double media = calcularMedia();
    double desviacionEstandar = calcularDesviacionEstandar();
    return desviacionEstandar / media;
  }

  Future<void> guardarDatosEnFirestore() async {
    try {
      final firestore = FirebaseFirestore.instance;
      final datosAlcancia = {
        'monedas': _monedas.map((moneda) => moneda.toMap()).toList(),
        'billetes': _billetes.map((billete) => billete.toMap()).toList(),
        'totalAhorrado': totalAhorrado,
      };

      // Crea un nuevo documento en la colección 'alcancia'
      await firestore.collection('alcancia').doc('datos').set(datosAlcancia);
    } catch (e) {
      print('Error al guardar datos en Firestore: $e');
    }
  }

  Future<void> eliminarDatosEnFirestore() async {
    try {
      final firestore = FirebaseFirestore.instance;
      await firestore.collection('alcancia').doc('datos').delete();
      print('Datos eliminados de Firestore');
    } catch (e) {
      print('Error al eliminar datos de Firestore: $e');
    }
  }

  Future<void> cargarDatosDesdeFirestore() async {
    try {
      final firestore = FirebaseFirestore.instance;
      final docSnapshot =
          await firestore.collection('alcancia').doc('datos').get();
      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        _monedas = (data?['monedas'] as List<dynamic>?)
                ?.map((monedaMap) => Moneda.fromMap(monedaMap))
                .toList() ??
            [];
        _billetes = (data?['billetes'] as List<dynamic>?)
                ?.map((billeteMap) => Billete.fromMap(billeteMap))
                .toList() ??
            [];
        _montoTotalAhorrado = data?['totalAhorrado']?.toDouble() ?? 0.0;
        notifyListeners();
        print('Datos cargados desde Firestore');
      } else {
        print('No se encontraron datos en Firestore');
      }
    } catch (e) {
      print('Error al cargar datos desde Firestore: $e');
    }
  }
}

class Transaccion {
  final double monto;
  final bool esIngreso;
  final DateTime fecha;

  Transaccion(this.monto, this.esIngreso, this.fecha);
}
