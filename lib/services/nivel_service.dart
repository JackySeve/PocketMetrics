// ignore_for_file: file_names

import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Servicio para gestionar XP y niveles en función de ahorros.
class XPService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId;

  // Parámetros configurables
  static const int xpBaseFactor = 100;
  static const int umbralMultiplicador = 10000;
  static const double multiplicadorExtra = 1.2;
  static const int coefA = 50;
  static const int coefB = 50;

  XPService({required this.userId});

  /// Calcula el total ahorrado con monedas y billetes.
  /// Lanzará [ArgumentError] si una denominación o cantidad es inválida.
  int calcularTotal(Map<int, int> dinero) {
    int total = 0;
    dinero.forEach((denominacion, cantidad) {
      if (denominacion <= 0 || cantidad < 0) {
        throw ArgumentError('Denominación o cantidad inválida: \$denominacion, \$cantidad');
      }
      total += denominacion * cantidad;
    });
    return total;
  }

  /// Calcula la experiencia ganada por un valor ahorrado.
  int calcularXP(int valorAhorrado) {
    final double multiplicador =
        valorAhorrado >= umbralMultiplicador ? multiplicadorExtra : 1.0;
    return (valorAhorrado / xpBaseFactor * multiplicador).floor();
  }

  /// Fórmula cuadrática de XP requerida para un nivel específico.
  int calcularXPNivel(int nivel) {
    return (coefA * nivel * nivel + coefB * nivel).floor();
  }

  /// Aproxima un nivel inicial resolviendo la ecuación cuadrática
  /// y luego ajusta con un bucle fino.
  int aproximarNivel(int xp) {
    final a = coefA.toDouble();
    final b = coefB.toDouble();
    final c = -xp.toDouble();
    final disc = b * b - 4 * a * c;
    if (disc < 0) return 0;
    final n = ((-b + sqrt(disc)) / (2 * a)).floor();
    return max(0, n);
  }

  /// Determina el nivel actual basado en el XP total.
  int calcularNivel(int xpTotal) {
    int nivel = aproximarNivel(xpTotal);
    // Ajuste fino hacia abajo
    while (nivel > 0 && xpTotal < calcularXPNivel(nivel)) {
      nivel--;
    }
    // Ajuste fino hacia arriba
    while (xpTotal >= calcularXPNivel(nivel + 1)) {
      nivel++;
    }
    return nivel;
  }

  /// Registra un nuevo ahorro y actualiza XP y nivel en Firestore de forma atómica.
  Future<void> registrarAhorro(Map<int, int> monedasYBilletes) async {
    final totalAhorrado = calcularTotal(monedasYBilletes);
    final xpGanada = calcularXP(totalAhorrado);

    final docRef = _firestore.collection('usuarios').doc(userId);
    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      final int xpActual = snapshot.exists && snapshot.data()!.containsKey('xp')
          ? snapshot.get('xp') as int
          : 0;
      final int nuevoXP = xpActual + xpGanada;
      final int nuevoNivel = calcularNivel(nuevoXP);

      transaction.set(
        docRef,
        {
          'xp': nuevoXP,
          'nivel': nuevoNivel,
        },
        SetOptions(merge: true),
      );
    });
  }

  /// Obtiene el progreso actual del usuario (XP y Nivel).
  Future<Map<String, dynamic>> obtenerProgreso() async {
    final docRef = _firestore.collection('usuarios').doc(userId);
    final snapshot = await docRef.get();

    if (snapshot.exists) {
      final data = snapshot.data()!;
      final int xp = (data['xp'] ?? 0) as int;
      final int nivel = (data['nivel'] ?? calcularNivel(xp)) as int;
      return {'xp': xp, 'nivel': nivel};
    } else {
      // Inicializa en Firestore si no existe
      await docRef.set({'xp': 0, 'nivel': 0});
      return {'xp': 0, 'nivel': 0};
    }
  }

  /// Devuelve la XP que falta para alcanzar el siguiente nivel.
  int xpParaSiguienteNivel(int xpActual) {
    final nivelActual = calcularNivel(xpActual);
    final xpSiguiente = calcularXPNivel(nivelActual + 1);
    return xpSiguiente - xpActual;
  }
}
