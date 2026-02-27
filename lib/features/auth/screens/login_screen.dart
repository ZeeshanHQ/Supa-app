import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:supa_app/core/services/auth_service.dart';
import 'package:supa_app/core/theme/app_theme.dart';
import 'package:supa_app/core/widgets/supa_button.dart';
import 'package:supa_app/core/widgets/success_check.dart';
import 'package:supa_app/core/widgets/main_navigation_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _authService = AuthService();

  bool _isConnecting = false;
  bool _isWaitingCallback = false;
  bool _showSuccess = false;
  String? _errorMessage;

  // ─── OAuth Flow ─────────────────────────────────────────────────────────────

  Future<void> _handleConnect() async {
    setState(() {
      _isConnecting = true;
      _errorMessage = null;
    });

    try {
      // 1. Open the authorization URL in browser
      await _authService.launchOAuthLogin();

      // 2. Show "waiting" state while the user authenticates in browser
      if (mounted) {
        setState(() {
          _isConnecting = false;
          _isWaitingCallback = true;
        });
      }

      // 3. Listen for deep link callback and exchange code for tokens
      final success = await _authService.handleDeepLinkCallback();

      if (!mounted) return;

      if (success) {
        setState(() {
          _isWaitingCallback = false;
          _showSuccess = true;
        });

        // 4. Navigate to the main app after the success animation
        await Future.delayed(1.5.seconds);
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => MainNavigationScreen()),
          );
        }
      } else {
        setState(() {
          _isWaitingCallback = false;
          _errorMessage = 'Authentication failed. Please try again.';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isConnecting = false;
          _isWaitingCallback = false;
          _errorMessage = 'Could not open the login page. Please try again.';
        });
      }
    }
  }

  // ─── Management API (Secondary Action) ──────────────────────────────────────

  // Will be wired up once the backend team provides the PAT endpoint.
  void _handleManagementAPI() {}

  // ─── Build ───────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        color: AppTheme.background,
        child: _showSuccess
            ? const Center(child: SuccessCheck(label: 'CONNECTED'))
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(flex: 3),

                  // ── Branding Icon ─────────────────────────────────────────
                  Center(
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: AppTheme.background,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppTheme.accent.withOpacity(0.5),
                          width: 1.5,
                        ),
                      ),
                      child: const Icon(
                        Icons.bolt_rounded,
                        size: 40,
                        color: AppTheme.accent,
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 600.ms)
                        .scale(
                          begin: const Offset(0.8, 0.8),
                          curve: Curves.easeOutBack,
                        ),
                  ),
                  const SizedBox(height: 40),

                  // ── Title ─────────────────────────────────────────────────
                  Text(
                    'Supa-app',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displayLarge,
                  ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0),
                  const SizedBox(height: 12),
                  Text(
                    'Ready to ship? Connect your stack.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppTheme.secondary,
                          fontWeight: FontWeight.w400,
                        ),
                  ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1, end: 0),

                  const Spacer(flex: 2),

                  // ── Error Banner ──────────────────────────────────────────
                  if (_errorMessage != null) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline_rounded,
                              color: Colors.red, size: 18),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _errorMessage!,
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn().shakeX(),
                    const SizedBox(height: 16),
                  ],

                  // ── Waiting-for-callback indicator ────────────────────────
                  if (_isWaitingCallback)
                    Column(
                      children: [
                        const CircularProgressIndicator(
                            color: AppTheme.accent, strokeWidth: 2),
                        const SizedBox(height: 14),
                        Text(
                          'Waiting for browser authentication…',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppTheme.secondary.withOpacity(0.7),
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ).animate().fadeIn(),

                  // ── Primary Button ────────────────────────────────────────
                  SupaButton(
                    isLoading: _isConnecting,
                    onPressed:
                        (_isConnecting || _isWaitingCallback) ? null : _handleConnect,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.link_rounded, size: 20),
                        SizedBox(width: 12),
                        Text('Connect with Supabase'),
                      ],
                    ),
                  ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2, end: 0),
                  const SizedBox(height: 16),

                  // ── Secondary Button ──────────────────────────────────────
                  OutlinedButton(
                    onPressed: _handleManagementAPI,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.white.withOpacity(0.1)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(
                      'Management API Access',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ).animate().fadeIn(delay: 800.ms).slideY(begin: 0.2, end: 0),

                  const Spacer(flex: 1),

                  // ── Footer ────────────────────────────────────────────────
                  Center(
                    child: Column(
                      children: [
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'Privacy Policy',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Colors.white38,
                                      decoration: TextDecoration.underline,
                                    ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'v1.0.0 — Secured by Biometrics',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Colors.white24),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 1000.ms),
                  const SizedBox(height: 32),
                ],
              ),
      ),
    );
  }
}
