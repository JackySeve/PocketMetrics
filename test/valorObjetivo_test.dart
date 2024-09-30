import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import '../lib/views/metas.dart';

void main() {
  testWidgets('should display error if valorObjetivo is zero or less', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Metas(),
        ),
      ),
    );

    // Encuentra el botón para agregar una nueva meta
    final agregarMetaButton = find.text('Agregar Meta');
    await tester.tap(agregarMetaButton);
    await tester.pump();

    // Encuentra el campo de texto para valorObjetivo y establece un valor inválido
    final valorObjetivoField = find.byType(TextFormField).at(1);
    await tester.enterText(valorObjetivoField, '0');
    await tester.tap(find.text('Guardar'));
    await tester.pump();

    // Verifica si el mensaje de error se muestra
    expect(find.text('El valor objetivo debe ser mayor a cero'), findsOneWidget);
  });
}
