import 'package:flutter/material.dart';
import 'package:fitto/services/nutrition_service.dart';
import 'package:fitto/services/auth_service.dart';
import 'package:fitto/services/water_service.dart';
import 'package:fitto/models/nutrition_entry.dart';
import 'package:fitto/utils/constants.dart';
import 'package:fitto/utils/localizations.dart';
import 'package:fitto/widgets/gradient_button.dart';
import 'package:fitto/widgets/add_meal_dialog.dart';
import 'package:shimmer/shimmer.dart';

class NutritionScreen extends StatefulWidget {
  const NutritionScreen({super.key});

  @override
  State<NutritionScreen> createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<NutritionScreen> with TickerProviderStateMixin {
  final NutritionService _nutritionService = NutritionService();
  final AuthService _authService = AuthService();
  final WaterService _waterService = WaterService();
  final DateTime _selectedDate = DateTime.now();
  bool _isLoading = true;
  bool _isAILoading = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  Map<String, dynamic> _nutritionInsights = {};
  List<Map<String, dynamic>> _mealSuggestions = [];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _initialize();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _initialize() async {
    await Future.wait([
      _nutritionService.initialize(), 
      _authService.initialize(),
      _waterService.initialize(),
    ]);
    if (mounted) {
      setState(() => _isLoading = false);
      _animationController.forward();
      await _loadNutritionInsights();
    }
  }

  Future<void> _loadNutritionInsights() async {
    if (!mounted) return;
    
    setState(() => _isAILoading = true);
    
    try {
      final user = _authService.currentUser;
      final insights = await _nutritionService.getNutritionInsights(
        calorieGoal: user?.dailyCalorieGoal ?? 2200,
        macroGoals: {
          'protein': 150.0,
          'carbs': 250.0,
          'fats': 80.0,
        },
      );
      
      if (mounted) {
        setState(() {
          _nutritionInsights = insights;
          _isAILoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isAILoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = 'en';
    final todayCalories = _nutritionService.getTotalCaloriesByDate(_selectedDate);
    final goal = _authService.currentUser?.dailyCalorieGoal ?? 2200;
    final macros = _nutritionService.getMacrosByDate(_selectedDate);
    final waterIntake = _waterService.getTodayIntake();
    final waterGoal = _waterService.dailyGoal;

    return Scaffold(
      body: SafeArea(
        child: _isLoading
          ? _buildLoadingState()
          : FadeTransition(
              opacity: _fadeAnimation,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(locale),
                      SizedBox(height: 20),
                      _buildCalorieCard(todayCalories, goal),
                      SizedBox(height: 24),
                      _buildMacroCards(macros),
                      SizedBox(height: 24),
                      _buildWaterIntakeCard(waterIntake, waterGoal),
                      SizedBox(height: 24),
                      _buildActionButtons(locale),
                      SizedBox(height: 24),
                      _buildNutritionInsights(),
                      SizedBox(height: 24),
                      _buildMealSuggestions(locale),
                      SizedBox(height: 24),
                      ...AppConstants.mealTypes.map((mealType) => _buildMealSection(mealType)),
                    ],
                  ),
                ),
              ),
            ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF8A65)),
          ),
          SizedBox(height: 16),
          Text('Loading your nutrition data...', style: TextStyle(fontSize: 16, color: Colors.grey.shade600)),
        ],
      ),
    );
  }

  Widget _buildHeader(String locale) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          AppLocalizations.get('nutrition', locale), 
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Color(0xFFFF8A65), Color(0xFFFFAB91)]),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.auto_awesome, color: Colors.white, size: 16),
              SizedBox(width: 4),
              Text('AI Powered', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCalorieCard(int todayCalories, int goal) {
    final progress = (todayCalories / goal).clamp(0.0, 1.0);
    
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFF8A65), Color(0xFFFFAB91)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFFF8A65).withOpacity(0.3),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Daily Calories',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${(progress * 100).toInt()}%',
                  style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            '$todayCalories',
            style: TextStyle(
              color: Colors.white,
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'of $goal kcal',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 18,
            ),
          ),
          SizedBox(height: 20),
          Container(
            height: 12,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(6),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMacroCards(Map<String, double> macros) {
    return Row(
      children: [
        Expanded(
          child: _buildMacroCard(
            'Protein',
            '${macros['protein']?.toInt() ?? 0}g',
            Color(0xFFFFAB91),
            '150g',
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildMacroCard(
            'Carbs',
            '${macros['carbs']?.toInt() ?? 0}g',
            Color(0xFFFFCC80),
            '250g',
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildMacroCard(
            'Fats',
            '${macros['fats']?.toInt() ?? 0}g',
            Color(0xFFFFD54F),
            '80g',
          ),
        ),
      ],
    );
  }

  Widget _buildMacroCard(String label, String value, Color color, String goal) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            'Goal: $goal',
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWaterIntakeCard(int waterIntake, int waterGoal) {
    final progress = (waterIntake / waterGoal).clamp(0.0, 1.0);
    
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFA8D8EA), Color(0xFF7FBFD4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFA8D8EA).withOpacity(0.3),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.water_drop, color: Colors.white, size: 32),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Water Intake',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '$waterIntake / $waterGoal glasses',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: progress,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () async {
              await _waterService.addWaterIntake(amount: 8);
              setState(() {});
            },
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.add, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(String locale) {
    return Row(
      children: [
        Expanded(
          child: GradientButton(
            text: AppLocalizations.get('add_meal', locale),
            onPressed: _showAddMealDialog,
            colors: [Color(0xFFFF8A65), Color(0xFFFFAB91)],
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
            boxShadow: [
              BoxShadow(
                color: Color(0xFFA8D8EA).withOpacity(0.3),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: IconButton(
            icon: Icon(Icons.camera_alt, color: Colors.white),
            onPressed: _showAIFoodScan,
          ),
        ),
        SizedBox(width: 12),
        Container(
          height: 48,
          width: 48,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Color(0xFFFFCC80), Color(0xFFFFD54F)]),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Color(0xFFFFCC80).withOpacity(0.3),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: IconButton(
            icon: Icon(Icons.auto_awesome, color: Colors.white),
            onPressed: _showAISuggestions,
          ),
        ),
      ],
    );
  }

  Widget _buildNutritionInsights() {
    if (_isAILoading) {
      return _buildShimmerInsights();
    }

    if (_nutritionInsights.isEmpty) {
      return SizedBox.shrink();
    }

    final insights = _nutritionInsights['insights'] as List<String>? ?? [];
    final recommendations = _nutritionInsights['recommendations'] as List<String>? ?? [];

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFFF8F5), Color(0xFFFFE0D6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Color(0xFFFF8A65).withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.psychology, color: Color(0xFFFF8A65), size: 24),
              SizedBox(width: 8),
              Text(
                'AI Nutrition Insights',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF8A65),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          if (insights.isNotEmpty) ...[
            Text(
              'Insights:',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey.shade700),
            ),
            SizedBox(height: 8),
            ...insights.map((insight) => Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.lightbulb_outline, size: 16, color: Color(0xFFFF8A65)),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      insight,
                      style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                    ),
                  ),
                ],
              ),
            )),
            SizedBox(height: 16),
          ],
          if (recommendations.isNotEmpty) ...[
            Text(
              'Recommendations:',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey.shade700),
            ),
            SizedBox(height: 8),
            ...recommendations.map((rec) => Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.trending_up, size: 16, color: Color(0xFFFF8A65)),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      rec,
                      style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ],
      ),
    );
  }

  Widget _buildShimmerInsights() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  Widget _buildMealSuggestions(String locale) {
    if (_mealSuggestions.isEmpty) {
      return SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'AI Meal Suggestions',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _mealSuggestions.length,
            itemBuilder: (context, index) {
              final suggestion = _mealSuggestions[index];
              return _buildMealSuggestionCard(suggestion);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMealSuggestionCard(Map<String, dynamic> suggestion) {
    return Container(
      width: 180,
      margin: EdgeInsets.only(right: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFFCC80), Color(0xFFFFD54F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFFFCC80).withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            suggestion['name'] ?? 'Suggested Meal',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 8),
          Text(
            '${suggestion['calories'] ?? 0} kcal',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'P: ${suggestion['protein'] ?? 0}g | C: ${suggestion['carbs'] ?? 0}g | F: ${suggestion['fats'] ?? 0}g',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12,
            ),
          ),
          Spacer(),
          GestureDetector(
            onTap: () => _addMealFromSuggestion(suggestion),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Add to Log',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _addMealFromSuggestion(Map<String, dynamic> suggestion) async {
    await _nutritionService.addMealFromSuggestion(suggestion, 'Breakfast');
    if (mounted) {
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Meal added to your log!'),
          backgroundColor: Color(0xFFFF8A65),
        ),
      );
    }
  }

  Future<void> _showAISuggestions() async {
    setState(() => _isAILoading = true);
    
    try {
      final suggestions = await _nutritionService.getMealSuggestions(
        mealType: 'Breakfast',
        calorieGoal: _authService.currentUser?.dailyCalorieGoal ?? 2200,
      );
      
      if (mounted) {
        setState(() {
          _mealSuggestions = suggestions;
          _isAILoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isAILoading = false);
      }
    }
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
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
        border: Border.all(color: Color(0xFFFF8A65).withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFF8A65), Color(0xFFFFAB91)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.name,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 4),
                Text(
                  '${entry.servingSize} · ${entry.calories} kcal',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'P: ${entry.protein.toInt()}g',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              Text(
                'C: ${entry.carbs.toInt()}g',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              Text(
                'F: ${entry.fats.toInt()}g',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddMealDialog() {
    showDialog(
      context: context,
      builder: (context) => AddMealDialog(
        onMealAdded: () {
          setState(() {});
          _loadNutritionInsights();
        },
      ),
    );
  }

  void _showAIFoodScan() async {
    try {
      final recognizedFoods = await _nutritionService.recognizeFoodFromImage();
      if (mounted) {
        if (recognizedFoods.isNotEmpty) {
          setState(() {});
          _loadNutritionInsights();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${recognizedFoods.length} food item(s) recognized and added!'),
              backgroundColor: Color(0xFFFF8A65),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('No food items recognized. Please try again.'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error recognizing food. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}