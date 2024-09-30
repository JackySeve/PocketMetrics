import 'package:flutter_test/flutter_test.dart';
import '../lib/views/metas.dart';

void main() {
  group('Meta', () {
    test('should convert Meta to Map correctly', () {
      final meta = Meta(
        id: '1',
        nombre: 'Meta 1',
        valorObjetivo: 1000,
        valorAhorrado: 500,
        fechaLimite: DateTime(2024, 12, 31),
        cumplida: false,
      );

      final map = meta.toMap();

      expect(map, {
        'id': '1',
        'nombre': 'Meta 1',
        'valorObjetivo': 1000,
        'valorAhorrado': 500,
        'fechaLimite': DateTime(2024, 12, 31).millisecondsSinceEpoch,
        'cumplida': false,
      });
    });

    test('should create Meta from Map correctly', () {
      final map = {
        'id': '1',
        'nombre': 'Meta 1',
        'valorObjetivo': 1000,
        'valorAhorrado': 500,
        'fechaLimite': DateTime(2024, 12, 31).millisecondsSinceEpoch,
        'cumplida': false,
      };

      final meta = Meta.fromMap(map);

      expect(meta.id, '1');
      expect(meta.nombre, 'Meta 1');
      expect(meta.valorObjetivo, 1000);
      expect(meta.valorAhorrado, 500);
      expect(meta.fechaLimite, DateTime(2024, 12, 31));
      expect(meta.cumplida, false);
    });
  });
}
