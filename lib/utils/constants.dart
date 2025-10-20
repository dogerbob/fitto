import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = 'Fitto';
  
  static const List<String> exerciseCategories = [
    'Strength',
    'Cardio',
    'Flexibility',
    'Sports',
  ];

  static const List<String> mealTypes = [
    'Breakfast',
    'Lunch',
    'Dinner',
    'Snacks',
  ];

  static const List<String> progressTypes = [
    'weight',
    'water',
    'steps',
  ];

  static List<LinearGradient> gradients = [
    LinearGradient(
      colors: [Color(0xFFFFB4C8), Color(0xFFE8C5E5)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      colors: [Color(0xFFA8D8EA), Color(0xFF7FBFD4)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      colors: [Color(0xFFE8C5E5), Color(0xFFD4A5D1)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      colors: [Color(0xFFFFEAA7), Color(0xFFFFD97D)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  ];
}
