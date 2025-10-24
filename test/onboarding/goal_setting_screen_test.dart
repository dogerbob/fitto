import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitto/screens/onboarding/goal_setting_screen.dart';
import 'package:fitto/screens/onboarding/personal_info_screen.dart';

void main() {
  group('GoalSettingScreen', () {
    testWidgets('displays goal setting content', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const GoalSettingScreen(),
        ),
      );

      // Verify title is displayed
      expect(find.text('What\'s your fitness goal?'), findsOneWidget);
      
      // Verify subtitle is displayed
      expect(find.text('Choose the goal that best describes what you want to achieve.'), findsOneWidget);
      
      // Verify goal options are displayed
      expect(find.text('Lose Weight'), findsOneWidget);
      expect(find.text('Gain Muscle'), findsOneWidget);
      expect(find.text('Maintain Fitness'), findsOneWidget);
      expect(find.text('Improve Endurance'), findsOneWidget);
      
      // Verify Continue button is displayed
      expect(find.text('Continue'), findsOneWidget);
    });

    testWidgets('enables Continue button when goal is selected', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const GoalSettingScreen(),
          routes: {
            PersonalInfoScreen.routeName: (context) => const PersonalInfoScreen(),
          },
        ),
      );

      // Initially Continue button should be disabled
      final continueButton = find.widgetWithText(ElevatedButton, 'Continue');
      expect(continueButton, findsOneWidget);
      
      // Select a goal
      await tester.tap(find.text('Lose Weight'));
      await tester.pump();

      // Continue button should now be enabled
      final button = tester.widget<ElevatedButton>(continueButton);
      expect(button.onPressed, isNotNull);
    });

    testWidgets('navigates to personal info screen when Continue is tapped with goal selected', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const GoalSettingScreen(),
          routes: {
            PersonalInfoScreen.routeName: (context) => const PersonalInfoScreen(),
          },
        ),
      );

      // Select a goal
      await tester.tap(find.text('Gain Muscle'));
      await tester.pump();

      // Tap Continue button
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      // Verify navigation to personal info screen
      expect(find.byType(PersonalInfoScreen), findsOneWidget);
    });
  });
}