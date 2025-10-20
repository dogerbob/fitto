import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitto/screens/workouts_screen.dart';
import 'package:fitto/screens/nutrition_screen.dart';
import 'package:fitto/screens/water_tracker_screen.dart';
import 'package:fitto/screens/progress_screen.dart';
import 'package:fitto/screens/coach_screen.dart';
import 'package:fitto/screens/settings_screen.dart';
import 'package:fitto/providers/app_state_provider.dart';
import 'package:fitto/widgets/stat_card.dart';
import 'package:fitto/widgets/progress_ring.dart';
import 'package:fitto/widgets/shimmer_loading.dart';
import 'package:fitto/utils/localizations.dart';
import 'package:fitto/utils/responsive_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppStateProvider>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateProvider>(
      builder: (context, appState, child) {
        final screens = [
          _buildHomeContent(appState),
          WorkoutsScreen(),
          NutritionScreen(),
          WaterTrackerScreen(),
          ProgressScreen(),
          CoachScreen(),
        ];

        return Scaffold(
          body: appState.isLoading
              ? _buildShimmerLoading()
              : AnimatedSwitcher(
              duration: Duration(milliseconds: 400),
              switchInCurve: Curves.easeInOutCubic,
              switchOutCurve: Curves.easeInOutCubic,
              transitionBuilder: (child, animation) {
                final slideAnimation = Tween<Offset>(
                  begin: Offset(0.1, 0),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInOutCubic,
                ));
                
                final scaleAnimation = Tween<double>(
                  begin: 0.95,
                  end: 1.0,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInOutCubic,
                ));
                
                return SlideTransition(
                  position: slideAnimation,
                  child: ScaleTransition(
                    scale: scaleAnimation,
                    child: FadeTransition(
                      opacity: animation,
                      child: child,
                    ),
                  ),
                );
              },
              child: KeyedSubtree(
                key: ValueKey<int>(_currentIndex),
                child: screens[_currentIndex],
              ),
            ),
          bottomNavigationBar: _buildBottomNav(),
        );
      },
    );
  }

  Widget _buildShimmerLoading() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header shimmer
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerLoading(
                        isLoading: true,
                        child: ShimmerText(width: 60, height: 16),
                      ),
                      SizedBox(height: 8),
                      ShimmerLoading(
                        isLoading: true,
                        child: ShimmerText(width: 120, height: 28),
                      ),
                    ],
                  ),
                  ShimmerLoading(
                    isLoading: true,
                    child: ShimmerCircle(size: 48),
                  ),
                ],
              ),
              SizedBox(height: 32),
              
              // Motivation card shimmer
              ShimmerLoading(
                isLoading: true,
                child: ShimmerCard(height: 100, borderRadius: 20),
              ),
              SizedBox(height: 32),
              
              // Title shimmer
              ShimmerLoading(
                isLoading: true,
                child: ShimmerText(width: 150, height: 22),
              ),
              SizedBox(height: 16),
              
              // Progress ring shimmer
              Center(
                child: ShimmerLoading(
                  isLoading: true,
                  child: ShimmerCircle(size: 160),
                ),
              ),
              SizedBox(height: 32),
              
              // Stats grid shimmer
              Row(
                children: [
                  Expanded(
                    child: ShimmerLoading(
                      isLoading: true,
                      child: ShimmerCard(height: 80, borderRadius: 12),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ShimmerLoading(
                      isLoading: true,
                      child: ShimmerCard(height: 80, borderRadius: 12),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHomeContent(AppStateProvider appState) {
    final locale = 'en';
    final user = appState.currentUser;
    final todayCalories = appState.getTotalCaloriesByDate(DateTime.now());
    final waterGlasses = appState.waterGlasses;
    final steps = appState.steps;
    final motivation = appState.dailyMotivation;

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
                  gradient: LinearGradient(colors: [Color(0xFFFFEAA7), Color(0xFFFFD97D)]),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Color(0xFFFFEAA7).withOpacity(0.3), blurRadius: 12, offset: Offset(0, 6))],
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
                  color: Color(0xFFFFB4C8),
                  backgroundColor: Color(0xFFFFE4ED),
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
              ResponsiveHelper.responsiveBuilder(
                context,
                mobile: _buildStatsGrid(context, 2, 1.3),
                tablet: _buildStatsGrid(context, 3, 1.4),
                desktop: _buildStatsGrid(context, 4, 1.5),
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
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: Offset(0, -2))],
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
                _buildNavItem(Icons.water_drop, 'Water', 3),
                _buildNavItem(Icons.trending_up, AppLocalizations.get('progress', locale), 4),
                _buildNavItem(Icons.psychology, AppLocalizations.get('coach', locale), 5),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context, int crossAxisCount, double childAspectRatio) {
    final locale = 'en';
    final user = context.read<AppStateProvider>().currentUser;
    final waterGlasses = context.read<AppStateProvider>().waterGlasses;
    final steps = context.read<AppStateProvider>().steps;

    return GridView.count(
      crossAxisCount: crossAxisCount,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: childAspectRatio,
      children: [
        StatCard(
          title: AppLocalizations.get('water', locale),
          value: '$waterGlasses',
          subtitle: '${user?.dailyWaterGoal ?? 8} glasses goal',
          icon: Icons.water_drop,
          gradientColors: [
            Theme.of(context).colorScheme.secondary,
            Theme.of(context).colorScheme.tertiary,
          ],
        ),
        StatCard(
          title: AppLocalizations.get('steps', locale),
          value: '$steps',
          subtitle: '${user?.dailyStepsGoal ?? 10000} steps goal',
          icon: Icons.directions_walk,
          gradientColors: [
            Theme.of(context).colorScheme.tertiary,
            Theme.of(context).colorScheme.primary,
          ],
        ),
        if (crossAxisCount >= 3)
          StatCard(
            title: 'Calories',
            value: '${context.read<AppStateProvider>().getTotalCaloriesByDate(DateTime.now())}',
            subtitle: '${user?.dailyCalorieGoal ?? 2200} kcal goal',
            icon: Icons.local_fire_department,
            gradientColors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary,
            ],
          ),
        if (crossAxisCount >= 4)
          StatCard(
            title: 'Workouts',
            value: '3',
            subtitle: 'This week',
            icon: Icons.fitness_center,
            gradientColors: [
              Theme.of(context).colorScheme.tertiary,
              Theme.of(context).colorScheme.primary,
            ],
          ),
      ],
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isActive = _currentIndex == index;
    return GestureDetector(
      onTap: () {
        if (_currentIndex != index) {
          setState(() => _currentIndex = index);
        }
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOutCubic,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: isActive 
              ? LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.secondary,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ) 
              : null,
          color: isActive ? null : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedScale(
              scale: isActive ? 1.1 : 1.0,
              duration: Duration(milliseconds: 200),
              child: Icon(
                icon,
                color: isActive 
                    ? Colors.white 
                    : Colors.grey.shade500,
                size: 24,
              ),
            ),
            AnimatedSize(
              duration: Duration(milliseconds: 250),
              curve: Curves.easeInOutCubic,
              child: isActive
                  ? Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: Text(
                        label,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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
