import 'package:alcancia_movil/views/divisas.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

void main() {
  group('Divisas Conversion Tests', () {
    testWidgets('Debe mostrar un mensaje de error si el campo de valor está vacío', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(const MaterialApp(home: Divisas()));
      await tester.enterText(find.byType(TextField), '');
      
      // Act
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();
      
      // Assert
      expect(find.text('Ingrese un valor'), findsOneWidget);
    });

    testWidgets('Debe mostrar un mensaje de error si se ingresa un valor menor a 0.01', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(const MaterialApp(home: Divisas()));
      await tester.enterText(find.byType(TextField), '0.000000000000001');
      
      // Act
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();
      
      // Assert
      expect(find.text('No se pudo obtener la tasa de conversión.'), findsOneWidget);
    });

    testWidgets('Debe convertir correctamente de COP a USD con valor válido', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(const MaterialApp(home: Divisas()));
      await tester.enterText(find.byType(TextField), '10000');
      
      // Act
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();
      
      // Assert
      // Aquí reemplaza el número con el valor esperado después de la conversión
      expect(find.text('Resultado de la Conversión: X USD'), findsOneWidget);
    });

    testWidgets('Debe mostrar un mensaje de error si las divisas de origen y destino son las mismas', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(const MaterialApp(home: Divisas()));
      
      // Act
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();
      
      // Assert
      expect(find.text('La moneda de origen y destino no pueden ser la misma.'), findsOneWidget);
    });
  });
}
