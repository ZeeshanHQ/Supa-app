import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:local_auth/local_auth.dart';
import 'package:app_links/app_links.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Constants from the backend developer
const String _authLoginUrl =
    'https://api.supabase.com/v1/oauth/authorize'
    '?client_id=706ae5db-0e85-4cf2-b35c-439639d59eca'
    '&redirect_uri=com.supabasepulse%3A%2F%2Flogin-callback'
    '&response_type=code'
    '&code_challenge=IMBeZBPJ_ffAgrHJFVmrJztf12uA6_zexz5glhEw_gY'
    '&code_challenge_method=S256'
    '&state=NxLw-3oYUjcX2ffteMvnFg';

const String _exchangeEndpoint =
    'https://pulse.astraventa.online/api/auth/exchange';

const String _codeVerifier =
    'vUT8kiRPZLDjtz_b1twjsoGNdyF547VKIiQNyWcz8zc';

const String _expectedState = 'NxLw-3oYUjcX2ffteMvnFg';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final LocalAuthentication _localAuth = LocalAuthentication();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final AppLinks _appLinks = AppLinks();

  // ─── Deep Linking ───────────────────────────────────────────────────────────

  /// Opens the authorization URL in the browser.
  Future<void> launchOAuthLogin() async {
    final uri = Uri.parse(_authLoginUrl);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not open the authorization URL.');
    }
  }

  /// Listens for a single deep link callback and exchanges it for tokens.
  /// Returns `true` on success, `false` on mismatch / error.
  Future<bool> handleDeepLinkCallback() async {
    // On Web, simulate a successful auth for demo purposes.
    if (kIsWeb) {
      await Future.delayed(const Duration(seconds: 2));
      await _storage.write(key: 'access_token', value: 'web_demo_token');
      return true;
    }

    try {
      // Wait up to 5 minutes for the redirect to arrive.
      final uri = await _appLinks.uriLinkStream.firstWhere(
        (uri) =>
            uri.scheme == 'com.supabasepulse' &&
            uri.host == 'login-callback',
        orElse: () => throw TimeoutException('No callback received'),
      ).timeout(const Duration(minutes: 5));

      final code = uri.queryParameters['code'];
      final state = uri.queryParameters['state'];

      // Verify state to prevent CSRF attacks.
      if (code == null || state != _expectedState) return false;

      return await _exchangeCodeForTokens(code);
    } catch (_) {
      return false;
    }
  }

  /// Posts the code + verifier to the backend and stores returned tokens.
  Future<bool> _exchangeCodeForTokens(String code) async {
    try {
      final response = await http.post(
        Uri.parse(_exchangeEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'code': code,
          'codeVerifier': _codeVerifier,
          'state': _expectedState,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final accessToken = data['access_token'] as String?;
        final refreshToken = data['refresh_token'] as String?;

        if (accessToken != null) {
          await _storage.write(key: 'access_token', value: accessToken);
        }
        if (refreshToken != null) {
          await _storage.write(key: 'refresh_token', value: refreshToken);
        }
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  // ─── Token helpers ───────────────────────────────────────────────────────────

  Future<String?> getAccessToken() =>
      _storage.read(key: 'access_token');

  Future<String?> getRefreshToken() =>
      _storage.read(key: 'refresh_token');

  // ─── Biometric Auth ──────────────────────────────────────────────────────────

  Future<bool> authenticateBiometrically() async {
    if (kIsWeb) {
      await Future.delayed(const Duration(milliseconds: 1500));
      return true;
    }

    try {
      final bool canCheckBiometrics = await _localAuth.canCheckBiometrics;
      final bool canAuthenticate =
          canCheckBiometrics || await _localAuth.isDeviceSupported();

      if (!canAuthenticate) return false;

      return await _localAuth.authenticate(
        localizedReason: 'Please authenticate to access your Database nodes',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } catch (_) {
      return false;
    }
  }

  // ─── Legacy/PAT helpers ──────────────────────────────────────────────────────

  Future<void> savePAT(String token) =>
      _storage.write(key: 'supabase_pat', value: token);

  Future<String?> getPAT() => _storage.read(key: 'supabase_pat');

  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  User? get currentUser => _supabase.auth.currentUser;

  Future<void> signOut() async {
    await _supabase.auth.signOut();
    await _storage.deleteAll();
  }
}
