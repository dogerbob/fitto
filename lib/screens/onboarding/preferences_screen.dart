import 'package:flutter/material.dart';
import 'package:fitto/l10n/generated/app_localizations.dart';
import 'package:fitto/helpers/shared_preferences.dart';
import 'package:fitto/screens/home_tabs_screen.dart';

class PreferencesScreen extends StatefulWidget {
  static const String routeName = '/onboarding/preferences';

  const PreferencesScreen({super.key});

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  List<String> selectedWorkoutDays = [];
  List<String> selectedInterests = [];
  String? selectedTheme;
  bool notificationsEnabled = true;
  bool remindersEnabled = true;

  final List<String> weekDays = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday', 
    'Friday', 'Saturday', 'Sunday'
  ];

  final List<Map<String, dynamic>> interests = [
    {'id': 'strength', 'label': 'Strength Training', 'icon': Icons.fitness_center},
    {'id': 'cardio', 'label': 'Cardio', 'icon': Icons.directions_run},
    {'id': 'yoga', 'label': 'Yoga', 'icon': Icons.self_improvement},
    {'id': 'nutrition', 'label': 'Nutrition', 'icon': Icons.restaurant},
    {'id': 'meditation', 'label': 'Meditation', 'icon': Icons.spa},
    {'id': 'swimming', 'label': 'Swimming', 'icon': Icons.pool},
    {'id': 'cycling', 'label': 'Cycling', 'icon': Icons.directions_bike},
    {'id': 'running', 'label': 'Running', 'icon': Icons.directions_run},
  ];

  final List<Map<String, dynamic>> themes = [
    {'id': 'system', 'label': 'System Default'},
    {'id': 'light', 'label': 'Light'},
    {'id': 'dark', 'label': 'Dark'},
  ];

  @override
  void initState() {
    super.initState();
    selectedTheme = 'system';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Preferences'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                'Set your preferences',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              
              // Subtitle
              Text(
                'Customize your Fitto experience to match your lifestyle.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
              const SizedBox(height: 32),
              
              // Form Content
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Workout Days
                      Text(
                        'Preferred Workout Days',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: weekDays.map((day) {
                          final isSelected = selectedWorkoutDays.contains(day);
                          return FilterChip(
                            label: Text(day),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  selectedWorkoutDays.add(day);
                                } else {
                                  selectedWorkoutDays.remove(day);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),
                      
                      // Interests
                      Text(
                        'Fitness Interests',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Select activities you\'re interested in (optional)',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: interests.map((interest) {
                          final isSelected = selectedInterests.contains(interest['id']);
                          return FilterChip(
                            label: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  interest['icon'],
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(interest['label']),
                              ],
                            ),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  selectedInterests.add(interest['id']);
                                } else {
                                  selectedInterests.remove(interest['id']);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),
                      
                      // Theme Selection
                      Text(
                        'App Theme',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...themes.map((theme) {
                        final isSelected = selectedTheme == theme['id'];
                        return RadioListTile<String>(
                          title: Text(theme['label']),
                          value: theme['id'],
                          groupValue: selectedTheme,
                          onChanged: (value) {
                            setState(() {
                              selectedTheme = value;
                            });
                          },
                          contentPadding: EdgeInsets.zero,
                        );
                      }).toList(),
                      const SizedBox(height: 24),
                      
                      // Notifications
                      Text(
                        'Notifications',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SwitchListTile(
                        title: Text('Enable notifications'),
                        subtitle: Text('Get workout reminders and tips'),
                        value: notificationsEnabled,
                        onChanged: (value) {
                          setState(() {
                            notificationsEnabled = value;
                          });
                        },
                        contentPadding: EdgeInsets.zero,
                      ),
                      SwitchListTile(
                        title: Text('Workout reminders'),
                        subtitle: Text('Remind me to work out'),
                        value: remindersEnabled,
                        onChanged: (value) {
                          setState(() {
                            remindersEnabled = value;
                          });
                        },
                        contentPadding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ),
              ),
              
              // Complete Setup Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _completeSetup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Complete Setup',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _completeSetup() async {
    // Save onboarding completion status
    await PreferenceHelper.asyncPref.setBool('onboarding_completed', true);
    
    // Save user preferences
    await PreferenceHelper.asyncPref.setStringList('workout_days', selectedWorkoutDays);
    await PreferenceHelper.asyncPref.setStringList('interests', selectedInterests);
    await PreferenceHelper.asyncPref.setString('theme_preference', selectedTheme ?? 'system');
    await PreferenceHelper.asyncPref.setBool('notifications_enabled', notificationsEnabled);
    await PreferenceHelper.asyncPref.setBool('reminders_enabled', remindersEnabled);
    
    // Navigate to main app
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomeTabsScreen()),
        (route) => false,
      );
    }
  }
}