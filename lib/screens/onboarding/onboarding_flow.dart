import 'package:flutter/material.dart';
import 'package:fitto/helpers/shared_preferences.dart';
import 'package:fitto/screens/home_tabs_screen.dart';
import 'welcome_screen.dart';
import 'goal_setting_screen.dart';
import 'personal_info_screen.dart';
import 'preferences_screen.dart';

class OnboardingFlow extends StatelessWidget {
  static const String routeName = '/onboarding';
  
  const OnboardingFlow({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitto Onboarding',
      theme: Theme.of(context),
      home: const OnboardingNavigator(),
      routes: {
        WelcomeScreen.routeName: (context) => const WelcomeScreen(),
        GoalSettingScreen.routeName: (context) => const GoalSettingScreen(),
        PersonalInfoScreen.routeName: (context) => const PersonalInfoScreen(),
        PreferencesScreen.routeName: (context) => const PreferencesScreen(),
      },
    );
  }
}

class OnboardingNavigator extends StatelessWidget {
  const OnboardingNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return const WelcomeScreen();
  }
}

class OnboardingManager {
  static Future<bool> shouldShowOnboarding() async {
    try {
      final completed = await PreferenceHelper.asyncPref.getBool('onboarding_completed');
      return completed != true;
    } catch (e) {
      // If there's an error reading preferences, show onboarding
      return true;
    }
  }

  static Future<void> markOnboardingCompleted() async {
    await PreferenceHelper.asyncPref.setBool('onboarding_completed', true);
  }
}