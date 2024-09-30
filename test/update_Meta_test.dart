import 'package:flutter_test/flutter_test.dart';
import '../lib/views/metas.dart';

void main() {
  test('should update Meta values', () {
    final meta = Meta(
      id: '1',
      nombre: 'Meta 1',
      valorObjetivo: 1000,
      valorAhorrado: 500,
      fechaLimite: DateTime(2024, 12, 31),
    );

    meta.nombre = 'Meta Actualizada';
    meta.valorObjetivo = 2000;
    meta.cumplida = true;

    expect(meta.nombre, 'Meta Actualizada');
    expect(meta.valorObjetivo, 2000);
    expect(meta.cumplida, true);
  });
}
