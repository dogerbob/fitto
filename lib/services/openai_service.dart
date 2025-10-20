import 'package:fitto/utils/api_placeholders.dart';

class OpenAIService {
  static Future<String> getAICoachResponse(String message) async {
    final prompt = '''
You are a fitness coach AI assistant. The user asked: "$message"

Provide helpful, motivating fitness advice.
''';

    return await ApiPlaceholders.getAIResponse(prompt);
  }

  static Future<String> getWorkoutSuggestion({
    required String fitnessLevel,
    required String goal,
    required int availableMinutes,
  }) async {
    final prompt = '''
Create a workout plan with these parameters:
- Fitness Level: $fitnessLevel
- Goal: $goal
- Available Time: $availableMinutes minutes

Provide a structured workout plan with exercises, sets, reps, and duration.
''';

    return await ApiPlaceholders.getAIResponse(prompt);
  }
}
