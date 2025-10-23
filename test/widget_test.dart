import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitto/main.dart';

void main() {
  testWidgets('Fitto app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const FittoApp());

    // Verify that the splash screen is displayed
    expect(find.text('Fitto'), findsOneWidget);
    expect(find.text('Your Fitness Journey'), findsOneWidget);
  });
}