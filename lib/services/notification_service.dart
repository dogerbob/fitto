import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService._internal();
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  static const int _dailyReminderId = 1001;
  static const int _workoutPromptId = 1002;
  static const int _waterReminderId = 1003;
  static const int _mealReminderId = 1004;
  static const int _waterGoalAchievedId = 1005;

  Future<void> initialize() async {
    if (_initialized) return;

    if (!kIsWeb) {
      tz.initializeTimeZones();
      final String timeZoneName = tz.local.name; // tz is already configured with local
      tz.setLocalLocation(tz.getLocation(timeZoneName));
    }

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();
    const initSettings = InitializationSettings(android: androidInit, iOS: iosInit);

    await _plugin.initialize(initSettings);

    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      await requestPermissions();
    }

    _initialized = true;
  }

  Future<void> requestPermissions() async {
    if (kIsWeb) return; // Web: no-op here
    if (Platform.isAndroid) {
      final details = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      await details?.requestNotificationsPermission();
    } else if (Platform.isIOS) {
      final details = _plugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
      await details?.requestPermissions(alert: true, badge: true, sound: true);
    }
  }

  Future<void> scheduleDailyReminder(TimeOfDay time) async {
    if (kIsWeb) return; // Web fallback not implemented
    final androidDetails = AndroidNotificationDetails(
      'daily_reminders',
      'Daily Reminders',
      channelDescription: 'Daily motivational reminders from Fitto',
      importance: Importance.max,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();
    final details = NotificationDetails(android: androidDetails, iOS: iosDetails);

    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, time.hour, time.minute);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    await _plugin.zonedSchedule(
      _dailyReminderId,
      'Stay on track with Fitto',
      'It\'s time for your daily check-in!',
      scheduled,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> scheduleWorkoutPrompt(TimeOfDay time) async {
    if (kIsWeb) return;
    final androidDetails = AndroidNotificationDetails(
      'workout_prompts',
      'Workout Prompts',
      channelDescription: 'Daily workout prompts from Fitto',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );
    const iosDetails = DarwinNotificationDetails();
    final details = NotificationDetails(android: androidDetails, iOS: iosDetails);

    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, time.hour, time.minute);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    await _plugin.zonedSchedule(
      _workoutPromptId,
      'Quick workout time',
      'A short session beats no session. Ready to move?',
      scheduled,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> cancelDailyReminder() async {
    await _plugin.cancel(_dailyReminderId);
  }

  Future<void> cancelWorkoutPrompt() async {
    await _plugin.cancel(_workoutPromptId);
  }

  /// Schedule water intake reminders throughout the day
  Future<void> scheduleWaterReminders() async {
    if (kIsWeb) return;
    
    // Cancel existing water reminders
    await _plugin.cancel(_waterReminderId);
    
    final androidDetails = AndroidNotificationDetails(
      'water_reminders',
      'Water Intake Reminders',
      channelDescription: 'Gentle reminders to stay hydrated',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );
    const iosDetails = DarwinNotificationDetails();
    final details = NotificationDetails(android: androidDetails, iOS: iosDetails);

    final now = tz.TZDateTime.now(tz.local);
    final waterReminderTimes = [
      tz.TZDateTime(tz.local, now.year, now.month, now.day, 9, 0),   // 9 AM
      tz.TZDateTime(tz.local, now.year, now.month, now.day, 12, 0),  // 12 PM
      tz.TZDateTime(tz.local, now.year, now.month, now.day, 15, 0),  // 3 PM
      tz.TZDateTime(tz.local, now.year, now.month, now.day, 18, 0),  // 6 PM
    ];

    for (int i = 0; i < waterReminderTimes.length; i++) {
      var scheduled = waterReminderTimes[i];
      if (scheduled.isBefore(now)) {
        scheduled = scheduled.add(const Duration(days: 1));
      }

      final messages = [
        'Time for your morning hydration! 💧',
        'Lunch break = water break! Stay refreshed 🌟',
        'Afternoon pick-me-up: a glass of water! ⚡',
        'Evening hydration check! You\'re doing great! 🌙',
      ];

      await _plugin.zonedSchedule(
        _waterReminderId + i,
        'Stay Hydrated!',
        messages[i],
        scheduled,
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }
  }

  /// Schedule meal logging reminders
  Future<void> scheduleMealReminders() async {
    if (kIsWeb) return;
    
    await _plugin.cancel(_mealReminderId);
    
    final androidDetails = AndroidNotificationDetails(
      'meal_reminders',
      'Meal Logging Reminders',
      channelDescription: 'Reminders to log your meals',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );
    const iosDetails = DarwinNotificationDetails();
    final details = NotificationDetails(android: androidDetails, iOS: iosDetails);

    final now = tz.TZDateTime.now(tz.local);
    final mealTimes = [
      tz.TZDateTime(tz.local, now.year, now.month, now.day, 8, 0),   // 8 AM - Breakfast
      tz.TZDateTime(tz.local, now.year, now.month, now.day, 13, 0),  // 1 PM - Lunch
      tz.TZDateTime(tz.local, now.year, now.month, now.day, 19, 0),  // 7 PM - Dinner
    ];

    for (int i = 0; i < mealTimes.length; i++) {
      var scheduled = mealTimes[i];
      if (scheduled.isBefore(now)) {
        scheduled = scheduled.add(const Duration(days: 1));
      }

      final meals = ['Breakfast', 'Lunch', 'Dinner'];
      await _plugin.zonedSchedule(
        _mealReminderId + i,
        'Log Your ${meals[i]}',
        'Don\'t forget to track your ${meals[i].toLowerCase()}! 📱',
        scheduled,
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }
  }

  /// Show celebration when water goal is achieved
  Future<void> showWaterGoalAchieved() async {
    if (kIsWeb) return;
    
    final androidDetails = AndroidNotificationDetails(
      'achievements',
      'Achievements',
      channelDescription: 'Celebration notifications for goal achievements',
      importance: Importance.max,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();
    final details = NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _plugin.show(
      _waterGoalAchievedId,
      '🎉 Water Goal Achieved!',
      'Congratulations! You\'ve reached your daily hydration goal!',
      details,
    );
  }

  /// Show personalized motivation based on progress
  Future<void> showPersonalizedMotivation(String message) async {
    if (kIsWeb) return;
    
    final androidDetails = AndroidNotificationDetails(
      'motivation',
      'Daily Motivation',
      channelDescription: 'Personalized motivational messages',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );
    const iosDetails = DarwinNotificationDetails();
    final details = NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _plugin.show(
      DateTime.now().millisecondsSinceEpoch % 100000,
      'Your Daily Motivation',
      message,
      details,
    );
  }

  /// Cancel all water reminders
  Future<void> cancelWaterReminders() async {
    for (int i = 0; i < 4; i++) {
      await _plugin.cancel(_waterReminderId + i);
    }
  }

  /// Cancel all meal reminders
  Future<void> cancelMealReminders() async {
    for (int i = 0; i < 3; i++) {
      await _plugin.cancel(_mealReminderId + i);
    }
  }
}
