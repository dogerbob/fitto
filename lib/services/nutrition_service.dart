import 'package:fitto/models/nutrition_entry.dart';
import 'package:fitto/services/storage_service.dart';

class NutritionService {
  final StorageService _storage = StorageService();
  List<NutritionEntry> _entries = [];

  Future<void> initialize() async {
    await _loadEntries();
    if (_entries.isEmpty) {
      await _createSampleEntries();
    }
  }

  Future<void> _loadEntries() async {
    final list = await _storage.getList(StorageService.nutritionKey);
    _entries = list.map((json) => NutritionEntry.fromJson(json)).toList();
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
    await _storage.saveList(StorageService.nutritionKey, _entries.map((e) => e.toJson()).toList());
  }

  List<NutritionEntry> get entries => _entries;

  List<NutritionEntry> getEntriesByDate(DateTime date) => _entries.where((e) => e.date.year == date.year && e.date.month == date.month && e.date.day == date.day).toList();

  List<NutritionEntry> getEntriesByMealType(String mealType, DateTime date) => getEntriesByDate(date).where((e) => e.mealType == mealType).toList();

  int getTotalCaloriesByDate(DateTime date) {
    final dayEntries = getEntriesByDate(date);
    return dayEntries.fold(0, (sum, entry) => sum + entry.calories);
  }

  Map<String, double> getMacrosByDate(DateTime date) {
    final dayEntries = getEntriesByDate(date);
    return {
      'protein': dayEntries.fold(0.0, (sum, entry) => sum + entry.protein),
      'carbs': dayEntries.fold(0.0, (sum, entry) => sum + entry.carbs),
      'fats': dayEntries.fold(0.0, (sum, entry) => sum + entry.fats),
    };
  }

  Future<void> addEntry(NutritionEntry entry) async {
    _entries.add(entry);
    await _saveEntries();
  }

  Future<void> deleteEntry(String id) async {
    _entries.removeWhere((e) => e.id == id);
    await _saveEntries();
  }
}
