import 'package:flutter/material.dart';
import 'package:fitto/screens/workouts_screen.dart';
import 'package:fitto/screens/nutrition_screen.dart';
import 'package:fitto/screens/progress_screen.dart';
import 'package:fitto/screens/coach_screen.dart';
import 'package:fitto/screens/settings_screen.dart';
import 'package:fitto/services/auth_service.dart';
import 'package:fitto/services/nutrition_service.dart';
import 'package:fitto/services/progress_service.dart';
import 'package:fitto/services/coach_service.dart';
import 'package:fitto/services/water_service.dart';
import 'package:fitto/widgets/stat_card.dart';
import 'package:fitto/widgets/progress_ring.dart';
import 'package:fitto/utils/localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final AuthService _authService = AuthService();
  final NutritionService _nutritionService = NutritionService();
  final ProgressService _progressService = ProgressService();
  final CoachService _coachService = CoachService();
  final WaterService _waterService = WaterService();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await Future.wait([
      _authService.initialize(),
      _nutritionService.initialize(),
      _progressService.initialize(),
      _coachService.initialize(),
      _waterService.initialize(),
    ]);
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      _buildHomeContent(),
      WorkoutsScreen(),
      NutritionScreen(),
      ProgressScreen(),
      CoachScreen(),
    ];

    return Scaffold(
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : AnimatedSwitcher(
              duration: Duration(milliseconds: 350),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              transitionBuilder: (child, animation) {
                final offsetAnimation = Tween<Offset>(
                  begin: Offset(0.05, 0),
                  end: Offset.zero,
                ).animate(animation);
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(position: offsetAnimation, child: child),
                );
              },
              child: KeyedSubtree(
                key: ValueKey<int>(_currentIndex),
                child: screens[_currentIndex],
              ),
            ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHomeContent() {
    final locale = 'en';
    final user = _authService.currentUser;
    final todayCalories = _nutritionService.getTotalCaloriesByDate(DateTime.now());
    final waterIntake = _waterService.getTodayIntake();
    final waterGoal = _waterService.dailyGoal;
    final stepsEntry = _progressService.getLatestEntryByType('steps');
    final motivation = _coachService.getDailyMotivation();

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Hello,', style: TextStyle(fontSize: 16, color: Colors.grey.shade600)),
                      Text(user?.name ?? 'User', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SettingsScreen())),
                    child: CircleAvatar(
                      radius: 24,
                      backgroundColor: Color(0xFFFFB4C8),
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Color(0xFFFFD54F), Color(0xFFFFCC80)]),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Color(0xFFFFD54F).withOpacity( 0.3), blurRadius: 12, offset: Offset(0, 6))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.format_quote, color: Colors.white, size: 24),
                        SizedBox(width: 8),
                        Text(AppLocalizations.get('motivation_quote', locale), style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    SizedBox(height: 12),
                    Text(motivation, style: TextStyle(color: Colors.white, fontSize: 16, height: 1.5)),
                  ],
                ),
              ),
              SizedBox(height: 32),
              Text(AppLocalizations.get('daily_summary', locale), style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              Center(
                child: ProgressRing(
                  progress: todayCalories / (user?.dailyCalorieGoal ?? 2200),
                  size: 160,
                  strokeWidth: 16,
                  color: Color(0xFFFF8A65),
                  backgroundColor: Color(0xFFFFE0D6),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('$todayCalories', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                      Text('${user?.dailyCalorieGoal ?? 2200} kcal', style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 32),
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 520;
                  final crossAxis = isWide ? 3 : 2;
                  return GridView.count(
                crossAxisCount: crossAxis,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: isWide ? 1.4 : 1.3,
                children: [
                  StatCard(
                    title: AppLocalizations.get('water', locale),
                    value: '$waterIntake',
                    subtitle: '$waterGoal glasses goal',
                    icon: Icons.water_drop,
                    gradientColors: [Color(0xFFA8D8EA), Color(0xFF7FBFD4)],
                  ),
                  StatCard(
                    title: AppLocalizations.get('steps', locale),
                    value: '${stepsEntry?.value.toInt() ?? 0}',
                    subtitle: '${user?.dailyStepsGoal ?? 10000} steps goal',
                    icon: Icons.directions_walk,
                    gradientColors: [Color(0xFFFFAB91), Color(0xFFFFCC80)],
                  ),
                ],
              );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    final locale = 'en';
    return ClipPath(
      clipper: _TopCurveClipper(),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity( 0.06), blurRadius: 12, offset: Offset(0, -2))],
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(Icons.home, AppLocalizations.get('home', locale), 0),
                _buildNavItem(Icons.fitness_center, AppLocalizations.get('workouts', locale), 1),
                _buildNavItem(Icons.restaurant, AppLocalizations.get('nutrition', locale), 2),
                _buildNavItem(Icons.trending_up, AppLocalizations.get('progress', locale), 3),
                _buildNavItem(Icons.psychology, AppLocalizations.get('coach', locale), 4),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isActive = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 250),
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          gradient: isActive ? LinearGradient(colors: [Color(0xFFFF8A65), Color(0xFFFFAB91)]) : null,
          color: isActive ? null : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isActive ? Colors.white : Colors.grey.shade500, size: 24),
            AnimatedSize(
              duration: Duration(milliseconds: 200),
              child: isActive
                  ? Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Text(label, style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600)),
                    )
                  : SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, 16);
    // Draw a subtle concave curve at the top of the bar
    path.quadraticBezierTo(size.width * 0.25, 0, size.width * 0.5, 0);
    path.quadraticBezierTo(size.width * 0.75, 0, size.width, 16);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
