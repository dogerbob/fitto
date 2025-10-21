import 'package:flutter/material.dart';
import 'package:fitto/screens/auth_screen.dart';
import 'package:fitto/utils/localizations.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _pages = [
    {'icon': Icons.fitness_center, 'gradient': [Color(0xFFFFB4C8), Color(0xFFE8C5E5)]},
    {'icon': Icons.psychology, 'gradient': [Color(0xFFA8D8EA), Color(0xFF7FBFD4)]},
    {'icon': Icons.emoji_events, 'gradient': [Color(0xFFFFEAA7), Color(0xFFFFD97D)]},
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = 'en';

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemCount: _pages.length,
                itemBuilder: (context, index) => _buildPage(index, locale),
              ),
            ),
            _buildIndicators(),
            Padding(
              padding: EdgeInsets.all(24),
              child: _currentPage == _pages.length - 1
                ? _buildGetStartedButton(context)
                : _buildNextButton(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(int index, String locale) {
    final titles = [
      AppLocalizations.get('onboarding_title_1', locale),
      AppLocalizations.get('onboarding_title_2', locale),
      AppLocalizations.get('onboarding_title_3', locale),
    ];
    final descriptions = [
      AppLocalizations.get('onboarding_desc_1', locale),
      AppLocalizations.get('onboarding_desc_2', locale),
      AppLocalizations.get('onboarding_desc_3', locale),
    ];

    return Padding(
      padding: EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _pages[index]['gradient'],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(100),
              boxShadow: [BoxShadow(color: _pages[index]['gradient'][0].withOpacity( 0.3), blurRadius: 20, offset: Offset(0, 10))],
            ),
            child: Icon(_pages[index]['icon'], size: 80, color: Colors.white),
          ),
          SizedBox(height: 48),
          Text(titles[index], style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          SizedBox(height: 16),
          Text(descriptions[index], style: TextStyle(fontSize: 16, color: Colors.grey.shade600, height: 1.5), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _pages.length,
        (index) => Container(
          margin: EdgeInsets.symmetric(horizontal: 4),
          width: _currentPage == index ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            gradient: _currentPage == index
              ? LinearGradient(colors: [Color(0xFFFFB4C8), Color(0xFFE8C5E5)])
              : null,
            color: _currentPage == index ? null : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }

  Widget _buildNextButton() {
    return GestureDetector(
      onTap: () => _controller.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut),
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xFFFFB4C8), Color(0xFFE8C5E5)]),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [BoxShadow(color: Color(0xFFFFB4C8).withOpacity( 0.4), blurRadius: 12, offset: Offset(0, 6))],
        ),
        child: Center(child: Text('Next', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600))),
      ),
    );
  }

  Widget _buildGetStartedButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => AuthScreen())),
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xFFFFB4C8), Color(0xFFE8C5E5)]),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [BoxShadow(color: Color(0xFFFFB4C8).withOpacity( 0.4), blurRadius: 12, offset: Offset(0, 6))],
        ),
        child: Center(child: Text(AppLocalizations.get('start', 'en'), style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600))),
      ),
    );
  }
}
