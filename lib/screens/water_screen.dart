import 'package:flutter/material.dart';
import 'package:fitto/services/progress_service.dart';
import 'package:fitto/services/auth_service.dart';
import 'package:fitto/utils/localizations.dart';

class WaterScreen extends StatefulWidget {
  const WaterScreen({super.key});

  @override
  State<WaterScreen> createState() => _WaterScreenState();
}

class _WaterScreenState extends State<WaterScreen> with TickerProviderStateMixin {
  final ProgressService _progressService = ProgressService();
  final AuthService _authService = AuthService();
  bool _isLoading = true;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _initialize();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _initialize() async {
    await Future.wait([_progressService.initialize(), _authService.initialize()]);
    if (mounted) setState(() => _isLoading = false);
  }

  void _addGlass() async {
    _animationController.forward().then((_) => _animationController.reverse());

    final waterEntry = _progressService.getLatestEntryByType('water');
    final currentValue = waterEntry?.value ?? 0;
    final newValue = currentValue + 1;

    await _progressService.addEntry('water', newValue);

    if (mounted) setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Great job! Keep hydrating!'),
        backgroundColor: Color(0xFF4CAF50),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _resetDaily() async {
    await _progressService.addEntry('water', 0);
    if (mounted) setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Water intake reset for today'),
        backgroundColor: Color(0xFFFF9F43),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = 'en';
    final waterEntry = _progressService.getLatestEntryByType('water');
    final currentGlasses = waterEntry?.value.toInt() ?? 0;
    final goalGlasses = _authService.currentUser?.dailyWaterGoal ?? 8;
    final progress = (currentGlasses / goalGlasses).clamp(0.0, 1.0);

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
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_back),
                            onPressed: () => Navigator.pop(context),
                          ),
                          Text(
                            AppLocalizations.get('water_tracker', locale),
                            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(height: 32),
                      Center(
                        child: Container(
                          width: 280,
                          height: 280,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [Color(0xFF4FC3F7), Color(0xFF29B6F6)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFF4FC3F7).withValues(alpha: 0.4),
                                blurRadius: 24,
                                offset: Offset(0, 12),
                              )
                            ],
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 260,
                                height: 260,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withValues(alpha: 0.2),
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.water_drop, color: Colors.white, size: 48),
                                  SizedBox(height: 16),
                                  Text(
                                    '$currentGlasses',
                                    style: TextStyle(
                                      fontSize: 72,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'of $goalGlasses glasses',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white.withValues(alpha: 0.9),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 40),
                      Container(
                        height: 24,
                        decoration: BoxDecoration(
                          color: Color(0xFFE0F7FA),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Stack(
                          children: [
                            FractionallySizedBox(
                              widthFactor: progress,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Color(0xFF4FC3F7), Color(0xFF29B6F6)],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                            Center(
                              child: Text(
                                '${(progress * 100).toInt()}% Complete',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: progress > 0.5 ? Colors.white : Color(0xFF0277BD),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 48),
                      ScaleTransition(
                        scale: _scaleAnimation,
                        child: GestureDetector(
                          onTap: _addGlass,
                          child: Container(
                            height: 80,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFFFF6B6B), Color(0xFFFF9F43)],
                              ),
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFFFF6B6B).withValues(alpha: 0.4),
                                  blurRadius: 16,
                                  offset: Offset(0, 8),
                                )
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_circle_outline, color: Colors.white, size: 32),
                                SizedBox(width: 16),
                                Text(
                                  'Add Glass',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      OutlinedButton(
                        onPressed: _resetDaily,
                        style: OutlinedButton.styleFrom(
                          minimumSize: Size(double.infinity, 56),
                          side: BorderSide(color: Color(0xFFFF9F43), width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: Text(
                          'Reset Daily Count',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFFF9F43),
                          ),
                        ),
                      ),
                      SizedBox(height: 32),
                      _buildWaterGlassGrid(currentGlasses, goalGlasses),
                      SizedBox(height: 32),
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Color(0xFFE0F7FA),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.tips_and_updates, color: Color(0xFF0277BD)),
                                SizedBox(width: 8),
                                Text(
                                  'Hydration Tips',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0277BD),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            Text(
                              '• Drink water throughout the day, not all at once\n'
                              '• Start your day with a glass of water\n'
                              '• Keep a water bottle with you\n'
                              '• Drink before you feel thirsty',
                              style: TextStyle(
                                fontSize: 14,
                                height: 1.8,
                                color: Color(0xFF01579B),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildWaterGlassGrid(int current, int goal) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: List.generate(
        goal,
        (index) {
          final isFilled = index < current;
          return AnimatedContainer(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            width: 50,
            height: 60,
            decoration: BoxDecoration(
              color: isFilled ? Color(0xFF4FC3F7) : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isFilled ? Color(0xFF29B6F6) : Colors.grey.shade300,
                width: 2,
              ),
            ),
            child: Icon(
              Icons.water_drop,
              color: isFilled ? Colors.white : Colors.grey.shade400,
              size: 24,
            ),
          );
        },
      ),
    );
  }
}
