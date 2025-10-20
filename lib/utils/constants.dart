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
      colors: [Color(0xFFFF6B6B), Color(0xFFFF9F43)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      colors: [Color(0xFFFF9F43), Color(0xFFFFA726)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      colors: [Color(0xFFFFA726), Color(0xFFFFB84D)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      colors: [Color(0xFFFF7E67), Color(0xFFFFC947)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  ];
}
