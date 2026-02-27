import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supa_app/core/theme/app_theme.dart';
import 'package:supa_app/features/splash/screens/splash_screen.dart';
import 'package:supa_app/core/widgets/privacy_overlay.dart';
import 'package:supa_app/core/services/auth_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://placeholder.supabase.co',
    anonKey: 'placeholder-anon-key',
  );

  runApp(
    const ProviderScope(
      child: SupaApp(),
    ),
  );
}

class SupaApp extends StatefulWidget {
  const SupaApp({super.key});

  @override
  State<SupaApp> createState() => _SupaAppState();
}

class _SupaAppState extends State<SupaApp> with WidgetsBindingObserver {
  bool _isBackgrounded = false;
  bool _isLocked = false;
  bool _isAuthenticating = false;
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive || state == AppLifecycleState.paused) {
      setState(() {
        _isBackgrounded = true;
        _isLocked = true;
      });
    } else if (state == AppLifecycleState.resumed) {
      if (_isBackgrounded) {
        // App resumed, it's already locked from the pause state
      }
    }
  }

  Future<void> _unlockApp() async {
    setState(() => _isAuthenticating = true);
    final authenticated = await _authService.authenticateBiometrically();
    if (authenticated) {
      setState(() {
        _isLocked = false;
        _isBackgrounded = false;
      });
    }
    setState(() => _isAuthenticating = false);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Supa-app',
      theme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return Stack(
          children: [
            if (child != null) child,
            if (_isLocked)
              PrivacyOverlay(
                onUnlock: _unlockApp,
                isAuthenticating: _isAuthenticating,
              ),
          ],
        );
      },
      home: const SplashScreen(),
    );
  }
}
