import 'package:fitto/models/nutrition_entry.dart';
import 'package:fitto/services/storage_service.dart';
import 'package:fitto/services/ai_service.dart';
import 'package:fitto/services/database_service.dart';
import 'package:image_picker/image_picker.dart';

class NutritionService {
  final StorageService _storage = StorageService();
  final DatabaseService _database = DatabaseService();
  final AIService _aiService = AIService();
  final ImagePicker _imagePicker = ImagePicker();
  List<NutritionEntry> _entries = [];
  String _currentUserId = 'user_1'; // This should come from auth service

  Future<void> initialize() async {
    await _loadEntries();
    if (_entries.isEmpty) {
      await _createSampleEntries();
    }
  }

  Future<void> _loadEntries() async {
    try {
      _entries = await _database.getNutritionEntries(_currentUserId, null);
    } catch (e) {
      // Fallback to storage service if database fails
      final list = await _storage.getList(StorageService.nutritionKey);
      _entries = list.map((json) => NutritionEntry.fromJson(json)).toList();
    }
  }

  Future<void> _createSampleEntries() async {
    final now = DateTime.now();
    _entries = [
      NutritionEntry(id: '1', userId: 'user_1', date: now, mealType: 'Breakfast', name: 'Oatmeal with Berries', calories: 350, protein: 12, carbs: 58, fats: 8, servingSize: '1 bowl', createdAt: now, updatedAt: now),
      NutritionEntry(id: '2', userId: 'user_1', date: now, mealType: 'Lunch', name: 'Grilled Chicken Salad', calories: 420, protein: 35, carbs: 25, fats: 18, servingSize: '1 plate', createdAt: now, updatedAt: now),
      NutritionEntry(id: '3', userId: 'user_1', date: now, mealType: 'Snacks', name: 'Greek Yogurt', calories: 150, protein: 15, carbs: 12, fats: 5, servingSize: '1 cup', createdAt: now, updatedAt: now),
      NutritionEntry(id: '4', userId: 'user_1', date: now.subtract(Duration(days: 1)), mealType: 'Breakfast', name: 'Scrambled Eggs', calories: 280, protein: 20, carbs: 8, fats: 18, servingSize: '3 eggs', createdAt: now, updatedAt: now),
      NutritionEntry(id: '5', userId: 'user_1', date: now.subtract(Duration(days: 1)), mealType: 'Dinner', name: 'Salmon with Rice', calories: 550, protein: 38, carbs: 45, fats: 22, servingSize: '1 plate', createdAt: now, updatedAt: now),
    ];
    await _saveEntries();
  }

  Future<void> _saveEntries() async {
    try {
      // Save to database
      for (final entry in _entries) {
        await _database.insertNutritionEntry(entry);
      }
    } catch (e) {
      // Fallback to storage service if database fails
      await _storage.saveList(StorageService.nutritionKey, _entries.map((e) => e.toJson()).toList());
    }
  }

  List<NutritionEntry> get entries => _entries;

  Future<List<NutritionEntry>> getEntriesByDate(DateTime date) async {
    try {
      return await _database.getNutritionEntries(_currentUserId, date);
    } catch (e) {
      // Fallback to in-memory data
      return _entries.where((e) => e.date.year == date.year && e.date.month == date.month && e.date.day == date.day).toList();
    }
  }

  Future<List<NutritionEntry>> getEntriesByMealType(String mealType, DateTime date) async {
    try {
      return await _database.getNutritionEntriesByMealType(_currentUserId, mealType, date);
    } catch (e) {
      // Fallback to in-memory data
      final dayEntries = await getEntriesByDate(date);
      return dayEntries.where((e) => e.mealType == mealType).toList();
    }
  }

  Future<int> getTotalCaloriesByDate(DateTime date) async {
    try {
      return await _database.getTotalCaloriesByDate(_currentUserId, date);
    } catch (e) {
      // Fallback to in-memory calculation
      final dayEntries = await getEntriesByDate(date);
      return dayEntries.fold(0, (sum, entry) => sum + entry.calories);
    }
  }

