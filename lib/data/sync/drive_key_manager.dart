import 'dart:math' show Random;
import 'dart:convert';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis_auth/googleapis_auth.dart' as auth;
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

/// DriveKeyManager untuk mengelola encryption key di Google Drive
/// 
/// Implementasi ADR-001 Varian C1:
/// - Key disimpan di appDataFolder (tersembunyi dari UI)
/// - File: 'luma_encryption_key.json'
/// - Format: {"key": "base64-encoded-32-byte-key", "createdAt": "ISO8601"}
class DriveKeyManager {
  static final DriveKeyManager _instance = DriveKeyManager._internal();
  factory DriveKeyManager() => _instance;
  DriveKeyManager._internal();

  drive.DriveApi? _driveApi;
  bool _isInitialized = false;

  /// Inisialisasi dengan authenticated HTTP client
  Future<void> initialize(auth.AuthClient authClient) async {
    _driveApi = drive.DriveApi(authClient);
    _isInitialized = true;
    debugPrint('DriveKeyManager initialized');
  }

  /// Generate random 32-byte encryption key
  Uint8List generateRandomKey() {
    final random = Random.secure();
    return Uint8List.fromList(
      List.generate(32, (_) => random.nextInt(256)),
    );
  }

  /// Upload encryption key ke Google Drive (appDataFolder)
  /// Returns true jika berhasil, false jika gagal
  Future<bool> uploadKey(Uint8List key) async {
    if (!_isInitialized || _driveApi == null) {
      throw StateError('DriveKeyManager not initialized. Call initialize() first.');
    }

    try {
      // Cek apakah key sudah ada
      final existingFile = await _findKeyFile();
      
      final keyData = {
        'key': base64Encode(key),
        'createdAt': DateTime.now().toIso8601String(),
        'version': 1,
      };

      final fileMetadata = drive.File()
        ..name = 'luma_encryption_key.json'
        ..parents = ['appDataFolder'];

      final contentBytes = utf8.encode(jsonEncode(keyData));
      final media = drive.Media(
        http.ByteStream.fromBytes(contentBytes),
        contentBytes.length,
      );

      if (existingFile != null) {
        // Update existing file
        await _driveApi!.files.update(
          fileMetadata,
          existingFile.id!,
          uploadMedia: media,
        );
        debugPrint('Encryption key updated in Google Drive');
      } else {
        // Create new file
        fileMetadata.mimeType = 'application/json';
        await _driveApi!.files.create(
          fileMetadata,
          uploadMedia: media,
        );
        debugPrint('Encryption key uploaded to Google Drive');
      }

      return true;
    } catch (e) {
      debugPrint('Error uploading encryption key: $e');
      return false;
    }
  }

  /// Download encryption key dari Google Drive
  /// Returns null jika tidak ditemukan
  Future<Uint8List?> downloadKey() async {
    if (!_isInitialized || _driveApi == null) {
      throw StateError('DriveKeyManager not initialized. Call initialize() first.');
    }

    try {
      final file = await _findKeyFile();
      
      if (file == null) {
        debugPrint('No encryption key found in Google Drive');
        return null;
      }

      final response = await _driveApi!.files.get(
        file.id!,
        downloadOptions: drive.DownloadOptions.fullMedia,
      ) as drive.Media;

      final stream = response.stream;
      final bytes = await stream.fold<List<int>>(
        [],
        (prev, element) => prev..addAll(element),
      );

      final jsonString = utf8.decode(bytes);
      final keyData = jsonDecode(jsonString) as Map<String, dynamic>;
      
      final keyBase64 = keyData['key'] as String;
      return base64Decode(keyBase64);
    } catch (e) {
      debugPrint('Error downloading encryption key: $e');
      return null;
    }
  }

  /// Cari file encryption key di appDataFolder
  Future<drive.File?> _findKeyFile() async {
    try {
      final fileList = await _driveApi!.files.list(
        q: "name='luma_encryption_key.json' and 'appDataFolder' in parents and trashed=false",
        spaces: 'appDataFolder',
      );

      if (fileList.files != null && fileList.files!.isNotEmpty) {
        return fileList.files!.first;
      }
      
      return null;
    } catch (e) {
      debugPrint('Error finding key file: $e');
      return null;
    }
  }

  /// Hapus encryption key dari Google Drive (untuk reset)
  Future<bool> deleteKey() async {
    if (!_isInitialized || _driveApi == null) {
      throw StateError('DriveKeyManager not initialized. Call initialize() first.');
    }

    try {
      final file = await _findKeyFile();
      
      if (file != null) {
        await _driveApi!.files.delete(file.id!);
        debugPrint('Encryption key deleted from Google Drive');
        return true;
      }
      
      return false;
    } catch (e) {
      debugPrint('Error deleting encryption key: $e');
      return false;
    }
  }

  /// Cek apakah key ada di Google Drive
  Future<bool> hasKeyInDrive() async {
    final file = await _findKeyFile();
    return file != null;
  }

  bool get isInitialized => _isInitialized;
}
