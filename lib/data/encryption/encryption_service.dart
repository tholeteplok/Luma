import 'dart:convert';
import 'dart:typed_data';
import 'package:cryptography/cryptography.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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

    print('EncryptionService initialized with ${key.length}-byte key');
  }

  /// Load key dari secure storage (untuk restore session)
  Future<bool> loadKeyFromSecureStorage() async {
    try {
      final keyString = await _secureStorage.read(key: 'luma_encryption_key');
      
      if (keyString == null) {
        print('No encryption key found in secure storage');
        return false;
      }

      _encryptionKey = base64Decode(keyString);
      _isInitialized = true;
      
      print('Encryption key loaded from secure storage');
      return true;
    } catch (e) {
      print('Error loading encryption key: $e');
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
    
    // Generate random 96-bit IV (12 bytes)
    final iv = SimpleNonce(); // cryptography package generates 12-byte nonce
    
    final algorithm = AesGcm(macBytes: 16);
    
    final cipherTextWithAuth = await algorithm.encrypt(
      utf8.encode(plaintext),
      secretKey: secretKey,
      nonce: iv,
    );

    // Combine IV + ciphertext + auth tag
    final combined = Uint8List.fromList([
      ...iv,
      ...cipherTextWithAuth.cipherText,
      ...cipherTextWithAuth.mac,
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
    final mac = combined.sublist(combined.length - 16); // 128-bit auth tag

    final secretKey = SecretKey(_encryptionKey!);
    
    final algorithm = AesGcm(macBytes: 16);
    
    final plainText = await algorithm.decrypt(
      cipherText,
      secretKey: secretKey,
      nonce: iv,
      mac: mac,
    );

    return utf8.decode(plainText);
  }

  /// Encrypt bytes (untuk binary data)
  Future<String> encryptBytes(Uint8List data) async {
    if (!_isInitialized || _encryptionKey == null) {
      throw StateError('EncryptionService not initialized. Call initialize() first.');
    }

    final secretKey = SecretKey(_encryptionKey!);
    final iv = SimpleNonce();
    
    final algorithm = AesGcm(macBytes: 16);
    
    final cipherTextWithAuth = await algorithm.encrypt(
      data,
      secretKey: secretKey,
      nonce: iv,
    );

    final combined = Uint8List.fromList([
      ...iv,
      ...cipherTextWithAuth.cipherText,
      ...cipherTextWithAuth.mac,
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
    final mac = combined.sublist(combined.length - 16);

    final secretKey = SecretKey(_encryptionKey!);
    
    final algorithm = AesGcm(macBytes: 16);
    
    return await algorithm.decrypt(
      cipherText,
      secretKey: secretKey,
      nonce: iv,
      mac: mac,
    );
  }

  /// Clear cached key (untuk logout)
  Future<void> clearKey() async {
    await _secureStorage.delete(key: 'luma_encryption_key');
    _encryptionKey = null;
    _isInitialized = false;
    print('Encryption key cleared');
  }

  bool get isInitialized => _isInitialized;
}
