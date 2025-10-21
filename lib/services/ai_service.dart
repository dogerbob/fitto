import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:fitto/models/nutrition_entry.dart';

/// AI Service for handling meal recognition, suggestions, and nutrition analysis
class AIService {
  static const String _openaiApiKey = 'your-openai-api-key'; // Replace with actual API key
  static const String _openaiBaseUrl = 'https://api.openai.com/v1';
  
  final ImagePicker _imagePicker = ImagePicker();

  /// Recognize food items from an image using AI
  Future<List<NutritionEntry>> recognizeFoodFromImage(XFile image) async {
    try {
      // In a real implementation, you would:
      // 1. Send image to OpenAI Vision API or similar service
      // 2. Parse the response to extract food items and nutrition data
      // 3. Return structured nutrition entries
      
      // For now, return mock data based on common food recognition
      return _getMockFoodRecognition(image.name);
    } catch (e) {
      print('Error recognizing food: $e');
      return [];
    }
  }

  /// Get AI-powered meal suggestions based on user goals and preferences
  Future<List<Map<String, dynamic>>> getMealSuggestions({
    required int calorieGoal,
    required String mealType,
    required List<String> dietaryRestrictions,
    required String cuisinePreference,
  }) async {
    try {
      // In a real implementation, you would call OpenAI API
      // For now, return intelligent mock suggestions
      return _getMockMealSuggestions(calorieGoal, mealType, dietaryRestrictions, cuisinePreference);
    } catch (e) {
      print('Error getting meal suggestions: $e');
      return [];
    }
  }

  /// Analyze text input for food recognition
  Future<List<NutritionEntry>> recognizeFoodFromText(String text) async {
    try {
      // In a real implementation, you would use OpenAI's text analysis
      // For now, return mock data based on common food text patterns
      return _getMockTextRecognition(text);
    } catch (e) {
      print('Error recognizing food from text: $e');
      return [];
    }
  }

  /// Get personalized nutrition insights and recommendations
  Future<Map<String, dynamic>> getNutritionInsights({
    required List<NutritionEntry> recentEntries,
    required int calorieGoal,
    required Map<String, double> macroGoals,
  }) async {
    try {
      // Analyze recent nutrition data and provide insights
      return _analyzeNutritionData(recentEntries, calorieGoal, macroGoals);
    } catch (e) {
      print('Error getting nutrition insights: $e');
      return {};
    }
  }

  /// Get AI-powered workout suggestions based on nutrition and goals
  Future<List<Map<String, dynamic>>> getWorkoutSuggestions({
    required int caloriesConsumed,
    required int calorieGoal,
    required String fitnessLevel,
    required List<String> availableEquipment,
  }) async {
    try {
      return _getMockWorkoutSuggestions(caloriesConsumed, calorieGoal, fitnessLevel, availableEquipment);
    } catch (e) {
      print('Error getting workout suggestions: $e');
      return [];
    }
  }

  /// Generate personalized daily motivation and tips
  Future<String> getDailyMotivation({
    required int caloriesConsumed,
    required int calorieGoal,
    required int waterIntake,
    required int waterGoal,
    required String userMood,
  }) async {
    try {
      return _generatePersonalizedMotivation(caloriesConsumed, calorieGoal, waterIntake, waterGoal, userMood);
    } catch (e) {
      print('Error generating motivation: $e');
      return "Keep up the great work! Every small step counts towards your goals.";
    }
  }

