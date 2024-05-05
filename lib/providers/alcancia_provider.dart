import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../views/metas.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    if (index >= 0 && index < _monedas.length) {
      _monedas[index].cantidad = cantidad < 0 ? 0 : cantidad;
      notifyListeners();
      actualizarValoresAhorradosMetas();
    } else {
      print('Índice de moneda fuera de rango');
    }
  }

  void actualizarCantidadBillete(int index, int cantidad) {
    if (index >= 0 && index < _billetes.length) {
      _billetes[index].cantidad = cantidad < 0 ? 0 : cantidad;
      notifyListeners();
      actualizarValoresAhorradosMetas();
    } else {
      print('Índice de billete fuera de rango');
    }
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

  Future<void> agregarTransaccion(double monto, bool esIngreso) async {
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
    Transaccion transaccion = Transaccion(monto, esIngreso, DateTime.now());
    _transacciones.add(transaccion);
    await guardarTransaccionEnFirestore(transaccion);
    notifyListeners();
  }

  Future<void> guardarTransaccionEnFirestore(Transaccion transaccion) async {
    try {
      final firestore = FirebaseFirestore.instance;
      await firestore.collection('transacciones').add(transaccion.toMap());
    } catch (e) {
      print('Error al guardar transacción en Firestore: $e');
    }
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

  List<Meta> _metas = [];

  List<Meta> get metas => _metas;

  void agregarMeta(Meta meta) {
    _metas.add(meta);
    notifyListeners();
    _guardarMetaEnFirebase(meta);
  }

  void crearMeta(
      String nombre, double valorObjetivo, DateTime fechaLimite) async {
    await FirebaseFirestore.instance.collection('metas').add({
      'nombre': nombre,
      'valorObjetivo': valorObjetivo,
      'fechaLimite': fechaLimite,
      'cumplida': false,
    });
  }

  Future<void> verificarFechaMetas() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('metas').get();

    querySnapshot.docs.forEach((doc) async {
      DateTime fechaLimite =
          DateTime.fromMillisecondsSinceEpoch(doc['fechaLimite']);
      if (DateTime.now().isAfter(fechaLimite)) {
        await FirebaseFirestore.instance
            .collection('metas')
            .doc(doc.id)
            .update({
          'cumplida': true,
        });
      }
    });
  }

  Future<void> _guardarMetaEnFirebase(Meta meta) async {
    try {
      final firestore = FirebaseFirestore.instance;
      final metasRef = firestore.collection('metas');
      await metasRef.add(meta.toMap());
      print('Meta guardada en Firebase');
    } catch (e) {
      print('Error al guardar meta en Firebase: $e');
    }
  }

  void editarMeta(Meta meta) {
    int index = _metas.indexWhere((m) => m.id == meta.id);
    if (index != -1) {
      _metas[index] = meta;
      notifyListeners();
      _guardarMetaEnFirebase(meta);
    }
  }

  void eliminarMeta(String id) {
    _metas.removeWhere((meta) => meta.id == id);
    notifyListeners();
    guardarMetasEnFirestore();
  }

  Future<void> guardarMetasEnFirestore() async {
    try {
      final firestore = FirebaseFirestore.instance;
      final metasRef = firestore.collection('metas');

      final snapshot = await metasRef.get();
      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }

      for (var meta in _metas) {
        await metasRef.add(meta.toMap());
      }
    } catch (e) {
      print('Error al guardar metas en Firestore: $e');
    }
  }

  Future<void> cargarMetasDesdeFirestore() async {
    try {
      final firestore = FirebaseFirestore.instance;
      final snapshot = await firestore.collection('metas').get();
      _metas = snapshot.docs.map((doc) => Meta.fromMap(doc.data())).toList();
      notifyListeners();
      print('Metas cargadas desde Firestore');
    } catch (e) {
      print('Error al cargar metas desde Firestore: $e');
    }
  }

  void actualizarValoresAhorradosMetas() {
    int totalAhorrado = this.totalAhorrado;
    for (var meta in _metas) {
      if (totalAhorrado >= meta.valorObjetivo) {
        meta.valorAhorrado = meta.valorObjetivo;
      } else {
        meta.valorAhorrado = totalAhorrado;
      }
    }
    notifyListeners();
  }

  void verificarMetasCumplidas() {
    final DateTime ahora = DateTime.now();
    for (var meta in _metas) {
      if (ahora.isAfter(meta.fechaLimite)) {
        if (meta.valorAhorrado >= meta.valorObjetivo) {
          // Meta cumplida
          meta.cumplida = true;
        } else {
          // Meta incumplida
          meta.cumplida = false;
        }
      }
    }
    notifyListeners();
  }

  Map<String, int> obtenerMetasCumplidasEIncumplidas() {
    int metasCumplidas = 0;
    int metasIncumplidas = 0;

    for (var meta in _metas) {
      if (meta.cumplida) {
        metasCumplidas++;
      } else {
        metasIncumplidas++;
      }
    }

    return {
      'metasCumplidas': metasCumplidas,
      'metasIncumplidas': metasIncumplidas,
    };
  }

  Future<void> guardarDatosEnFirebase() async {
    try {
      final firestore = FirebaseFirestore.instance;
      final datosAlcancia = {
        'monedas': _monedas.map((moneda) => moneda.toMap()).toList(),
        'billetes': _billetes.map((billete) => billete.toMap()).toList(),
        'totalAhorrado': totalAhorrado,
      };

      await firestore.collection('alcancia').doc('datos').set(datosAlcancia);
    } catch (e) {
      print('Error al guardar datos en Firebase: $e');
    }
  }

  Future<void> cargarDatosDesdeFirebase() async {
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
        print('Datos cargados desde Firebase');
      } else {
        print('No se encontraron datos en Firebase');
      }
    } catch (e) {
      print('Error al cargar datos desde Firebase: $e');
    }
  }

  Future<void> guardarDatosLocalmente() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final datosAlcancia = {
        'monedas': _monedas.map((moneda) => moneda.toMap()).toList(),
        'billetes': _billetes.map((billete) => billete.toMap()).toList(),
        'totalAhorrado': totalAhorrado,
      };
      await prefs.setString('datosAlcancia', json.encode(datosAlcancia));
      print('Datos guardados localmente');
    } catch (e) {
      print('Error al guardar datos localmente: $e');
    }
  }

  Future<void> cargarDatosLocalmente() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final datosAlcancia = prefs.getString('datosAlcancia');
      if (datosAlcancia != null) {
        final data = json.decode(datosAlcancia);
        _monedas = (data['monedas'] as List<dynamic>?)
                ?.map((monedaMap) => Moneda.fromMap(monedaMap))
                .toList() ??
            [];
        _billetes = (data['billetes'] as List<dynamic>?)
                ?.map((billeteMap) => Billete.fromMap(billeteMap))
                .toList() ??
            [];
        _montoTotalAhorrado = data['totalAhorrado']?.toDouble() ?? 0.0;
        notifyListeners();
        print('Datos cargados localmente');
      } else {
        print('No se encontraron datos localmente');
      }
    } catch (e) {
      print('Error al cargar datos localmente: $e');
    }
  }

  Future<void> guardarTransaccionesEnFirebase() async {
    try {
      final firestore = FirebaseFirestore.instance;
      final transaccionesRef = firestore.collection('transacciones');

      final snapshot = await transaccionesRef.get();
      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }

      _transacciones.sort((a, b) => a.fecha.compareTo(b.fecha));

      for (var transaccion in _transacciones) {
        await transaccionesRef.add(transaccion.toMap());
      }
    } catch (e) {
      print('Error al guardar transacciones en Firebase: $e');
    }
  }

  Future<void> cargarTransaccionesDesdeFirebase() async {
    try {
      final transaccionesRef =
          FirebaseFirestore.instance.collection('transacciones');
      final snapshot = await transaccionesRef.get();
      final transacciones =
          snapshot.docs.map((doc) => Transaccion.fromMap(doc.data())).toList();
      _transacciones = transacciones;
      notifyListeners();
    } catch (e) {
      print('Error al cargar transacciones desde Firebase: $e');
    }
  }

  Future<void> guardarMetasEnFirebase() async {
    try {
      final firestore = FirebaseFirestore.instance;
      final metasRef = firestore.collection('metas');

      final snapshot = await metasRef.get();
      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }

      for (var meta in _metas) {
        await metasRef.add(meta.toMap());
      }
    } catch (e) {
      print('Error al guardar metas en Firebase: $e');
    }
  }

  Future<void> cargarMetasDesdeFirebase() async {
    try {
      final metasRef = FirebaseFirestore.instance.collection('metas');
      final snapshot = await metasRef.get();
      final metas =
          snapshot.docs.map((doc) => Meta.fromMap(doc.data())).toList();
      _metas = metas;
      notifyListeners();
    } catch (e) {
      print('Error al cargar metas desde Firebase: $e');
    }
  }
}

class Transaccion {
  final double monto;
  final bool esIngreso;
  final DateTime fecha;

  Transaccion(this.monto, this.esIngreso, this.fecha);

  Map<String, dynamic> toMap() {
    return {
      'monto': monto,
      'esIngreso': esIngreso,
      'fecha': fecha.millisecondsSinceEpoch,
    };
  }

  factory Transaccion.fromMap(Map<String, dynamic> map) {
    return Transaccion(
      map['monto'],
      map['esIngreso'],
      DateTime.fromMillisecondsSinceEpoch(map['fecha']),
    );
  }
}
