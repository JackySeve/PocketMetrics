class Gasto {
  String id;
  String nombre;
  String descripcion;
  DateTime fecha;
  int valor;

  Gasto({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.fecha,
    required this.valor,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'fecha': fecha.millisecondsSinceEpoch,
      'valor': valor,
    };
  }

  factory Gasto.fromMap(Map<String, dynamic> map) {
    return Gasto(
      id: map['id'] ?? '',
      nombre: map['nombre'] ?? '',
      descripcion: map['descripcion'] ?? '',
      fecha: DateTime.fromMillisecondsSinceEpoch(map['fecha'] ?? 0),
      valor: map['valor'] ?? 0,
    );
  }
}