  // Mock implementations for demonstration
  List<NutritionEntry> _getMockFoodRecognition(String imageName) {
    final now = DateTime.now();
    final commonFoods = {
      'apple': NutritionEntry(
        id: 'ai_${now.millisecondsSinceEpoch}',
        userId: 'user_1',
        date: now,
        mealType: 'Snacks',
        name: 'Apple',
        calories: 95,
        protein: 0.5,
        carbs: 25,
        fats: 0.3,
        servingSize: '1 medium',
        createdAt: now,
        updatedAt: now,
      ),
      'banana': NutritionEntry(
        id: 'ai_${now.millisecondsSinceEpoch + 1}',
        userId: 'user_1',
        date: now,
        mealType: 'Snacks',
        name: 'Banana',
        calories: 105,
        protein: 1.3,
        carbs: 27,
        fats: 0.4,
        servingSize: '1 medium',
        createdAt: now,
        updatedAt: now,
      ),
      'salad': NutritionEntry(
        id: 'ai_${now.millisecondsSinceEpoch + 2}',
        userId: 'user_1',
        date: now,
        mealType: 'Lunch',
        name: 'Mixed Green Salad',
        calories: 150,
        protein: 8,
        carbs: 12,
        fats: 8,
        servingSize: '1 bowl',
        createdAt: now,
        updatedAt: now,
      ),
    };

    // Simple pattern matching for demo
    for (final entry in commonFoods.entries) {
      if (imageName.toLowerCase().contains(entry.key)) {
        return [entry.value];
      }
    }

    // Default fallback
    return [commonFoods['apple']!];
  }

  List<Map<String, dynamic>> _getMockMealSuggestions(
    int calorieGoal,
    String mealType,
    List<String> dietaryRestrictions,
    String cuisinePreference,
  ) {
    final suggestions = {
      'Breakfast': [
        {
          'name': 'Avocado Toast with Eggs',
          'calories': 350,
          'protein': 18,
          'carbs': 25,
          'fats': 22,
          'description': 'Whole grain toast with smashed avocado and poached eggs',
          'prepTime': '10 minutes',
          'difficulty': 'Easy',
        },
        {
          'name': 'Greek Yogurt Parfait',
          'calories': 280,
          'protein': 20,
          'carbs': 35,
          'fats': 8,
          'description': 'Greek yogurt with berries, granola, and honey',
          'prepTime': '5 minutes',
          'difficulty': 'Easy',
        },
      ],
      'Lunch': [
        {
          'name': 'Quinoa Buddha Bowl',
          'calories': 420,
          'protein': 22,
          'carbs': 45,
          'fats': 18,
          'description': 'Quinoa with roasted vegetables, chickpeas, and tahini dressing',
          'prepTime': '20 minutes',
          'difficulty': 'Medium',
        },
        {
          'name': 'Grilled Chicken Wrap',
          'calories': 380,
          'protein': 28,
          'carbs': 32,
          'fats': 16,
          'description': 'Whole wheat wrap with grilled chicken, vegetables, and hummus',
          'prepTime': '15 minutes',
          'difficulty': 'Easy',
        },
      ],
      'Dinner': [
        {
          'name': 'Salmon with Sweet Potato',
          'calories': 450,
          'protein': 35,
          'carbs': 30,
          'fats': 22,
          'description': 'Baked salmon with roasted sweet potato and steamed broccoli',
          'prepTime': '25 minutes',
          'difficulty': 'Medium',
        },
        {
          'name': 'Vegetarian Stir Fry',
          'calories': 320,
          'protein': 15,
          'carbs': 40,
          'fats': 12,
          'description': 'Mixed vegetables stir-fried with tofu and brown rice',
          'prepTime': '15 minutes',
          'difficulty': 'Easy',
        },
      ],
    };

    return suggestions[mealType] ?? [];
  }

  List<NutritionEntry> _getMockTextRecognition(String text) {
    final now = DateTime.now();
    final textLower = text.toLowerCase();
    
    if (textLower.contains('apple')) {
      return [_getMockFoodRecognition('apple')[0]];
    } else if (textLower.contains('banana')) {
      return [_getMockFoodRecognition('banana')[0]];
    } else if (textLower.contains('salad')) {
      return [_getMockFoodRecognition('salad')[0]];
    }
    
    return [];
  }

