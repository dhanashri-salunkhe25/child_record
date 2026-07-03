import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import '../models/health_record.dart';
import 'database_service.dart';
import 'encryption_service.dart';

class SyncService {
  static final SyncService _instance = SyncService._internal();
  factory SyncService() => _instance;
  SyncService._internal();

  final DatabaseService _databaseService = DatabaseService();
  final EncryptionService _encryptionService = EncryptionService();
  
  // Replace with actual eSignet API endpoints
  static const String _baseUrl = 'https://api.esignet.gov.in/child-health';
  static const String _authToken = 'your_esignet_auth_token'; // In production, this should be securely stored

  Future<bool> isConnected() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  Future<bool> syncData() async {
    if (!await isConnected()) {
      return false;
    }

    try {
      // Get unuploaded records
      final unuploadedRecords = await _databaseService.getUnuploadedRecords();
      
      if (unuploadedRecords.isEmpty) {
        return true;
      }

      // Upload each record
      for (final record in unuploadedRecords) {
        final success = await _uploadHealthRecord(record);
        if (success) {
          await _databaseService.markRecordAsUploaded(record.id!);
        }
      }

      return true;
    } catch (e) {
      // Sync error: $e
      return false;
    }
  }

  Future<bool> _uploadHealthRecord(HealthRecord record) async {
    try {
      // Get child data
      final child = await _databaseService.getChildById(record.childId);
      if (child == null) return false;

      // Prepare data for upload
      final uploadData = {
        'childId': child.id,
        'childName': child.name,
        'dateOfBirth': child.dateOfBirth,
        'gender': child.gender,
        'parentName': child.parentName,
        'contactNumber': child.contactNumber,
        'address': child.address,
        'village': child.village,
        'district': child.district,
        'state': child.state,
        'visitDate': record.visitDate.toIso8601String(),
        'weight': record.weight,
        'height': record.height,
        'headCircumference': record.headCircumference,
        'temperature': record.temperature,
        'heartRate': record.heartRate,
        'bloodPressureSystolic': record.bloodPressureSystolic,
        'bloodPressureDiastolic': record.bloodPressureDiastolic,
        'vaccinationName': record.vaccinationName,
        'vaccinationDate': record.vaccinationDate?.toIso8601String(),
        'symptoms': record.symptoms,
        'diagnosis': record.diagnosis,
        'treatment': record.treatment,
        'medications': record.medications,
        'notes': record.notes,
        'doctorName': record.doctorName,
        'hospitalName': record.hospitalName,
        'timestamp': DateTime.now().toIso8601String(),
      };

      // Encrypt sensitive data
      final encryptedData = _encryptionService.encryptSensitiveData(uploadData);

      // Make API call to eSignet
      final response = await http.post(
        Uri.parse('$_baseUrl/health-records'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_authToken',
          'X-API-Key': 'your_api_key', // Replace with actual API key
        },
        body: jsonEncode(encryptedData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        // Upload failed with status: ${response.statusCode}
        return false;
      }
    } catch (e) {
      // Upload error: $e
      return false;
    }
  }

  Future<bool> downloadChildData(String childId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/children/$childId'),
        headers: {
          'Authorization': 'Bearer $_authToken',
          'X-API-Key': 'your_api_key',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final decryptedData = _encryptionService.decryptSensitiveData(data);
        
        // Update local database with downloaded data
        // Implementation depends on your data structure
        return true;
      }
      return false;
    } catch (e) {
      // Download error: $e
      return false;
    }
  }

  Future<Map<String, dynamic>> getSyncStatus() async {
    final stats = await _databaseService.getStatistics();
    final isConnected = await this.isConnected();
    
    return {
      'isConnected': isConnected,
      'totalChildren': stats['totalChildren'],
      'totalRecords': stats['totalRecords'],
      'unuploadedRecords': stats['unuploadedRecords'],
      'lastSyncTime': DateTime.now().toIso8601String(),
    };
  }

  Future<bool> validateESignetCredentials() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/validate'),
        headers: {
          'Authorization': 'Bearer $_authToken',
          'X-API-Key': 'your_api_key',
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getVaccinationSchedule() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/vaccination-schedule'),
        headers: {
          'Authorization': 'Bearer $_authToken',
          'X-API-Key': 'your_api_key',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data);
      }
      return [];
    } catch (e) {
      // Error fetching vaccination schedule: $e
      return [];
    }
  }

  Future<bool> uploadChildPhoto(int childId, String photoPath) async {
    try {
      // Implementation for photo upload
      // This would involve multipart form data
      return true;
    } catch (e) {
      // Photo upload error: $e
      return false;
    }
  }

  Future<void> scheduleSync() async {
    // Schedule periodic sync when connectivity is available
    // This could be implemented using background tasks
  }
} 