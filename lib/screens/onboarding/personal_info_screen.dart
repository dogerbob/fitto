import 'package:flutter/material.dart';
import 'package:fitto/l10n/generated/app_localizations.dart';

class PersonalInfoScreen extends StatefulWidget {
  static const String routeName = '/onboarding/personal-info';

  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  
  String? selectedGender;
  String? selectedActivityLevel;

  final List<Map<String, dynamic>> genders = [
    {'id': 'male', 'label': 'Male'},
    {'id': 'female', 'label': 'Female'},
    {'id': 'other', 'label': 'Other'},
  ];

  final List<Map<String, dynamic>> activityLevels = [
    {'id': 'sedentary', 'label': 'Sedentary', 'description': 'Little to no exercise'},
    {'id': 'light', 'label': 'Lightly Active', 'description': 'Light exercise 1-3 days/week'},
    {'id': 'moderate', 'label': 'Moderately Active', 'description': 'Moderate exercise 3-5 days/week'},
    {'id': 'very', 'label': 'Very Active', 'description': 'Heavy exercise 6-7 days/week'},
    {'id': 'extreme', 'label': 'Extremely Active', 'description': 'Very heavy exercise, physical job'},
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Personal Information'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  'Tell us about yourself',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                
                // Subtitle
                Text(
                  'This helps us personalize your fitness journey.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
                const SizedBox(height: 32),
                
                // Form Fields
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Name Field
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: 'Full Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            prefixIcon: Icon(Icons.person),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        
                        // Age Field
                        TextFormField(
                          controller: _ageController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Age',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            prefixIcon: Icon(Icons.cake),
                            suffixText: 'years',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your age';
                            }
                            final age = int.tryParse(value);
                            if (age == null || age < 13 || age > 120) {
                              return 'Please enter a valid age';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        
                        // Gender Selection
                        Text(
                          'Gender',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: genders.map((gender) {
                            final isSelected = selectedGender == gender['id'];
                            return FilterChip(
                              label: Text(gender['label']),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  selectedGender = selected ? gender['id'] : null;
                                });
                              },
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 24),
                        
                        // Weight and Height Row
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _weightController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'Weight',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  prefixIcon: Icon(Icons.monitor_weight),
                                  suffixText: 'kg',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Required';
                                  }
                                  final weight = double.tryParse(value);
                                  if (weight == null || weight <= 0) {
                                    return 'Invalid';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextFormField(
                                controller: _heightController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'Height',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  prefixIcon: Icon(Icons.height),
                                  suffixText: 'cm',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Required';
                                  }
                                  final height = double.tryParse(value);
                                  if (height == null || height <= 0) {
                                    return 'Invalid';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        
                        // Activity Level
                        Text(
                          'Activity Level',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...activityLevels.map((level) {
                          final isSelected = selectedActivityLevel == level['id'];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: RadioListTile<String>(
                              title: Text(level['label']),
                              subtitle: Text(level['description']),
                              value: level['id'],
                              groupValue: selectedActivityLevel,
                              onChanged: (value) {
                                setState(() {
                                  selectedActivityLevel = value;
                                });
                              },
                              contentPadding: EdgeInsets.zero,
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ),
                
                // Continue Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate() && 
                          selectedGender != null && 
                          selectedActivityLevel != null) {
                        Navigator.pushNamed(context, PreferencesScreen.routeName);
                      }
                    },
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
      ),
    );
  }
}