  Map<String, dynamic> _analyzeNutritionData(
    List<NutritionEntry> recentEntries,
    int calorieGoal,
    Map<String, double> macroGoals,
  ) {
    final totalCalories = recentEntries.fold(0, (sum, entry) => sum + entry.calories);
    final totalProtein = recentEntries.fold(0.0, (sum, entry) => sum + entry.protein);
    final totalCarbs = recentEntries.fold(0.0, (sum, entry) => sum + entry.carbs);
    final totalFats = recentEntries.fold(0.0, (sum, entry) => sum + entry.fats);

    final calorieProgress = (totalCalories / calorieGoal * 100).clamp(0.0, 100.0);
    final proteinProgress = (totalProtein / macroGoals['protein']! * 100).clamp(0.0, 100.0);
    final carbProgress = (totalCarbs / macroGoals['carbs']! * 100).clamp(0.0, 100.0);
    final fatProgress = (totalFats / macroGoals['fats']! * 100).clamp(0.0, 100.0);

    return {
      'calorieProgress': calorieProgress,
      'proteinProgress': proteinProgress,
      'carbProgress': carbProgress,
      'fatProgress': fatProgress,
      'insights': _generateInsights(calorieProgress, proteinProgress, carbProgress, fatProgress),
      'recommendations': _generateRecommendations(calorieProgress, proteinProgress, carbProgress, fatProgress),
    };
  }

  List<String> _generateInsights(double calorieProgress, double proteinProgress, double carbProgress, double fatProgress) {
    final insights = <String>[];
    
    if (calorieProgress < 80) {
      insights.add('You\'re below your calorie goal. Consider adding a healthy snack!');
    } else if (calorieProgress > 120) {
      insights.add('You\'ve exceeded your calorie goal. Try lighter options for your next meal.');
    }
    
    if (proteinProgress < 70) {
      insights.add('Your protein intake is low. Add lean proteins like chicken, fish, or legumes.');
    }
    
    if (carbProgress > 120) {
      insights.add('High carb intake detected. Consider balancing with more vegetables.');
    }
    
    return insights;
  }

  List<String> _generateRecommendations(double calorieProgress, double proteinProgress, double carbProgress, double fatProgress) {
    final recommendations = <String>[];
    
    if (proteinProgress < 80) {
      recommendations.add('Try adding Greek yogurt or nuts to your next meal');
    }
    
    if (fatProgress < 60) {
      recommendations.add('Include healthy fats like avocado or olive oil');
    }
    
    if (calorieProgress < 90) {
      recommendations.add('Consider a protein smoothie or energy bar');
    }
    
    return recommendations;
  }

  List<Map<String, dynamic>> _getMockWorkoutSuggestions(
    int caloriesConsumed,
    int calorieGoal,
    String fitnessLevel,
    List<String> availableEquipment,
  ) {
    final calorieBalance = calorieGoal - caloriesConsumed;
    
    if (calorieBalance > 300) {
      return [
        {
          'name': 'High-Intensity Cardio',
          'duration': '30 minutes',
          'caloriesBurned': 300,
          'difficulty': 'High',
          'equipment': ['None'],
          'description': 'HIIT workout to burn excess calories',
        },
      ];
    } else if (calorieBalance < -200) {
      return [
        {
          'name': 'Light Yoga',
          'duration': '20 minutes',
          'caloriesBurned': 100,
          'difficulty': 'Low',
          'equipment': ['Yoga mat'],
          'description': 'Gentle yoga to maintain fitness without overexertion',
        },
      ];
    } else {
      return [
        {
          'name': 'Balanced Strength Training',
          'duration': '45 minutes',
          'caloriesBurned': 200,
          'difficulty': 'Medium',
          'equipment': ['Dumbbells', 'Resistance bands'],
          'description': 'Full-body strength workout for balanced fitness',
        },
      ];
    }
  }

  String _generatePersonalizedMotivation(
    int caloriesConsumed,
    int calorieGoal,
    int waterIntake,
    int waterGoal,
    String userMood,
  ) {
    final calorieProgress = (caloriesConsumed / calorieGoal * 100).clamp(0, 100);
    final waterProgress = (waterIntake / waterGoal * 100).clamp(0, 100);
    
    if (calorieProgress >= 90 && waterProgress >= 80) {
      return "Amazing work! You're crushing your nutrition goals today! 🎉";
    } else if (calorieProgress < 50) {
      return "Don't worry about being behind on calories - every meal is a fresh start! 💪";
    } else if (waterProgress < 50) {
      return "Remember to stay hydrated! Your body will thank you for every glass of water! 💧";
    } else {
      return "You're doing great! Consistency is key to reaching your goals! 🌟";
    }
  }
}