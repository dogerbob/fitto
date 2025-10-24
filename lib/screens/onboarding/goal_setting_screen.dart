import 'package:flutter/material.dart';
import 'package:fitto/l10n/generated/app_localizations.dart';
import 'personal_info_screen.dart';

class GoalSettingScreen extends StatefulWidget {
  static const String routeName = '/onboarding/goal-setting';

  const GoalSettingScreen({super.key});

  @override
  State<GoalSettingScreen> createState() => _GoalSettingScreenState();
}

class _GoalSettingScreenState extends State<GoalSettingScreen> {
  String? selectedGoal;

  final List<Map<String, dynamic>> goals = [
    {
      'id': 'lose_weight',
      'title': 'Lose Weight',
      'description': 'Burn fat and get lean',
      'icon': Icons.trending_down,
    },
    {
      'id': 'gain_muscle',
      'title': 'Gain Muscle',
      'description': 'Build strength and size',
      'icon': Icons.trending_up,
    },
    {
      'id': 'maintain',
      'title': 'Maintain Fitness',
      'description': 'Stay healthy and active',
      'icon': Icons.balance,
    },
    {
      'id': 'endurance',
      'title': 'Improve Endurance',
      'description': 'Build cardiovascular fitness',
      'icon': Icons.speed,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Set Your Goal'),
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
                'What\'s your fitness goal?',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              
              // Subtitle
              Text(
                'Choose the goal that best describes what you want to achieve.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
              const SizedBox(height: 32),
              
              // Goal Options
              Expanded(
                child: ListView.builder(
                  itemCount: goals.length,
                  itemBuilder: (context, index) {
                    final goal = goals[index];
                    final isSelected = selectedGoal == goal['id'];
                    
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedGoal = goal['id'];
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isSelected 
                                ? Theme.of(context).primaryColor 
                                : Colors.grey.shade300,
                              width: isSelected ? 2 : 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            color: isSelected 
                              ? Theme.of(context).primaryColor.withOpacity(0.1)
                              : Colors.transparent,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                goal['icon'],
                                size: 32,
                                color: isSelected 
                                  ? Theme.of(context).primaryColor 
                                  : Colors.grey.shade600,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      goal['title'],
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: isSelected 
                                          ? Theme.of(context).primaryColor 
                                          : null,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      goal['description'],
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (isSelected)
                                Icon(
                                  Icons.check_circle,
                                  color: Theme.of(context).primaryColor,
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              // Continue Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: selectedGoal != null ? () {
                    Navigator.pushNamed(context, PersonalInfoScreen.routeName);
                  } : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Continue',
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
}