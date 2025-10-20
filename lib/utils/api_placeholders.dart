class ApiPlaceholders {
  static Future<String> getAIResponse(String prompt) async {
    await Future.delayed(Duration(seconds: 2));

    return 'AI Response Placeholder: This is where the OpenAI API response would appear. The prompt was: "$prompt"';
  }

  static Future<Map<String, dynamic>> generateAIWorkoutSuggestion({
    required String userLevel,
    required String goal,
    required List<String> preferences,
  }) async {
    await Future.delayed(Duration(seconds: 2));
    return {
      'success': true,
      'workout': {
        'name': 'AI Generated Workout',
        'exercises': [
          {'name': 'Push-ups', 'sets': 3, 'reps': 15},
          {'name': 'Squats', 'sets': 4, 'reps': 12},
          {'name': 'Plank', 'sets': 3, 'duration': 45},
        ],
        'estimatedDuration': 30,
      }
    };
  }

  static Future<Map<String, dynamic>> recognizeFood(String imagePath) async {
    await Future.delayed(Duration(seconds: 2));
    return {
      'success': true,
      'food': {
        'name': 'Grilled Chicken Salad',
        'calories': 350,
        'protein': 35.0,
        'carbs': 15.0,
        'fats': 12.0,
        'servingSize': '1 bowl',
      }
    };
  }

  static Future<String> getAICoachResponse(String userMessage) async {
    await Future.delayed(Duration(seconds: 1));
    
    final responses = [
      'Great question! Remember, consistency is key to achieving your fitness goals. Keep pushing forward!',
      'You\'re doing amazing! Every workout counts, no matter how small. Stay dedicated!',
      'Nutrition is 80% of the battle. Make sure you\'re fueling your body with quality foods.',
      'Rest and recovery are just as important as training. Listen to your body!',
      'Setting small, achievable goals will help you stay motivated on your journey.',
    ];
    
    return responses[DateTime.now().second % responses.length];
  }

  static Future<Map<String, dynamic>> socialSignIn(String provider) async {
    await Future.delayed(Duration(seconds: 2));
    return {
      'success': true,
      'user': {
        'id': 'user_${DateTime.now().millisecondsSinceEpoch}',
        'name': 'John Doe',
        'email': 'john.doe@example.com',
        'provider': provider,
      }
    };
  }

  static Future<bool> processPayment({
    required String planId,
    required String userId,
  }) async {
    await Future.delayed(Duration(seconds: 2));
    return true;
  }
}
