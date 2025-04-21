import 'dart:math';

class FinanciamientoModel {
  final String id;
  final double montoPrestamo;
  final double tasaInteresAnual;
  final int plazoEnMeses;

  FinanciamientoModel({
    required this.id,
    required this.montoPrestamo,
    required this.tasaInteresAnual,
    required this.plazoEnMeses,
  });

  double get cuotaMensual {
    final i = tasaInteresAnual / 100 / 12;
    final n = plazoEnMeses;
    final P = montoPrestamo;

    if (i == 0) return P / n;

    return P * (i * pow(1 + i, n)) / (pow(1 + i, n) - 1);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'montoPrestamo': montoPrestamo,
      'tasaInteresAnual': tasaInteresAnual,
      'plazoEnMeses': plazoEnMeses,
    };
  }

  factory FinanciamientoModel.fromMap(Map<String, dynamic> map) {
    return FinanciamientoModel(
      id: map['id'],
      montoPrestamo: map['montoPrestamo'],
      tasaInteresAnual: map['tasaInteresAnual'],
      plazoEnMeses: map['plazoEnMeses'],
    );
  }
}
