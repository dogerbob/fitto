import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitto/screens/onboarding/personal_info_screen.dart';
import 'package:fitto/screens/onboarding/preferences_screen.dart';

void main() {
  group('PersonalInfoScreen', () {
    testWidgets('displays personal info form', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const PersonalInfoScreen(),
        ),
      );

      // Verify title is displayed
      expect(find.text('Tell us about yourself'), findsOneWidget);
      
      // Verify form fields are displayed
      expect(find.byIcon(Icons.person), findsOneWidget); // Name field
      expect(find.byIcon(Icons.cake), findsOneWidget); // Age field
      expect(find.byIcon(Icons.monitor_weight), findsOneWidget); // Weight field
      expect(find.byIcon(Icons.height), findsOneWidget); // Height field
      
      // Verify gender options
      expect(find.text('Male'), findsOneWidget);
      expect(find.text('Female'), findsOneWidget);
      expect(find.text('Other'), findsOneWidget);
      
      // Verify activity levels
      expect(find.text('Sedentary'), findsOneWidget);
      expect(find.text('Lightly Active'), findsOneWidget);
      expect(find.text('Moderately Active'), findsOneWidget);
      
      // Verify Continue button
      expect(find.text('Continue'), findsOneWidget);
    });

    testWidgets('validates required fields', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const PersonalInfoScreen(),
        ),
      );

      // Try to submit without filling required fields
      await tester.tap(find.text('Continue'));
      await tester.pump();

      // Should show validation errors
      expect(find.text('Please enter your name'), findsOneWidget);
    });

    testWidgets('accepts valid input and navigates to preferences', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const PersonalInfoScreen(),
          routes: {
            PreferencesScreen.routeName: (context) => const PreferencesScreen(),
          },
        ),
      );

      // Fill in the form
      await tester.enterText(find.byType(TextFormField).at(0), 'John Doe'); // Name
      await tester.enterText(find.byType(TextFormField).at(1), '25'); // Age
      await tester.enterText(find.byType(TextFormField).at(2), '70'); // Weight
      await tester.enterText(find.byType(TextFormField).at(3), '175'); // Height
      
      // Select gender
      await tester.tap(find.text('Male'));
      await tester.pump();
      
      // Select activity level
      await tester.tap(find.text('Moderately Active'));
      await tester.pump();

      // Tap Continue
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      // Verify navigation to preferences screen
      expect(find.byType(PreferencesScreen), findsOneWidget);
    });
  });
}