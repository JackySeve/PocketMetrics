class DivisaModel {
  final String nombre;
  final int valor;
  int cantidad;

  DivisaModel({
    required this.nombre,
    required this.valor,
    this.cantidad = 0,
  });

  /// 🔹 Convierte el modelo en un mapa para Firebase
  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'valor': valor,
      'cantidad': cantidad,
    };
  }

  /// 🔹 Crea un modelo desde un mapa de Firebase
  factory DivisaModel.fromMap(Map<String, dynamic> map) {
    return DivisaModel(
      nombre: map['nombre'],
      valor: map['valor'],
      cantidad: map['cantidad'] ?? 0,
    );
  }
}
