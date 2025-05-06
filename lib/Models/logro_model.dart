import 'package:cloud_firestore/cloud_firestore.dart';

class Logro {
  final String id;
  final String nombre;
  final String descripcion;
  final String icono;
  final bool completado;
  final DateTime? fechaLogro;

  Logro({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.icono,
    required this.completado,
    this.fechaLogro,
  });

  /// Ahora acepta dos argumentos: el mapa de datos y el id del documento
  factory Logro.fromMap(Map<String, dynamic> data, String id) {
    return Logro(
      id: id,
      nombre: data['nombre'] ?? '',
      descripcion: data['descripcion'] ?? '',
      icono: data['icono'] ?? '',
      completado: data['completado'] ?? false,
      fechaLogro: data['fechaLogro'] is Timestamp
          ? (data['fechaLogro'] as Timestamp).toDate()
          : null,
    );
  }

  /// Para guardar en Firebase (incluye Timestamp si existe fechaLogro)
  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'descripcion': descripcion,
      'icono': icono,
      'completado': completado,
      'fechaLogro': fechaLogro != null
          ? Timestamp.fromDate(fechaLogro!)
          : null,
    };
  }

  /// copyWith para clonar y cambiar campos concretos
  Logro copyWith({
    String? id,
    String? nombre,
    String? descripcion,
    String? icono,
    bool? completado,
    DateTime? fechaLogro,
  }) {
    return Logro(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      icono: icono ?? this.icono,
      completado: completado ?? this.completado,
      fechaLogro: fechaLogro ?? this.fechaLogro,
    );
  }
}
