import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis_auth/googleapis_auth.dart' as auth;
import 'package:http/http.dart' as http;

/// GoogleAuthService — Mengelola siklus hidup Google Sign-In dan AuthClient.
///
/// ## Setup yang dibutuhkan (WAJIB sebelum backup bisa jalan):
///
/// 1. Buat project di https://console.cloud.google.com
/// 2. Enable "Google Drive API"
/// 3. Buat OAuth 2.0 Client ID:
///    - Type: Android
///    - Package name: com.example.luma  (sesuai applicationId di build.gradle.kts)
///    - SHA-1: jalankan `keytool -list -v -keystore ~/.android/debug.keystore`
///      password default: android
/// 4. Download `google-services.json` → taruh di `android/app/google-services.json`
/// 5. Tambahkan ke android/app/build.gradle.kts:
///    plugins { id("com.google.gms.google-services") }
/// 6. Tambahkan ke android/build.gradle.kts:
///    id("com.google.gms.google-services") version "4.4.0" apply false
///
/// ## Catatan penting untuk googleapis + google_sign_in:
///
/// `google_sign_in` di Android menggunakan Google Identity Services (GIS).
/// Untuk mendapatkan `accessToken` yang bisa dipakai googleapis (Drive API),
/// kamu perlu `serverClientId` (Web OAuth Client ID) — bukan Android Client ID.
///
/// Alurnya:
/// GoogleSignIn(serverClientId: WEB_CLIENT_ID) → signIn() →
/// account.authentication.accessToken → AuthClient → DriveApi
///
/// Tanpa serverClientId, accessToken bisa null di Android.
///
/// ## Platform support:
/// - Android: ✅ (butuh google-services.json)
/// - iOS: ✅ (butuh GoogleService-Info.plist)
/// - Windows/Linux/macOS desktop: ❌ (tidak didukung google_sign_in)
class GoogleAuthService {
  static final GoogleAuthService _instance = GoogleAuthService._internal();
  factory GoogleAuthService() => _instance;
  GoogleAuthService._internal();

  /// Scope minimal untuk backup ke appDataFolder.
  /// User tidak bisa melihat file Luma di Google Drive UI mereka.
  static const _scopes = [
    'https://www.googleapis.com/auth/drive.appdata',
  ];

  /// Web OAuth Client ID dari Google Cloud Console.
  /// Diperlukan agar accessToken bisa dipakai googleapis di Android.
  ///
  /// Cara dapat:
  /// 1. Google Cloud Console → APIs & Services → Credentials
  /// 2. Create OAuth Client ID → Web application
  /// 3. Copy "Client ID" (bukan secret)
  ///
  /// GANTI nilai ini dengan Client ID milikmu:
  static const _webClientId =
      'YOUR_WEB_CLIENT_ID.apps.googleusercontent.com';

  /// Apakah platform ini mendukung Google Sign-In
  static bool get isPlatformSupported {
    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
  }

  late final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: _scopes,
    // serverClientId diperlukan untuk mendapatkan accessToken yang valid
    // di Android. Tanpa ini, accessToken bisa null.
    serverClientId: _webClientId == 'YOUR_WEB_CLIENT_ID.apps.googleusercontent.com'
        ? null // belum dikonfigurasi — akan gagal dengan pesan yang jelas
        : _webClientId,
  );

  GoogleSignInAccount? _currentAccount;
  auth.AuthClient? _authClient;

  bool get isSignedIn => _currentAccount != null;
  bool get isConfigured => _webClientId != 'YOUR_WEB_CLIENT_ID.apps.googleusercontent.com';
  GoogleSignInAccount? get currentAccount => _currentAccount;

  // ─── Sign-In ────────────────────────────────────────────────────────────────

  /// Sign-in interaktif — tampilkan dialog pilih akun Google.
  ///
  /// Return null jika:
  /// - Platform tidak didukung (Windows/Linux/macOS desktop)
  /// - Belum dikonfigurasi (webClientId masih placeholder)
  /// - User membatalkan
  /// - Error teknis
  Future<auth.AuthClient?> signIn() async {
    if (!isPlatformSupported) {
      debugPrint('[GoogleAuthService] Platform tidak didukung: $defaultTargetPlatform');
      return null;
    }

    if (!isConfigured) {
      debugPrint('[GoogleAuthService] Web Client ID belum dikonfigurasi. '
          'Lihat komentar di google_auth_service.dart untuk setup.');
      return null;
    }

    try {
      // Coba silent sign-in dulu (restore session yang sudah ada)
      final silentAccount = await _googleSignIn.signInSilently();
      if (silentAccount != null) {
        _currentAccount = silentAccount;
        final client = await _buildAuthClient(silentAccount);
        if (client != null) return client;
        // Silent berhasil tapi token null — lanjut ke interactive
      }

      // Tidak ada session atau token expired — tampilkan dialog
      final account = await _googleSignIn.signIn();
      if (account == null) {
        debugPrint('[GoogleAuthService] Sign-in dibatalkan user');
        return null;
      }

      _currentAccount = account;
      return await _buildAuthClient(account);
    } catch (e) {
      debugPrint('[GoogleAuthService] signIn error: $e');
      return null;
    }
  }

  /// Silent sign-in — tidak menampilkan UI, hanya restore session.
  Future<auth.AuthClient?> signInSilently() async {
    if (!isPlatformSupported || !isConfigured) return null;

    try {
      final account = await _googleSignIn.signInSilently();
      if (account == null) return null;
      _currentAccount = account;
      return await _buildAuthClient(account);
    } catch (e) {
      debugPrint('[GoogleAuthService] signInSilently error: $e');
      return null;
    }
  }

  /// Dapatkan AuthClient yang valid — refresh token jika perlu.
  Future<auth.AuthClient?> getAuthClient() async {
    if (_currentAccount == null) return null;

    if (_authClient != null) {
      final creds = _authClient!.credentials;
      if (!creds.accessToken.hasExpired) {
        return _authClient;
      }
    }

    // Token expired — re-authenticate
    return await _buildAuthClient(_currentAccount!);
  }

  // ─── Sign-Out ───────────────────────────────────────────────────────────────

  Future<void> signOut() async {
    try {
      if (isPlatformSupported) {
        await _googleSignIn.signOut();
      }
      _currentAccount = null;
      _authClient?.close();
      _authClient = null;
      debugPrint('[GoogleAuthService] Signed out');
    } catch (e) {
      debugPrint('[GoogleAuthService] signOut error: $e');
    }
  }

  // ─── Internal ───────────────────────────────────────────────────────────────

  Future<auth.AuthClient?> _buildAuthClient(GoogleSignInAccount account) async {
    try {
      final googleAuth = await account.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null) {
        debugPrint('[GoogleAuthService] accessToken null. '
            'Pastikan serverClientId (Web Client ID) sudah dikonfigurasi '
            'dan google-services.json sudah ada di android/app/.');
        return null;
      }

      final credentials = auth.AccessCredentials(
        auth.AccessToken(
          'Bearer',
          accessToken,
          DateTime.now().toUtc().add(const Duration(hours: 1)),
        ),
        null, // refresh token tidak tersedia via google_sign_in
        _scopes,
        idToken: idToken,
      );

      final baseClient = http.Client();
      _authClient = auth.authenticatedClient(baseClient, credentials);

      debugPrint('[GoogleAuthService] AuthClient berhasil dibuat '
          'untuk ${account.email}');
      return _authClient;
    } catch (e) {
      debugPrint('[GoogleAuthService] _buildAuthClient error: $e');
      return null;
    }
  }
}
