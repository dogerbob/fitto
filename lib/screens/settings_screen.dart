import 'package:flutter/material.dart';
import 'package:fitto/screens/premium_screen.dart';
import 'package:fitto/services/auth_service.dart';
import 'package:fitto/services/notification_service.dart';
import 'package:fitto/services/storage_service.dart';
import 'package:fitto/utils/localizations.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final AuthService _authService = AuthService();
  final StorageService _storage = StorageService();
  String _selectedLocale = 'en';
  String _selectedTheme = 'system';
  bool _notificationsEnabled = true;
  TimeOfDay _dailyReminderTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _workoutPromptTime = const TimeOfDay(hour: 18, minute: 0);

  // Profile editing controllers
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();
  final _heightCtrl = TextEditingController();
  final _ageCtrl = TextEditingController();
  final _calorieGoalCtrl = TextEditingController();
  final _waterGoalCtrl = TextEditingController();
  final _stepsGoalCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await _authService.initialize();
    // Load saved reminder settings
    final reminderStr = await _storage.getString('dailyReminderTime');
    final workoutStr = await _storage.getString('workoutPromptTime');
    final notifEnabledStr = await _storage.getString('notificationsEnabled');
    if (reminderStr != null) {
      final parts = reminderStr.split(':');
      if (parts.length == 2) {
        _dailyReminderTime = TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
      }
    }
    if (workoutStr != null) {
      final parts = workoutStr.split(':');
      if (parts.length == 2) {
        _workoutPromptTime = TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
      }
    }
    if (notifEnabledStr != null) {
      _notificationsEnabled = notifEnabledStr == 'true';
    }

    final user = _authService.currentUser;
    if (user != null) {
      _nameCtrl.text = user.name;
      _emailCtrl.text = user.email;
      _weightCtrl.text = user.weight.toStringAsFixed(1);
      _heightCtrl.text = user.height.toStringAsFixed(1);
      _ageCtrl.text = user.age.toString();
      _calorieGoalCtrl.text = user.dailyCalorieGoal.toString();
      _waterGoalCtrl.text = user.dailyWaterGoal.toString();
      _stepsGoalCtrl.text = user.dailyStepsGoal.toString();
    }
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final locale = _selectedLocale;
    final user = _authService.currentUser;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(AppLocalizations.get('settings', locale), style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(height: 24),
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [Color(0xFFFFB4C8), Color(0xFFE8C5E5)]),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: Color(0xFFFFB4C8).withValues(alpha: 0.3), blurRadius: 12, offset: Offset(0, 6))],
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 32,
                        backgroundColor: Colors.white.withValues(alpha: 0.3),
                        child: Icon(Icons.person, color: Colors.white, size: 32),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(user?.name ?? 'User', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                            Text(user?.email ?? '', style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 14)),
                          ],
                        ),
                      ),
                      if (user?.isPremium == false)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text('Free', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 32),
                _buildSection('General', [
                  _buildLanguageItem(locale),
                  _buildThemeItem(locale),
                  _buildNotificationItem(locale),
                ]),
                SizedBox(height: 24),
                _buildSection('Profile', [
                  _buildProfileForm(locale),
                ]),
                SizedBox(height: 24),
                _buildSection('Reminders', [
                  _buildReminderControls(locale),
                ]),
                SizedBox(height: 24),
                _buildSection('Account', [
                  _buildSettingItem(
                    icon: Icons.star,
                    title: AppLocalizations.get('premium', locale),
                    subtitle: 'Upgrade to Premium',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PremiumScreen())),
                  ),
                  _buildSettingItem(
                    icon: Icons.help_outline,
                    title: 'Help & Support',
                    subtitle: 'Get help with Fitto',
                    onTap: () {},
                  ),
                  _buildSettingItem(
                    icon: Icons.info_outline,
                    title: 'About',
                    subtitle: 'Version 1.0.0',
                    onTap: () {},
                  ),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _buildSettingItem({required IconData icon, required String title, required String subtitle, required VoidCallback onTap}) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark ? Color(0xFF2A2A2A) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: Offset(0, 2))],
      ),
      child: ListTile(
        leading: Icon(icon, color: Color(0xFFFFB4C8)),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
        trailing: Icon(Icons.chevron_right, color: Colors.grey.shade400),
        onTap: onTap,
      ),
    );
  }

  Widget _buildLanguageItem(String locale) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark ? Color(0xFF2A2A2A) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: Offset(0, 2))],
      ),
      child: ListTile(
        leading: Icon(Icons.language, color: Color(0xFFFFB4C8)),
        title: Text(AppLocalizations.get('language', locale), style: TextStyle(fontWeight: FontWeight.w600)),
        trailing: DropdownButton<String>(
          value: _selectedLocale,
          underline: SizedBox(),
          items: [
            DropdownMenuItem(value: 'en', child: Text('English')),
            DropdownMenuItem(value: 'tr', child: Text('Türkçe')),
          ],
          onChanged: (value) => setState(() => _selectedLocale = value ?? 'en'),
        ),
      ),
    );
  }

  Widget _buildThemeItem(String locale) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark ? Color(0xFF2A2A2A) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: Offset(0, 2))],
      ),
      child: ListTile(
        leading: Icon(Icons.palette, color: Color(0xFFFFB4C8)),
        title: Text(AppLocalizations.get('theme', locale), style: TextStyle(fontWeight: FontWeight.w600)),
        trailing: DropdownButton<String>(
          value: _selectedTheme,
          underline: SizedBox(),
          items: [
            DropdownMenuItem(value: 'light', child: Text(AppLocalizations.get('light', locale))),
            DropdownMenuItem(value: 'dark', child: Text(AppLocalizations.get('dark', locale))),
            DropdownMenuItem(value: 'system', child: Text(AppLocalizations.get('system', locale))),
          ],
          onChanged: (value) => setState(() => _selectedTheme = value ?? 'system'),
        ),
      ),
    );
  }

  Widget _buildNotificationItem(String locale) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark ? Color(0xFF2A2A2A) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: Offset(0, 2))],
      ),
      child: SwitchListTile(
        secondary: Icon(Icons.notifications, color: Color(0xFFFFB4C8)),
        title: Text(AppLocalizations.get('notifications', locale), style: TextStyle(fontWeight: FontWeight.w600)),
        value: _notificationsEnabled,
        activeColor: Color(0xFFFFB4C8),
        onChanged: (value) async {
          setState(() => _notificationsEnabled = value);
          await _storage.saveString('notificationsEnabled', value.toString());
          if (value) {
            await NotificationService().initialize();
            await NotificationService().requestPermissions();
            await NotificationService().scheduleDailyReminder(_dailyReminderTime);
            await NotificationService().scheduleWorkoutPrompt(_workoutPromptTime);
          } else {
            await NotificationService().cancelDailyReminder();
            await NotificationService().cancelWorkoutPrompt();
          }
        },
      ),
    );
  }

  Widget _buildProfileForm(String locale) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark ? Color(0xFF2A2A2A) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: Offset(0, 2))],
      ),
      child: Column(
        children: [
          _buildTextField(_nameCtrl, label: 'Name', icon: Icons.person),
          _buildTextField(_emailCtrl, label: 'Email', icon: Icons.email, readOnly: true),
          Row(children: [
            Expanded(child: _buildTextField(_weightCtrl, label: 'Weight (kg)', icon: Icons.monitor_weight, keyboardType: TextInputType.number)),
            SizedBox(width: 12),
            Expanded(child: _buildTextField(_heightCtrl, label: 'Height (cm)', icon: Icons.height, keyboardType: TextInputType.number)),
          ]),
          Row(children: [
            Expanded(child: _buildTextField(_ageCtrl, label: 'Age', icon: Icons.cake, keyboardType: TextInputType.number)),
          ]),
          Row(children: [
            Expanded(child: _buildTextField(_calorieGoalCtrl, label: 'Daily Calories', icon: Icons.local_fire_department, keyboardType: TextInputType.number)),
            SizedBox(width: 12),
            Expanded(child: _buildTextField(_waterGoalCtrl, label: 'Water (glasses)', icon: Icons.water_drop, keyboardType: TextInputType.number)),
          ]),
          Row(children: [
            Expanded(child: _buildTextField(_stepsGoalCtrl, label: 'Steps Goal', icon: Icons.directions_walk, keyboardType: TextInputType.number)),
          ]),
          SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _saveProfile,
              style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Color(0xFFFFB4C8))),
              child: Text('Save Profile'),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildReminderControls(String locale) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark ? Color(0xFF2A2A2A) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: Offset(0, 2))],
      ),
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.alarm, color: Color(0xFFFFB4C8)),
            title: Text('Daily Reminder Time', style: TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text(_formatTime(_dailyReminderTime)),
            trailing: Icon(Icons.edit, color: Colors.grey.shade500),
            onTap: () async {
              final picked = await showTimePicker(context: context, initialTime: _dailyReminderTime);
              if (picked != null) {
                setState(() => _dailyReminderTime = picked);
                await _storage.saveString('dailyReminderTime', '${picked.hour}:${picked.minute}');
                if (_notificationsEnabled) {
                  await NotificationService().scheduleDailyReminder(picked);
                }
              }
            },
          ),
          Divider(height: 1),
          ListTile(
            leading: Icon(Icons.fitness_center, color: Color(0xFFE8C5E5)),
            title: Text('Workout Prompt Time', style: TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text(_formatTime(_workoutPromptTime)),
            trailing: Icon(Icons.edit, color: Colors.grey.shade500),
            onTap: () async {
              final picked = await showTimePicker(context: context, initialTime: _workoutPromptTime);
              if (picked != null) {
                setState(() => _workoutPromptTime = picked);
                await _storage.saveString('workoutPromptTime', '${picked.hour}:${picked.minute}');
                if (_notificationsEnabled) {
                  await NotificationService().scheduleWorkoutPrompt(picked);
                }
              }
            },
          ),
        ],
      ),
    );
  }

  String _formatTime(TimeOfDay t) {
    final h = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final mm = t.minute.toString().padLeft(2, '0');
    final suffix = t.period == DayPeriod.am ? 'AM' : 'PM';
    return '${h.toString().padLeft(2, '0')}:$mm $suffix';
  }

  Widget _buildTextField(TextEditingController controller, {required String label, required IconData icon, TextInputType? keyboardType, bool readOnly = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Color(0xFFFFB4C8)),
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Future<void> _saveProfile() async {
    final user = _authService.currentUser;
    if (user == null) return;
    final updated = user.copyWith(
      name: _nameCtrl.text.trim().isEmpty ? user.name : _nameCtrl.text.trim(),
      weight: double.tryParse(_weightCtrl.text.trim()) ?? user.weight,
      height: double.tryParse(_heightCtrl.text.trim()) ?? user.height,
      age: int.tryParse(_ageCtrl.text.trim()) ?? user.age,
      dailyCalorieGoal: int.tryParse(_calorieGoalCtrl.text.trim()) ?? user.dailyCalorieGoal,
      dailyWaterGoal: int.tryParse(_waterGoalCtrl.text.trim()) ?? user.dailyWaterGoal,
      dailyStepsGoal: int.tryParse(_stepsGoalCtrl.text.trim()) ?? user.dailyStepsGoal,
    );
    await _authService.updateUser(updated);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profile saved')));
    setState(() {});
  }
}
