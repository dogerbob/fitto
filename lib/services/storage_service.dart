import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _userKey = 'user';
  static const String _workoutsKey = 'workouts';
  static const String _exercisesKey = 'exercises';
  static const String _nutritionKey = 'nutrition';
  static const String _progressKey = 'progress';
  static const String _chatMessagesKey = 'chat_messages';
  static const String _localeKey = 'locale';
  static const String _themeModeKey = 'theme_mode';

  Future<void> saveString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  Future<String?> getString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  Future<void> saveJson(String key, Map<String, dynamic> json) async {
    await saveString(key, jsonEncode(json));
  }

  Future<Map<String, dynamic>?> getJson(String key) async {
    final str = await getString(key);
    if (str == null) return null;
    return jsonDecode(str) as Map<String, dynamic>;
  }

  Future<void> saveList(String key, List<Map<String, dynamic>> list) async {
    await saveString(key, jsonEncode(list));
  }

  Future<List<Map<String, dynamic>>> getList(String key) async {
    final str = await getString(key);
    if (str == null) return [];
    final decoded = jsonDecode(str) as List<dynamic>;
    return decoded.map((e) => e as Map<String, dynamic>).toList();
  }

  Future<void> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static String get userKey => _userKey;
  static String get workoutsKey => _workoutsKey;
  static String get exercisesKey => _exercisesKey;
  static String get nutritionKey => _nutritionKey;
  static String get progressKey => _progressKey;
  static String get chatMessagesKey => _chatMessagesKey;
  static String get localeKey => _localeKey;
  static String get themeModeKey => _themeModeKey;
}
