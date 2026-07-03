import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';

class EncryptionService {
  static final EncryptionService _instance = EncryptionService._internal();
  factory EncryptionService() => _instance;
  EncryptionService._internal();

  static const String _key = 'child_health_record_secret_key_2024';
  static const String _iv = '1234567890123456';

  late final Encrypter _encrypter;
  late final IV _ivObj;

  void initialize() {
    final key = Key.fromUtf8(_key);
    _ivObj = IV.fromUtf8(_iv);
    _encrypter = Encrypter(AES(key));
  }

  String encrypt(String data) {
    initialize();
    return _encrypter.encrypt(data, iv: _ivObj).base64;
  }

  String decrypt(String encryptedData) {
    initialize();
    final encrypted = Encrypted.fromBase64(encryptedData);
    return _encrypter.decrypt(encrypted, iv: _ivObj);
  }

  String hashPassword(String password) {
    final bytes = utf8.encode(password + _key);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  String generateSecureToken() {
    final random = Random.secure();
    final bytes = List<int>.generate(32, (i) => random.nextInt(256));
    return base64Url.encode(bytes);
  }

  Map<String, dynamic> encryptSensitiveData(Map<String, dynamic> data) {
    final encryptedData = <String, dynamic>{};
    
    for (final entry in data.entries) {
      final key = entry.key;
      final value = entry.value;
      
      // Encrypt sensitive fields
      if (_isSensitiveField(key)) {
        encryptedData[key] = encrypt(value.toString());
      } else {
        encryptedData[key] = value;
      }
    }
    
    return encryptedData;
  }

  Map<String, dynamic> decryptSensitiveData(Map<String, dynamic> data) {
    final decryptedData = <String, dynamic>{};
    
    for (final entry in data.entries) {
      final key = entry.key;
      final value = entry.value;
      
      // Decrypt sensitive fields
      if (_isSensitiveField(key) && value is String) {
        try {
          decryptedData[key] = decrypt(value);
        } catch (e) {
          // If decryption fails, keep original value
          decryptedData[key] = value;
        }
      } else {
        decryptedData[key] = value;
      }
    }
    
    return decryptedData;
  }

  bool _isSensitiveField(String fieldName) {
    final sensitiveFields = [
      'name',
      'parentName',
      'contactNumber',
      'address',
      'village',
      'district',
      'state',
      'symptoms',
      'diagnosis',
      'treatment',
      'medications',
      'notes',
      'doctorName',
      'hospitalName',
    ];
    
    return sensitiveFields.contains(fieldName);
  }

  String encryptFile(String filePath) {
    // For file encryption, we would implement file-specific encryption
    // This is a placeholder for file encryption functionality
    return encrypt(filePath);
  }

  String decryptFile(String encryptedFilePath) {
    // For file decryption, we would implement file-specific decryption
    // This is a placeholder for file decryption functionality
    return decrypt(encryptedFilePath);
  }
} 