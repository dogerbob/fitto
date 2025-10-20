import 'package:flutter/material.dart';
import 'package:fitto/services/nutrition_service.dart';
import 'package:fitto/services/auth_service.dart';
import 'package:fitto/models/nutrition_entry.dart';
import 'package:fitto/utils/constants.dart';
import 'package:fitto/utils/localizations.dart';
import 'package:fitto/widgets/gradient_button.dart';

class NutritionScreen extends StatefulWidget {
  const NutritionScreen({super.key});

  @override
  State<NutritionScreen> createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<NutritionScreen> {
  final NutritionService _nutritionService = NutritionService();
  final AuthService _authService = AuthService();
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await Future.wait([_nutritionService.initialize(), _authService.initialize()]);
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final locale = 'en';
    final todayCalories = _nutritionService.getTotalCaloriesByDate(_selectedDate);
    final goal = _authService.currentUser?.dailyCalorieGoal ?? 2200;
    final macros = _nutritionService.getMacrosByDate(_selectedDate);

    return Scaffold(
      body: SafeArea(
        child: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppLocalizations.get('nutrition', locale), style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [Color(0xFFFF6B6B), Color(0xFFFF9F43)]),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [BoxShadow(color: Color(0xFFFF6B6B).withValues(alpha: 0.3), blurRadius: 12, offset: Offset(0, 6))],
                      ),
                      child: Column(
                        children: [
                          Text(AppLocalizations.get('calories', locale), style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 14, fontWeight: FontWeight.w600)),
                          SizedBox(height: 8),
                          Text('$todayCalories', style: TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.bold)),
                          Text('of $goal kcal', style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 16)),
                          SizedBox(height: 16),
                          Container(
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: (todayCalories / goal).clamp(0.0, 1.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(child: _buildMacroCard(AppLocalizations.get('protein', locale), '${macros['protein']?.toInt() ?? 0}g', Color(0xFF4FC3F7))),
                        SizedBox(width: 12),
                        Expanded(child: _buildMacroCard(AppLocalizations.get('carbs', locale), '${macros['carbs']?.toInt() ?? 0}g', Color(0xFFFFB84D))),
                        SizedBox(width: 12),
                        Expanded(child: _buildMacroCard(AppLocalizations.get('fats', locale), '${macros['fats']?.toInt() ?? 0}g', Color(0xFFFF9F43))),
                      ],
                    ),
                    SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: GradientButton(
                            text: AppLocalizations.get('add_meal', locale),
                            onPressed: _showAddMealDialog,
                            colors: [Color(0xFFFF6B6B), Color(0xFFFF9F43)],
                            height: 48,
                            borderRadius: 24,
                          ),
                        ),
                        SizedBox(width: 12),
                        Container(
                          height: 48,
                          width: 48,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [Color(0xFFFF9F43), Color(0xFFFFA726)]),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [BoxShadow(color: Color(0xFF4FC3F7).withValues(alpha: 0.3), blurRadius: 8, offset: Offset(0, 4))],
                          ),
                          child: IconButton(icon: Icon(Icons.camera_alt, color: Colors.white), onPressed: _showAIFoodScan),
                        ),
                      ],
                    ),
                    SizedBox(height: 24),
                    ...AppConstants.mealTypes.map((mealType) => _buildMealSection(mealType)),
                  ],
                ),
              ),
            ),
      ),
    );
  }

  Widget _buildMacroCard(String label, String value, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
          SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
        ],
      ),
    );
  }

  Widget _buildMealSection(String mealType) {
    final entries = _nutritionService.getEntriesByMealType(mealType, _selectedDate);
    final locale = 'en';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppLocalizations.get(mealType.toLowerCase(), locale), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        SizedBox(height: 12),
        if (entries.isEmpty)
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(child: Text('No ${mealType.toLowerCase()} logged', style: TextStyle(color: Colors.grey.shade600))),
          )
        else
          ...entries.map((entry) => _buildMealCard(entry)),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildMealCard(NutritionEntry entry) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark ? Color(0xFF2A2A2A) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: Offset(0, 2))],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                SizedBox(height: 4),
                Text('${entry.servingSize} · ${entry.calories} kcal', style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('P: ${entry.protein.toInt()}g', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
              Text('C: ${entry.carbs.toInt()}g', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
              Text('F: ${entry.fats.toInt()}g', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddMealDialog() {
    final nameController = TextEditingController();
    final servingController = TextEditingController();
    final caloriesController = TextEditingController();
    final proteinController = TextEditingController();
    final carbsController = TextEditingController();
    final fatsController = TextEditingController();
    String selectedMealType = 'Breakfast';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Color(0xFFFF6B6B), Color(0xFFFF9F43)]),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.restaurant, color: Colors.white, size: 24),
              ),
              SizedBox(width: 12),
              Text('Add Meal', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: selectedMealType,
                  decoration: InputDecoration(
                    labelText: 'Meal Type',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: Icon(Icons.fastfood, color: Color(0xFFFF6B6B)),
                  ),
                  items: AppConstants.mealTypes.map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
                  onChanged: (value) => setDialogState(() => selectedMealType = value!),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Meal Name',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: Icon(Icons.label, color: Color(0xFFFF9F43)),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: servingController,
                  decoration: InputDecoration(
                    labelText: 'Serving Size',
                    hintText: 'e.g., 1 plate, 200g',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: Icon(Icons.scale, color: Color(0xFFFFA726)),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: caloriesController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Calories (kcal)',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: Icon(Icons.local_fire_department, color: Color(0xFFFF6B6B)),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: proteinController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Protein (g)',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: carbsController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Carbs (g)',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: fatsController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Fats (g)',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.isEmpty || caloriesController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please fill in meal name and calories')),
                  );
                  return;
                }

                final now = DateTime.now();
                final newEntry = NutritionEntry(
                  id: 'entry_${now.millisecondsSinceEpoch}',
                  userId: 'user_1',
                  date: _selectedDate,
                  mealType: selectedMealType,
                  name: nameController.text,
                  calories: int.tryParse(caloriesController.text) ?? 0,
                  protein: double.tryParse(proteinController.text) ?? 0,
                  carbs: double.tryParse(carbsController.text) ?? 0,
                  fats: double.tryParse(fatsController.text) ?? 0,
                  servingSize: servingController.text.isEmpty ? '1 serving' : servingController.text,
                  createdAt: now,
                  updatedAt: now,
                );

                await _nutritionService.addEntry(newEntry);
                if (mounted) setState(() {});
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Meal added successfully!'),
                    backgroundColor: Color(0xFF4CAF50),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFF6B6B),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text('Add Meal'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAIFoodScan() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('AI Food Recognition', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.camera_alt, size: 64, color: Color(0xFFFF6B6B)),
            SizedBox(height: 16),
            Text('Scan your food with AI\n\nThis feature will allow you to take a photo of your meal and automatically recognize the food items and nutritional information.', textAlign: TextAlign.center),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Close')),
        ],
      ),
    );
  }
}
