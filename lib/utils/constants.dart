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
      colors: [Color(0xFFFF8A65), Color(0xFFFFAB91)], // Soft orange to warm coral
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      colors: [Color(0xFFFFAB91), Color(0xFFFFCC80)], // Warm coral to soft cream
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      colors: [Color(0xFFFFCC80), Color(0xFFFFD54F)], // Soft cream to warm yellow
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      colors: [Color(0xFFFFD54F), Color(0xFFFF8A65)], // Warm yellow to soft orange
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  ];
}
