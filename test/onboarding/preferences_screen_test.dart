import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitto/screens/onboarding/preferences_screen.dart';
import 'package:fitto/screens/home_tabs_screen.dart';

void main() {
  group('PreferencesScreen', () {
    testWidgets('displays preferences form', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const PreferencesScreen(),
        ),
      );

      // Verify title is displayed
      expect(find.text('Set your preferences'), findsOneWidget);
      
      // Verify subtitle is displayed
      expect(find.text('Customize your Fitto experience to match your lifestyle.'), findsOneWidget);
      
      // Verify workout days section
      expect(find.text('Preferred Workout Days'), findsOneWidget);
      expect(find.text('Monday'), findsOneWidget);
      expect(find.text('Tuesday'), findsOneWidget);
      
      // Verify interests section
      expect(find.text('Fitness Interests'), findsOneWidget);
      expect(find.text('Strength Training'), findsOneWidget);
      expect(find.text('Cardio'), findsOneWidget);
      
      // Verify theme section
      expect(find.text('App Theme'), findsOneWidget);
      expect(find.text('System Default'), findsOneWidget);
      expect(find.text('Light'), findsOneWidget);
      expect(find.text('Dark'), findsOneWidget);
      
      // Verify notifications section
      expect(find.text('Notifications'), findsOneWidget);
      expect(find.text('Enable notifications'), findsOneWidget);
      expect(find.text('Workout reminders'), findsOneWidget);
      
      // Verify Complete Setup button
      expect(find.text('Complete Setup'), findsOneWidget);
    });

    testWidgets('allows selecting workout days', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const PreferencesScreen(),
        ),
      );

      // Select some workout days
      await tester.tap(find.text('Monday'));
      await tester.pump();
      await tester.tap(find.text('Wednesday'));
      await tester.pump();
      await tester.tap(find.text('Friday'));
      await tester.pump();

      // Verify the chips are selected
      final mondayChip = find.ancestor(
        of: find.text('Monday'),
        matching: find.byType(FilterChip),
      );
      expect(tester.widget<FilterChip>(mondayChip).selected, isTrue);
    });

    testWidgets('allows selecting interests', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const PreferencesScreen(),
        ),
      );

      // Select some interests
      await tester.tap(find.text('Strength Training'));
      await tester.pump();
      await tester.tap(find.text('Cardio'));
      await tester.pump();

      // Verify the chips are selected
      final strengthChip = find.ancestor(
        of: find.text('Strength Training'),
        matching: find.byType(FilterChip),
      );
      expect(tester.widget<FilterChip>(strengthChip).selected, isTrue);
    });

    testWidgets('allows changing theme preference', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const PreferencesScreen(),
        ),
      );

      // Select dark theme
      await tester.tap(find.text('Dark'));
      await tester.pump();

      // Verify dark theme is selected
      final darkThemeRadio = find.ancestor(
        of: find.text('Dark'),
        matching: find.byType(RadioListTile),
      );
      expect(tester.widget<RadioListTile>(darkThemeRadio).value, equals('dark'));
    });

    testWidgets('allows toggling notifications', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const PreferencesScreen(),
        ),
      );

      // Toggle notifications off
      await tester.tap(find.text('Enable notifications'));
      await tester.pump();

      // Verify the switch is off
      final notificationSwitch = find.ancestor(
        of: find.text('Enable notifications'),
        matching: find.byType(SwitchListTile),
      );
      expect(tester.widget<SwitchListTile>(notificationSwitch).value, isFalse);
    });
  });
}