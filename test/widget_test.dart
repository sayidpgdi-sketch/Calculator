import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:calculator/calculator_page.dart';

void main() {
  testWidgets('calculator page renders its title and keypad', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: CalculatorPage()));
    expect(find.text('Calculator'), findsOneWidget);
    expect(find.text('AC'), findsOneWidget);
    expect(find.text('='), findsOneWidget);
    expect(find.text('7'), findsOneWidget);
  });
}
