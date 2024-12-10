// test/custom_body_wellness_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paraflorseer/body_service/custom_body_wellness.dart';

void main() {
  testWidgets(
      'CustomBodyWellness muestra un indicador de carga mientras espera',
      (WidgetTester tester) async {
    // Arrange: Construir el widget dentro de un entorno de prueba
    await tester.pumpWidget(
      const MaterialApp(
        home: CustomBodyWellness(),
      ),
    );

    // Act: Esperar a que el FutureBuilder esté en estado de espera
    await tester
        .pump(); // Avanza el tiempo para que el FutureBuilder se construya

    // Assert: Verificar que se muestra un CircularProgressIndicator
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  // Puedes agregar más pruebas aquí para verificar otros comportamientos
}
