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
      final details = await _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      await details?.requestNotificationsPermission();
    } else if (Platform.isIOS) {
      final details = await _plugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
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
}
