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
                        gradient: LinearGradient(colors: [Color(0xFFFFB4C8), Color(0xFFE8C5E5)]),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [BoxShadow(color: Color(0xFFFFB4C8).withValues(alpha: 0.3), blurRadius: 12, offset: Offset(0, 6))],
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
                        Expanded(child: _buildMacroCard(AppLocalizations.get('protein', locale), '${macros['protein']?.toInt() ?? 0}g', Color(0xFFA8D8EA))),
                        SizedBox(width: 12),
                        Expanded(child: _buildMacroCard(AppLocalizations.get('carbs', locale), '${macros['carbs']?.toInt() ?? 0}g', Color(0xFFE8C5E5))),
                        SizedBox(width: 12),
                        Expanded(child: _buildMacroCard(AppLocalizations.get('fats', locale), '${macros['fats']?.toInt() ?? 0}g', Color(0xFFFFEAA7))),
                      ],
                    ),
                    SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: GradientButton(
                            text: AppLocalizations.get('add_meal', locale),
                            onPressed: _showAddMealDialog,
                            colors: [Color(0xFFFFB4C8), Color(0xFFE8C5E5)],
                            height: 48,
                            borderRadius: 24,
                          ),
                        ),
                        SizedBox(width: 12),
                        Container(
                          height: 48,
                          width: 48,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [Color(0xFFA8D8EA), Color(0xFF7FBFD4)]),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [BoxShadow(color: Color(0xFFA8D8EA).withValues(alpha: 0.3), blurRadius: 8, offset: Offset(0, 4))],
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Add Meal', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text('Manual meal logging feature\n\nThis would allow users to input:\n• Meal name\n• Serving size\n• Calories\n• Macros (P/C/F)'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Close')),
        ],
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
            Icon(Icons.camera_alt, size: 64, color: Color(0xFFFFB4C8)),
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
