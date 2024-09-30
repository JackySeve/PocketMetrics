import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../lib/providers/alcancia_provider.dart';
import '../lib/views/metas.dart';

class MockAlcanciaProvider extends Mock implements AlcanciaProvider {}

void main() {
  test('should add new Meta to AlcanciaProvider', () {
    final alcanciaProvider = MockAlcanciaProvider();
    final meta = Meta(
      id: '1',
      nombre: 'Nueva Meta',
      valorObjetivo: 1000,
      fechaLimite: DateTime(2024, 12, 31),
    );

    alcanciaProvider.agregarMeta(meta);

    verify(alcanciaProvider.agregarMeta(meta)).called(1);
  });
}
