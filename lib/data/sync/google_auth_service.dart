import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis_auth/googleapis_auth.dart' as auth;

/// GoogleAuthService — Mengelola siklus hidup Google Sign-In dan AuthClient.
///
/// Menggunakan `extension_google_sign_in_as_googleapis_auth` untuk mendapatkan
/// AuthClient yang valid dari GoogleSignIn — ini adalah cara resmi Google.
///
/// Masalah sebelumnya: `account.authentication.accessToken` bisa null di Android
/// karena GIS (Google Identity Services) tidak selalu mengembalikan accessToken
/// untuk API calls. Package extension ini menyelesaikan masalah itu.
///
/// Platform support:
/// - Android: ✅
/// - iOS: ✅
/// - Windows/Linux/macOS desktop: ❌
class GoogleAuthService {
  static final GoogleAuthService _instance = GoogleAuthService._internal();
  factory GoogleAuthService() => _instance;
  GoogleAuthService._internal();

  static const _scopes = [
    'https://www.googleapis.com/auth/drive.appdata',
  ];

  static const _webClientId =
      '329400324837-oqc1cqj9ttut0ppdjohd91f5u539ufo5.apps.googleusercontent.com';

  static bool get isPlatformSupported =>
      defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS;

  bool get isConfigured =>
      _webClientId != 'YOUR_WEB_CLIENT_ID.apps.googleusercontent.com';

  late final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: _scopes,
    serverClientId: _webClientId,
  );

  GoogleSignInAccount? _currentAccount;

  GoogleSignInAccount? get currentAccount => _currentAccount;
  bool get isSignedIn => _currentAccount != null;

  // ─── Sign-In ────────────────────────────────────────────────────────────────

  /// Sign-in dan return AuthClient yang siap dipakai googleapis.
  Future<auth.AuthClient?> signIn() async {
    if (!isPlatformSupported) {
      debugPrint('[GoogleAuthService] Platform tidak didukung: $defaultTargetPlatform');
      return null;
    }
    if (!isConfigured) {
      debugPrint('[GoogleAuthService] Web Client ID belum dikonfigurasi.');
      return null;
    }

    try {
      // Coba silent dulu
      var account = await _googleSignIn.signInSilently();
      debugPrint('[GoogleAuthService] signInSilently: ${account?.email ?? "null"}');

      // Jika silent gagal atau scope belum granted, lakukan interactive sign-in
      account ??= await _googleSignIn.signIn();
      debugPrint('[GoogleAuthService] signIn interactive: ${account?.email ?? "null"}');

      if (account == null) {
        debugPrint('[GoogleAuthService] Sign-in dibatalkan user');
        return null;
      }

      // Pastikan scope drive.appdata sudah di-grant
      final hasScope = await _googleSignIn.requestScopes(_scopes);
      debugPrint('[GoogleAuthService] requestScopes result: $hasScope');
      if (!hasScope) {
        debugPrint('[GoogleAuthService] Scope drive.appdata tidak di-grant user');
        return null;
      }

      _currentAccount = account;

      // Gunakan extension untuk mendapatkan AuthClient yang valid
      final client = await _googleSignIn.authenticatedClient();
      debugPrint('[GoogleAuthService] authenticatedClient: ${client != null ? "OK" : "null"}');
      if (client == null) {
        debugPrint('[GoogleAuthService] authenticatedClient() return null');
        return null;
      }

      debugPrint('[GoogleAuthService] AuthClient berhasil untuk ${account.email}');
      return client;
    } catch (e, stack) {
      debugPrint('[GoogleAuthService] signIn error: $e\n$stack');
      return null;
    }
  }

  /// Silent sign-in — tidak menampilkan UI.
  Future<auth.AuthClient?> signInSilently() async {
    if (!isPlatformSupported || !isConfigured) return null;

    try {
      final account = await _googleSignIn.signInSilently();
      if (account == null) return null;
      _currentAccount = account;

      final client = await _googleSignIn.authenticatedClient();
      return client;
    } catch (e) {
      debugPrint('[GoogleAuthService] signInSilently error: $e');
      return null;
    }
  }

  /// Dapatkan AuthClient yang valid — refresh otomatis via extension.
  Future<auth.AuthClient?> getAuthClient() async {
    if (_currentAccount == null) return null;
    try {
      return await _googleSignIn.authenticatedClient();
    } catch (e) {
      debugPrint('[GoogleAuthService] getAuthClient error: $e');
      return null;
    }
  }

  // ─── Sign-Out ───────────────────────────────────────────────────────────────

  Future<void> signOut() async {
    try {
      if (isPlatformSupported) {
        await _googleSignIn.signOut();
      }
      _currentAccount = null;
      debugPrint('[GoogleAuthService] Signed out');
    } catch (e) {
      debugPrint('[GoogleAuthService] signOut error: $e');
    }
  }
}
