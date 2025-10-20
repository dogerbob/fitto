import 'package:flutter/material.dart';
import 'package:fitto/screens/home_screen.dart';
import 'package:fitto/services/auth_service.dart';
import 'package:fitto/utils/localizations.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);
    final success = await _authService.signInWithGoogle();
    if (!mounted) return;
    setState(() => _isLoading = false);
    
    if (success) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => HomeScreen()));
    }
  }

  Future<void> _signInWithApple() async {
    setState(() => _isLoading = true);
    final success = await _authService.signInWithApple();
    if (!mounted) return;
    setState(() => _isLoading = false);
    
    if (success) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => HomeScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = 'en';

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFF6B6B), Color(0xFFFF9F43), Color(0xFF4FC3F7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
                Text(AppLocalizations.get('welcome', locale), style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                SizedBox(height: 16),
                Text('Track your fitness journey with AI-powered insights', style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 16), textAlign: TextAlign.center),
                Spacer(),
                if (_isLoading)
                  CircularProgressIndicator(color: Colors.white)
                else ...[
                  _buildSocialButton(
                    icon: Icons.g_mobiledata,
                    label: AppLocalizations.get('sign_in_google', locale),
                    onPressed: _signInWithGoogle,
                  ),
                  SizedBox(height: 16),
                  _buildSocialButton(
                    icon: Icons.apple,
                    label: AppLocalizations.get('sign_in_apple', locale),
                    onPressed: _signInWithApple,
                  ),
                ],
                SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton({required IconData icon, required String label, required VoidCallback onPressed}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 12, offset: Offset(0, 6))],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Color(0xFFFF6B6B), size: 24),
            SizedBox(width: 12),
            Text(label, style: TextStyle(color: Color(0xFF2D2D2D), fontSize: 16, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
