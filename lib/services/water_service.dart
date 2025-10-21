import 'package:fitto/services/storage_service.dart';
import 'package:fitto/services/notification_service.dart';

/// Service for tracking water intake with AI-powered reminders
class WaterService {
  final StorageService _storage = StorageService();
  final NotificationService _notificationService = NotificationService();
  
  static const String _waterKey = 'water_entries';
  static const int _defaultDailyGoal = 8; // 8 glasses (64 oz)
  
  List<Map<String, dynamic>> _waterEntries = [];
  int _dailyGoal = _defaultDailyGoal;
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;
    
    await _loadWaterEntries();
    await _loadDailyGoal();
    await _setupWaterReminders();
    _isInitialized = true;
  }

  Future<void> _loadWaterEntries() async {
    final entries = await _storage.getList(_waterKey);
    _waterEntries = List<Map<String, dynamic>>.from(entries);
  }

  Future<void> _loadDailyGoal() async {
    _dailyGoal = await _storage.getInt('water_daily_goal') ?? _defaultDailyGoal;
  }

  Future<void> _saveWaterEntries() async {
    await _storage.saveList(_waterKey, _waterEntries);
  }

  Future<void> _saveDailyGoal() async {
    await _storage.saveInt('water_daily_goal', _dailyGoal);
  }

  Future<void> _setupWaterReminders() async {
    // Schedule water reminders throughout the day
    await _notificationService.scheduleWaterReminders();
  }

  /// Add water intake entry
  Future<void> addWaterIntake({
    required int amount, // in ounces
    String? note,
  }) async {
    final now = DateTime.now();
    final entry = {
      'id': 'water_${now.millisecondsSinceEpoch}',
      'amount': amount,
      'note': note ?? '',
      'timestamp': now.toIso8601String(),
      'date': now.toIso8601String().split('T')[0], // YYYY-MM-DD format
    };
    
    _waterEntries.add(entry);
    await _saveWaterEntries();
    
    // Check if goal is reached and send celebration
    if (getTodayIntake() >= _dailyGoal) {
      await _notificationService.showWaterGoalAchieved();
    }
  }

  /// Get water intake for a specific date
  int getWaterIntakeByDate(DateTime date) {
    final dateStr = date.toIso8601String().split('T')[0];
    return _waterEntries
        .where((entry) => entry['date'] == dateStr)
        .fold(0, (sum, entry) => sum + (entry['amount'] as int));
  }

  /// Get today's water intake
  int getTodayIntake() {
    return getWaterIntakeByDate(DateTime.now());
  }

  /// Get water intake progress percentage
  double getWaterProgress() {
    final todayIntake = getTodayIntake();
    return (todayIntake / _dailyGoal).clamp(0.0, 1.0);
  }

  /// Get remaining water needed today
  int getRemainingWater() {
    final todayIntake = getTodayIntake();
    return (_dailyGoal - todayIntake).clamp(0, _dailyGoal);
  }

  /// Update daily water goal
  Future<void> updateDailyGoal(int newGoal) async {
    _dailyGoal = newGoal;
    await _saveDailyGoal();
  }

  /// Get daily water goal
  int get dailyGoal => _dailyGoal;

  /// Get water intake history for the last N days
  List<Map<String, dynamic>> getWaterHistory(int days) {
    final now = DateTime.now();
    final history = <Map<String, dynamic>>[];
    
    for (int i = 0; i < days; i++) {
      final date = now.subtract(Duration(days: i));
      final intake = getWaterIntakeByDate(date);
      history.add({
        'date': date,
        'intake': intake,
        'goal': _dailyGoal,
        'progress': (intake / _dailyGoal).clamp(0.0, 1.0),
      });
    }
    
    return history.reversed.toList();
  }

  /// Get AI-powered water intake recommendations
  Map<String, dynamic> getWaterRecommendations() {
    final todayIntake = getTodayIntake();
    final currentHour = DateTime.now().hour;
    final progress = getWaterProgress();
    
    String recommendation = '';
    String tip = '';
    
    if (progress < 0.3) {
      recommendation = 'You\'re behind on your water intake today. Try to catch up!';
      tip = 'Start with a large glass of water and set hourly reminders.';
    } else if (progress < 0.6) {
      recommendation = 'Good progress! Keep drinking water throughout the day.';
      tip = 'Try adding lemon or cucumber for flavor variety.';
    } else if (progress < 0.9) {
      recommendation = 'Almost there! You\'re doing great with hydration.';
      tip = 'Consider having a glass before each meal.';
    } else {
      recommendation = 'Excellent! You\'ve reached your water goal!';
      tip = 'Keep up this great habit for optimal health.';
    }
    
    // Time-based recommendations
    if (currentHour < 10 && todayIntake < 2) {
      tip += ' Start your day with a big glass of water!';
    } else if (currentHour > 18 && todayIntake < _dailyGoal * 0.8) {
      tip += ' You still have time to reach your goal today!';
    }
    
    return {
      'recommendation': recommendation,
      'tip': tip,
      'currentIntake': todayIntake,
      'goal': _dailyGoal,
      'progress': progress,
      'remaining': getRemainingWater(),
    };
  }

  /// Get water intake trends
  Map<String, dynamic> getWaterTrends() {
    final history = getWaterHistory(7);
    final avgIntake = history.fold(0, (sum, day) => sum + (day['intake'] as int)) / history.length;
    final consistency = history.where((day) => (day['intake'] as int) >= _dailyGoal).length / history.length;
    
    return {
      'averageIntake': avgIntake.round(),
      'consistency': consistency,
      'trend': _calculateTrend(history),
      'bestDay': history.isNotEmpty ? history.reduce((a, b) => a['intake'] > b['intake'] ? a : b) : null,
    };
  }

  String _calculateTrend(List<Map<String, dynamic>> history) {
    if (history.length < 2) return 'stable';
    
    final recent = history.take(3).fold(0, (sum, day) => sum + (day['intake'] as int)) / 3;
    final older = history.skip(3).fold(0, (sum, day) => sum + (day['intake'] as int)) / (history.length - 3);
    
    if (recent > older * 1.1) return 'increasing';
    if (recent < older * 0.9) return 'decreasing';
    return 'stable';
  }

  /// Delete a water entry
  Future<void> deleteWaterEntry(String id) async {
    _waterEntries.removeWhere((entry) => entry['id'] == id);
    await _saveWaterEntries();
  }

  /// Get all water entries for a date
  List<Map<String, dynamic>> getWaterEntriesByDate(DateTime date) {
    final dateStr = date.toIso8601String().split('T')[0];
    return _waterEntries
        .where((entry) => entry['date'] == dateStr)
        .toList();
  }
}