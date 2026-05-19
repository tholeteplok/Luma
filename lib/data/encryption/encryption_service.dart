import 'dart:convert';
import 'package:cryptography/cryptography.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart';

/// EncryptionService untuk Zero-Knowledge Architecture
/// 
/// Key strategy (ADR-001 Varian C1):
/// - 32-byte random key dari Google Drive
/// - AES-256-GCM dengan random 96-bit IV
/// - Key di-cache di Android Keystore via flutter_secure_storage
class EncryptionService {
  static final EncryptionService _instance = EncryptionService._internal();
  factory EncryptionService() => _instance;
  EncryptionService._internal();

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  
  Uint8List? _encryptionKey;
  bool _isInitialized = false;

  /// Inisialisasi dengan key dari parameter
  /// Key harus 32-byte random dari Google Drive
  Future<void> initialize(Uint8List key) async {
    if (key.length != 32) {
      throw ArgumentError('Encryption key must be 32 bytes (256 bits)');
    }

    _encryptionKey = key;
    _isInitialized = true;

    // Cache key di secure storage (Android Keystore / iOS Keychain)
    await _secureStorage.write(
      key: 'luma_encryption_key',
      value: base64Encode(key),
    );

    debugPrint('EncryptionService initialized with ${key.length}-byte key');
  }

  /// Load key dari secure storage (untuk restore session)
  Future<bool> loadKeyFromSecureStorage() async {
    try {
      final keyString = await _secureStorage.read(key: 'luma_encryption_key');
      
      if (keyString == null) {
        debugPrint('No encryption key found in secure storage');
        return false;
      }

      _encryptionKey = base64Decode(keyString);
      _isInitialized = true;
      
      debugPrint('Encryption key loaded from secure storage');
      return true;
    } catch (e) {
      debugPrint('Error loading encryption key: $e');
      return false;
    }
  }

  /// Generate hash untuk userId (SHA-256)
  String generateUserIdHash(String googleId) {
    final bytes = utf8.encode(googleId);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Encrypt plaintext menjadi ciphertext
  /// Format output: base64(iv + ciphertext + authTag)
  Future<String> encrypt(String plaintext) async {
    if (!_isInitialized || _encryptionKey == null) {
      throw StateError('EncryptionService not initialized. Call initialize() first.');
    }

    final secretKey = SecretKey(_encryptionKey!);
    final algorithm = AesGcm.with256bits();
    
    final secretBox = await algorithm.encrypt(
      utf8.encode(plaintext),
      secretKey: secretKey,
    );

    // Combine IV (nonce) + ciphertext + auth tag (mac)
    final combined = Uint8List.fromList([
      ...secretBox.nonce,
      ...secretBox.cipherText,
      ...secretBox.mac.bytes,
    ]);

    return base64Encode(combined);
  }

  /// Decrypt ciphertext menjadi plaintext
  /// Input format: base64(iv + ciphertext + authTag)
  Future<String> decrypt(String encryptedData) async {
    if (!_isInitialized || _encryptionKey == null) {
      throw StateError('EncryptionService not initialized. Call initialize() first.');
    }

    final combined = base64Decode(encryptedData);
    
    // Extract components
    final iv = combined.sublist(0, 12); // 96-bit IV
    final cipherText = combined.sublist(12, combined.length - 16);
    final macBytes = combined.sublist(combined.length - 16); // 128-bit auth tag

    final secretKey = SecretKey(_encryptionKey!);
    final algorithm = AesGcm.with256bits();
    
    final plainText = await algorithm.decrypt(
      SecretBox(
        cipherText,
        nonce: iv,
        mac: Mac(macBytes),
      ),
      secretKey: secretKey,
    );

    return utf8.decode(plainText);
  }

  /// Encrypt bytes (untuk binary data)
  Future<String> encryptBytes(Uint8List data) async {
    if (!_isInitialized || _encryptionKey == null) {
      throw StateError('EncryptionService not initialized. Call initialize() first.');
    }

    final secretKey = SecretKey(_encryptionKey!);
    final algorithm = AesGcm.with256bits();
    
    final secretBox = await algorithm.encrypt(
      data,
      secretKey: secretKey,
    );

    final combined = Uint8List.fromList([
      ...secretBox.nonce,
      ...secretBox.cipherText,
      ...secretBox.mac.bytes,
    ]);

    return base64Encode(combined);
  }

  /// Decrypt bytes
  Future<Uint8List> decryptBytes(String encryptedData) async {
    if (!_isInitialized || _encryptionKey == null) {
      throw StateError('EncryptionService not initialized. Call initialize() first.');
    }

    final combined = base64Decode(encryptedData);
    
    final iv = combined.sublist(0, 12);
    final cipherText = combined.sublist(12, combined.length - 16);
    final macBytes = combined.sublist(combined.length - 16);

    final secretKey = SecretKey(_encryptionKey!);
    final algorithm = AesGcm.with256bits();
    
    final decryptedList = await algorithm.decrypt(
      SecretBox(
        cipherText,
        nonce: iv,
        mac: Mac(macBytes),
      ),
      secretKey: secretKey,
    );
    
    return Uint8List.fromList(decryptedList);
  }

  /// Clear cached key (untuk logout)
  Future<void> clearKey() async {
    await _secureStorage.delete(key: 'luma_encryption_key');
    _encryptionKey = null;
    _isInitialized = false;
    debugPrint('Encryption key cleared');
  }

  bool get isInitialized => _isInitialized;
}
