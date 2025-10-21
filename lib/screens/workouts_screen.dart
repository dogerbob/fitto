import 'package:flutter/material.dart';
import 'package:fitto/services/workout_service.dart';
import 'package:fitto/models/exercise.dart';
import 'package:fitto/utils/constants.dart';
import 'package:fitto/utils/localizations.dart';
import 'package:fitto/widgets/gradient_button.dart';

class WorkoutsScreen extends StatefulWidget {
  const WorkoutsScreen({super.key});

  @override
  State<WorkoutsScreen> createState() => _WorkoutsScreenState();
}

class _WorkoutsScreenState extends State<WorkoutsScreen> {
  final WorkoutService _workoutService = WorkoutService();
  String _selectedCategory = 'All';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await _workoutService.initialize();
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final locale = 'en';
    
    return Scaffold(
      body: SafeArea(
        child: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppLocalizations.get('workouts', locale), style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                      SizedBox(height: 20),
                      GradientButton(
                        text: AppLocalizations.get('suggest_workout', locale),
                        onPressed: _showAISuggestion,
                        colors: [Color(0xFFFFB4C8), Color(0xFFE8C5E5)],
                      ),
                      SizedBox(height: 20),
                      _buildCategoryChips(),
                    ],
                  ),
                ),
                Expanded(child: _buildExerciseList()),
              ],
            ),
      ),
    );
  }

  Widget _buildCategoryChips() {
    final categories = ['All', ...AppConstants.exerciseCategories];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((category) {
          final isSelected = _selectedCategory == category;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = category),
            child: Container(
              margin: EdgeInsets.only(right: 12),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                gradient: isSelected ? LinearGradient(colors: [Color(0xFFFFB4C8), Color(0xFFE8C5E5)]) : null,
                color: isSelected ? null : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(category, style: TextStyle(color: isSelected ? Colors.white : Colors.grey.shade700, fontWeight: FontWeight.w600)),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildExerciseList() {
    final exercises = _selectedCategory == 'All'
      ? _workoutService.exercises
      : _workoutService.getExercisesByCategory(_selectedCategory);

    if (exercises.isEmpty) {
      return Center(child: Text('No exercises found', style: TextStyle(color: Colors.grey.shade600)));
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20),
      itemCount: exercises.length,
      itemBuilder: (context, index) => _buildExerciseCard(exercises[index]),
    );
  }

  Widget _buildExerciseCard(Exercise exercise) {
    final gradients = AppConstants.gradients;
    final gradient = gradients[exercise.name.hashCode % gradients.length];

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: gradient.colors, begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: gradient.colors.first.withOpacity( 0.25), blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showExerciseDetails(exercise),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity( 0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.fitness_center, color: Colors.white, size: 28),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(exercise.name, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text('${exercise.muscleGroup} · ${exercise.difficulty}', style: TextStyle(color: Colors.white.withOpacity( 0.9), fontSize: 14)),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showExerciseDetails(Exercise exercise) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
              ),
              SizedBox(height: 24),
              Text(exercise.name, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('${exercise.category} · ${exercise.muscleGroup}', style: TextStyle(fontSize: 16, color: Colors.grey.shade600)),
              SizedBox(height: 24),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Color(0xFFFFB4C8).withOpacity( 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(exercise.difficulty, style: TextStyle(color: Color(0xFFFFB4C8), fontWeight: FontWeight.w600)),
              ),
              SizedBox(height: 24),
              Text('Description', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text(exercise.description, style: TextStyle(fontSize: 16, color: Colors.grey.shade700, height: 1.5)),
              Spacer(),
              GradientButton(
                text: 'Log Workout',
                onPressed: () => Navigator.pop(context),
                colors: [Color(0xFFFFB4C8), Color(0xFFE8C5E5)],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAISuggestion() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('AI Workout Suggestion', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Analyzing your fitness profile...', textAlign: TextAlign.center),
          ],
        ),
      ),
    );

    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text('Suggested Workout', style: TextStyle(fontWeight: FontWeight.bold)),
            content: Text('Based on your profile, try:\n\n• Push-ups (3x15)\n• Squats (4x12)\n• Plank (3x45s)\n\nEstimated duration: 30 minutes'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: Text('Close')),
            ],
          ),
        );
      }
    });
  }
}
