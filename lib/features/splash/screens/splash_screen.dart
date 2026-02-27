import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:supa_app/core/theme/app_theme.dart';
import 'package:supa_app/features/auth/screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToLogin();
  }

  void _navigateToLogin() async {
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 800),
          pageBuilder: (context, animation, secondaryAnimation) => const LoginScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppTheme.background,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.accent.withOpacity(0.5), width: 1.5),
              ),
              child: const Icon(
                Icons.bolt_rounded,
                size: 48,
                color: AppTheme.accent,
              ),
            )
                .animate()
                .fadeIn(duration: 800.ms)
                .scale(begin: const Offset(0.5, 0.5), end: const Offset(1, 1), curve: Curves.elasticOut)
                .shimmer(delay: 1.2.seconds, duration: 1.8.seconds, color: AppTheme.accent.withOpacity(0.3)),
            const SizedBox(height: 24),
            Text(
              'SUPA CONTROL',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w800,
                letterSpacing: 4.0,
              ),
            ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, end: 0),
          ],
        ),
      ),
    );
  }
}
