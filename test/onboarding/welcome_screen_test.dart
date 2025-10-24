import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitto/screens/onboarding/welcome_screen.dart';
import 'package:fitto/screens/onboarding/goal_setting_screen.dart';

void main() {
  group('WelcomeScreen', () {
    testWidgets('displays welcome content', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const WelcomeScreen(),
        ),
      );

      // Verify welcome title is displayed
      expect(find.text('Welcome to Fitto'), findsOneWidget);
      
      // Verify description is displayed
      expect(find.text('Your personal fitness companion for workouts, nutrition tracking, and wellness management.'), findsOneWidget);
      
      // Verify Get Started button is displayed
      expect(find.text('Get Started'), findsOneWidget);
    });

    testWidgets('navigates to goal setting screen when Get Started is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const WelcomeScreen(),
          routes: {
            GoalSettingScreen.routeName: (context) => const GoalSettingScreen(),
          },
        ),
      );

      // Tap the Get Started button
      await tester.tap(find.text('Get Started'));
      await tester.pumpAndSettle();

      // Verify navigation to goal setting screen
      expect(find.byType(GoalSettingScreen), findsOneWidget);
    });
  });
}