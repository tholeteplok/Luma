import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis_auth/googleapis_auth.dart' as auth;
import 'package:http/http.dart' as http;

/// GoogleAuthService — Mengelola siklus hidup Google Sign-In dan AuthClient.
///
/// Bertanggung jawab untuk:
/// 1. Sign-in interaktif (saat user pertama kali backup)
/// 2. Silent sign-in (saat app restart, restore session)
/// 3. Membuat `AuthClient` yang bisa dipakai DriveBackupManager
/// 4. Sign-out + clear credentials
///
/// Scope yang diminta:
/// - `drive.appdata` — hanya akses ke appDataFolder (tersembunyi dari user)
///   Ini adalah scope paling minimal yang dibutuhkan untuk backup.
///   User tidak bisa melihat file Luma di Google Drive UI mereka.
class GoogleAuthService {
  static final GoogleAuthService _instance = GoogleAuthService._internal();
  factory GoogleAuthService() => _instance;
  GoogleAuthService._internal();

  static const _scopes = [
    'https://www.googleapis.com/auth/drive.appdata',
  ];

  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: _scopes);

  GoogleSignInAccount? _currentAccount;
  auth.AuthClient? _authClient;

  bool get isSignedIn => _currentAccount != null;
  GoogleSignInAccount? get currentAccount => _currentAccount;

  // ─── Sign-In ────────────────────────────────────────────────────────────────

  /// Sign-in interaktif — tampilkan dialog pilih akun Google.
  /// Dipanggil saat user pertama kali menekan "Cadangkan Sekarang".
  Future<auth.AuthClient?> signIn() async {
    try {
      // Coba silent sign-in dulu (restore session yang sudah ada)
      final silentAccount = await _googleSignIn.signInSilently();
      if (silentAccount != null) {
        _currentAccount = silentAccount;
        return await _buildAuthClient(silentAccount);
      }

      // Tidak ada session — tampilkan dialog
      final account = await _googleSignIn.signIn();
      if (account == null) {
        // User membatalkan
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
  /// Dipanggil saat app startup untuk auto-backup.
  Future<auth.AuthClient?> signInSilently() async {
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
  /// Gunakan ini sebelum setiap operasi Drive.
  Future<auth.AuthClient?> getAuthClient() async {
    if (_currentAccount == null) return null;

    // Coba gunakan client yang sudah ada
    if (_authClient != null) {
      // Cek apakah credentials masih valid (tidak expired)
      final creds = _authClient!.credentials;
      if (!creds.accessToken.hasExpired) {
        return _authClient;
      }
    }

    // Refresh
    return await _buildAuthClient(_currentAccount!);
  }

  // ─── Sign-Out ───────────────────────────────────────────────────────────────

  /// Sign-out dan clear semua credentials.
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      _currentAccount = null;
      _authClient?.close();
      _authClient = null;
      debugPrint('[GoogleAuthService] Signed out');
    } catch (e) {
      debugPrint('[GoogleAuthService] signOut error: $e');
    }
  }

  // ─── Internal ───────────────────────────────────────────────────────────────

  /// Buat AuthClient dari GoogleSignInAccount.
  /// Menggunakan access token dari GoogleSignInAuthentication.
  Future<auth.AuthClient?> _buildAuthClient(GoogleSignInAccount account) async {
    try {
      final googleAuth = await account.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null) {
        debugPrint('[GoogleAuthService] Access token null');
        return null;
      }

      // Buat AccessCredentials dari token Google Sign-In
      final credentials = auth.AccessCredentials(
        auth.AccessToken(
          'Bearer',
          accessToken,
          // Google Sign-In tidak expose expiry secara langsung.
          // Set ke 1 jam dari sekarang — akan di-refresh saat expired.
          DateTime.now().toUtc().add(const Duration(hours: 1)),
        ),
        null, // refresh token tidak tersedia via google_sign_in
        _scopes,
        idToken: idToken,
      );

      // Buat authenticated HTTP client
      final baseClient = http.Client();
      _authClient = auth.authenticatedClient(baseClient, credentials);

      debugPrint('[GoogleAuthService] AuthClient berhasil dibuat');
      return _authClient;
    } catch (e) {
      debugPrint('[GoogleAuthService] _buildAuthClient error: $e');
      return null;
    }
  }
}
