import 'package:flutter/material.dart';
import 'package:fitto/services/progress_service.dart';
import 'package:fitto/services/auth_service.dart';
import 'package:fitto/widgets/progress_ring.dart';
import 'package:fitto/models/progress_entry.dart';

class WaterTrackerScreen extends StatefulWidget {
  const WaterTrackerScreen({super.key});

  @override
  State<WaterTrackerScreen> createState() => _WaterTrackerScreenState();
}

class _WaterTrackerScreenState extends State<WaterTrackerScreen>
    with TickerProviderStateMixin {
  final ProgressService _progressService = ProgressService();
  final AuthService _authService = AuthService();
  bool _isLoading = true;
  int _waterGlasses = 0;
  int _dailyGoal = 8;
  
  late AnimationController _animationController;
  late AnimationController _rippleController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rippleAnimation;

  @override
  void initState() {
    super.initState();
    _initialize();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _rippleController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    
    _rippleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _rippleController, curve: Curves.easeOut),
    );
  }

  Future<void> _initialize() async {
    await Future.wait([
      _progressService.initialize(),
      _authService.initialize(),
    ]);
    
    final user = _authService.currentUser;
    _dailyGoal = user?.dailyWaterGoal ?? 8;
    
    final waterEntry = _progressService.getLatestEntryByType('water');
    _waterGlasses = waterEntry?.value.toInt() ?? 0;
    
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _rippleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = _waterGlasses / _dailyGoal;
    
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
                      // Header
                      Row(
                        children: [
                          Icon(
                            Icons.water_drop,
                            color: Theme.of(context).colorScheme.primary,
                            size: 32,
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Water Tracker',
                            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Stay hydrated throughout the day',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                      ),
                      SizedBox(height: 32),
                      
                      // Progress Ring
                      Center(
                        child: AnimatedBuilder(
                          animation: _animationController,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _scaleAnimation.value,
                              child: ProgressRing(
                                progress: progress.clamp(0.0, 1.0),
                                size: 200,
                                strokeWidth: 20,
                                color: Theme.of(context).colorScheme.primary,
                                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '$_waterGlasses',
                                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).colorScheme.primary,
                                      ),
                                    ),
                                    Text(
                                      'of $_dailyGoal glasses',
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 32),
                      
                      // Water Intake Card
                      Container(
                        padding: EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context).colorScheme.primary.withOpacity(0.1),
                              Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Daily Progress',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 16),
                            LinearProgressIndicator(
                              value: progress.clamp(0.0, 1.0),
                              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).colorScheme.primary,
                              ),
                              minHeight: 12,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${(progress * 100).toInt()}% Complete',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  '${_dailyGoal - _waterGlasses} glasses left',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 32),
                      
                      // Add Water Button
                      Center(
                        child: AnimatedBuilder(
                          animation: _rippleAnimation,
                          builder: (context, child) {
                            return Stack(
                              alignment: Alignment.center,
                              children: [
                                // Ripple effect
                                if (_rippleAnimation.value > 0)
                                  Container(
                                    width: 200 * _rippleAnimation.value,
                                    height: 200 * _rippleAnimation.value,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Theme.of(context).colorScheme.primary.withOpacity(
                                        0.1 * (1 - _rippleAnimation.value),
                                      ),
                                    ),
                                  ),
                                
                                // Main button
                                GestureDetector(
                                  onTap: _addWaterGlass,
                                  child: Container(
                                    width: 120,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Theme.of(context).colorScheme.primary,
                                          Theme.of(context).colorScheme.secondary,
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                                          blurRadius: 20,
                                          offset: Offset(0, 8),
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.white,
                                      size: 48,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 16),
                      Center(
                        child: Text(
                          'Tap to add a glass',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                      SizedBox(height: 32),
                      
                      // Quick Actions
                      Text(
                        'Quick Actions',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildQuickActionButton(
                              icon: Icons.remove,
                              label: 'Remove Glass',
                              onTap: _removeWaterGlass,
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: _buildQuickActionButton(
                              icon: Icons.refresh,
                              label: 'Reset Day',
                              onTap: _resetWaterIntake,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildQuickActionButton(
                              icon: Icons.settings,
                              label: 'Change Goal',
                              onTap: _changeDailyGoal,
                              color: Theme.of(context).colorScheme.tertiary,
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: _buildQuickActionButton(
                              icon: Icons.history,
                              label: 'View History',
                              onTap: _viewHistory,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            SizedBox(height: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addWaterGlass() async {
    if (_waterGlasses < _dailyGoal) {
      setState(() {
        _waterGlasses++;
      });
      
      await _progressService.addEntry(ProgressEntry(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: _authService.currentUser?.id ?? 'user_1',
        date: DateTime.now(),
        type: 'water',
        value: _waterGlasses.toDouble(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ));
      
      _animationController.forward().then((_) {
        _animationController.reverse();
      });
      _rippleController.forward().then((_) {
        _rippleController.reset();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('🎉 Congratulations! You\'ve reached your daily water goal!'),
          backgroundColor: Theme.of(context).colorScheme.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  Future<void> _removeWaterGlass() async {
    if (_waterGlasses > 0) {
      setState(() {
        _waterGlasses--;
      });
      
      await _progressService.addEntry(ProgressEntry(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: _authService.currentUser?.id ?? 'user_1',
        date: DateTime.now(),
        type: 'water',
        value: _waterGlasses.toDouble(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ));
    }
  }

  Future<void> _resetWaterIntake() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Reset Water Intake'),
        content: Text('Are you sure you want to reset your water intake for today?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              setState(() {
                _waterGlasses = 0;
              });
    _progressService.addEntry(ProgressEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: _authService.currentUser?.id ?? 'user_1',
      date: DateTime.now(),
      type: 'water',
      value: 0.0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ));
              Navigator.pop(context);
            },
            child: Text('Reset'),
          ),
        ],
      ),
    );
  }

  void _changeDailyGoal() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Change Daily Goal'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Set your daily water goal (glasses):'),
            SizedBox(height: 16),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Daily Goal',
                hintText: '$_dailyGoal',
              ),
              onChanged: (value) {
                final newGoal = int.tryParse(value);
                if (newGoal != null && newGoal > 0) {
                  setState(() {
                    _dailyGoal = newGoal;
                  });
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _viewHistory() {
    // TODO: Implement water intake history view
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Water history feature coming soon!'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}