  Future<Map<String, double>> getMacrosByDate(DateTime date) async {
    try {
      return await _database.getMacrosByDate(_currentUserId, date);
    } catch (e) {
      // Fallback to in-memory calculation
      final dayEntries = await getEntriesByDate(date);
      return {
        'protein': dayEntries.fold(0.0, (sum, entry) => sum + entry.protein),
        'carbs': dayEntries.fold(0.0, (sum, entry) => sum + entry.carbs),
        'fats': dayEntries.fold(0.0, (sum, entry) => sum + entry.fats),
      };
    }
  }

  Future<void> addEntry(NutritionEntry entry) async {
    try {
      await _database.insertNutritionEntry(entry);
      _entries.add(entry);
    } catch (e) {
      // Fallback to in-memory storage
      _entries.add(entry);
      await _saveEntries();
    }
  }

  Future<void> deleteEntry(String id) async {
    try {
      await _database.deleteNutritionEntry(id);
      _entries.removeWhere((e) => e.id == id);
    } catch (e) {
      // Fallback to in-memory storage
      _entries.removeWhere((e) => e.id == id);
      await _saveEntries();
    }
  }

  /// AI-powered food recognition from image
  Future<List<NutritionEntry>> recognizeFoodFromImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      
      if (image != null) {
        final recognizedFoods = await _aiService.recognizeFoodFromImage(image);
        for (final food in recognizedFoods) {
          await addEntry(food);
        }
        return recognizedFoods;
      }
      return [];
    } catch (e) {
      // print('Error recognizing food from image: $e');
      return [];
    }
  }

  /// AI-powered food recognition from text
  Future<List<NutritionEntry>> recognizeFoodFromText(String text) async {
    try {
      final recognizedFoods = await _aiService.recognizeFoodFromText(text);
      for (final food in recognizedFoods) {
        await addEntry(food);
      }
      return recognizedFoods;
    } catch (e) {
      // print('Error recognizing food from text: $e');
      return [];
    }
  }

  /// Get AI-powered meal suggestions
  Future<List<Map<String, dynamic>>> getMealSuggestions({
    required String mealType,
    required int calorieGoal,
    List<String> dietaryRestrictions = const [],
    String cuisinePreference = 'Any',
  }) async {
    try {
      return await _aiService.getMealSuggestions(
        calorieGoal: calorieGoal,
        mealType: mealType,
        dietaryRestrictions: dietaryRestrictions,
        cuisinePreference: cuisinePreference,
      );
    } catch (e) {
      // print('Error getting meal suggestions: $e');
      return [];
    }
  }

  /// Get nutrition insights and recommendations
  Future<Map<String, dynamic>> getNutritionInsights({
    required int calorieGoal,
    required Map<String, double> macroGoals,
  }) async {
    try {
      final recentEntries = getEntriesByDate(DateTime.now());
      return await _aiService.getNutritionInsights(
        recentEntries: recentEntries,
        calorieGoal: calorieGoal,
        macroGoals: macroGoals,
      );
    } catch (e) {
      // print('Error getting nutrition insights: $e');
      return {};
    }
  }

  /// Add meal from AI suggestion
  Future<void> addMealFromSuggestion(Map<String, dynamic> suggestion, String mealType) async {
    try {
      final now = DateTime.now();
      final entry = NutritionEntry(
        id: 'suggestion_${now.millisecondsSinceEpoch}',
        userId: 'user_1',
        date: now,
        mealType: mealType,
        name: suggestion['name'] ?? 'Suggested Meal',
        calories: (suggestion['calories'] ?? 0).toInt(),
        protein: (suggestion['protein'] ?? 0.0).toDouble(),
        carbs: (suggestion['carbs'] ?? 0.0).toDouble(),
        fats: (suggestion['fats'] ?? 0.0).toDouble(),
        servingSize: '1 serving',
        createdAt: now,
        updatedAt: now,
      );
      await addEntry(entry);
    } catch (e) {
      // print('Error adding meal from suggestion: $e');
    }
  }

  /// Get daily nutrition summary with AI insights
  Map<String, dynamic> getDailySummary(DateTime date) {
    final dayEntries = getEntriesByDate(date);
    final totalCalories = dayEntries.fold(0, (sum, entry) => sum + entry.calories);
    final macros = getMacrosByDate(date);
    
    return {
      'totalCalories': totalCalories,
      'macros': macros,
      'mealCount': dayEntries.length,
      'entries': dayEntries,
    };
  }
}
