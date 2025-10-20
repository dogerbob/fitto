import 'package:flutter/material.dart';
import 'package:fitto/services/auth_service.dart';
import 'package:fitto/services/nutrition_service.dart';
import 'package:fitto/services/progress_service.dart';
import 'package:fitto/services/coach_service.dart';
import 'package:fitto/models/nutrition_entry.dart';
import 'package:fitto/models/progress_entry.dart';

class AppStateProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final NutritionService _nutritionService = NutritionService();
  final ProgressService _progressService = ProgressService();
  final CoachService _coachService = CoachService();

  bool _isInitialized = false;
  bool _isLoading = false;
  dynamic _currentUser;
  List<NutritionEntry> _nutritionEntries = [];
  int _waterGlasses = 0;
  int _steps = 0;
  String _dailyMotivation = '';

  // Getters
  bool get isInitialized => _isInitialized;
  bool get isLoading => _isLoading;
  dynamic get currentUser => _currentUser;
  List<NutritionEntry> get nutritionEntries => _nutritionEntries;
  int get waterGlasses => _waterGlasses;
  int get steps => _steps;
  String get dailyMotivation => _dailyMotivation;

  // Initialize all services
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    _setLoading(true);
    
    try {
      await Future.wait([
        _authService.initialize(),
        _nutritionService.initialize(),
        _progressService.initialize(),
        _coachService.initialize(),
      ]);
      
      _currentUser = _authService.currentUser;
      _nutritionEntries = _nutritionService.entries;
      _waterGlasses = _progressService.getLatestEntryByType('water')?.value.toInt() ?? 0;
      _steps = _progressService.getLatestEntryByType('steps')?.value.toInt() ?? 0;
      _dailyMotivation = _coachService.getDailyMotivation();
      
      _isInitialized = true;
    } catch (e) {
      debugPrint('Error initializing app state: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Nutrition methods
  Future<void> addNutritionEntry(NutritionEntry entry) async {
    await _nutritionService.addEntry(entry);
    _nutritionEntries = _nutritionService.entries;
    notifyListeners();
  }

  Future<void> deleteNutritionEntry(String id) async {
    await _nutritionService.deleteEntry(id);
    _nutritionEntries = _nutritionService.entries;
    notifyListeners();
  }

  int getTotalCaloriesByDate(DateTime date) {
    return _nutritionService.getTotalCaloriesByDate(date);
  }

  Map<String, double> getMacrosByDate(DateTime date) {
    return _nutritionService.getMacrosByDate(date);
  }

  List<NutritionEntry> getEntriesByMealType(String mealType, DateTime date) {
    return _nutritionService.getEntriesByMealType(mealType, date);
  }

  // Water tracking methods
  Future<void> addWaterGlass() async {
    _waterGlasses++;
      await _progressService.addEntry(ProgressEntry(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: _currentUser?.id ?? 'user_1',
        date: DateTime.now(),
        type: 'water',
        value: _waterGlasses.toDouble(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ));
    notifyListeners();
  }

  Future<void> removeWaterGlass() async {
    if (_waterGlasses > 0) {
      _waterGlasses--;
      await _progressService.addEntry(ProgressEntry(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: _currentUser?.id ?? 'user_1',
        date: DateTime.now(),
        type: 'water',
        value: _waterGlasses.toDouble(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ));
      notifyListeners();
    }
  }

  Future<void> resetWaterIntake() async {
    _waterGlasses = 0;
    await _progressService.addEntry(ProgressEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: _currentUser?.id ?? 'user_1',
      date: DateTime.now(),
      type: 'water',
      value: 0.0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ));
    notifyListeners();
  }

  // Steps tracking methods
  Future<void> updateSteps(int steps) async {
    _steps = steps;
    await _progressService.addEntry(ProgressEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: _currentUser?.id ?? 'user_1',
      date: DateTime.now(),
      type: 'steps',
      value: steps.toDouble(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ));
    notifyListeners();
  }

  // Coach methods
  Future<void> sendCoachMessage(String message) async {
    await _coachService.sendMessage(message);
    notifyListeners();
  }

  List<dynamic> get coachMessages => _coachService.messages;

  // Utility methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void refreshData() {
    _nutritionEntries = _nutritionService.entries;
    _waterGlasses = _progressService.getLatestEntryByType('water')?.value.toInt() ?? 0;
    _steps = _progressService.getLatestEntryByType('steps')?.value.toInt() ?? 0;
    _dailyMotivation = _coachService.getDailyMotivation();
    notifyListeners();
  }
}