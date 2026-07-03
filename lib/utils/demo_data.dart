import '../models/child.dart';
import '../models/health_record.dart';
import '../services/database_service.dart';

class DemoData {
  static final DatabaseService _databaseService = DatabaseService();

  static Future<void> populateDemoData() async {
    const demoUserId = 'demo-user';
    try {
      // Check if data already exists
      final children = await _databaseService.getAllChildren(demoUserId);
      if (children.isNotEmpty) {
        return; // Data already exists
      }

      // Add demo children
      final child1 = Child(
        userId: demoUserId,
        name: 'Rahul Kumar',
        dateOfBirth: '2020-03-15',
        gender: 'Male',
        parentName: 'Rajesh Kumar',
        contactNumber: '9876543210',
        address: 'House No. 123, Main Street',
        village: 'Village A',
        district: 'District X',
        state: 'State Y',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final child2 = Child(
        userId: demoUserId,
        name: 'Priya Sharma',
        dateOfBirth: '2019-07-22',
        gender: 'Female',
        parentName: 'Sunita Sharma',
        contactNumber: '8765432109',
        address: 'House No. 456, Second Street',
        village: 'Village B',
        district: 'District X',
        state: 'State Y',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final child1Id = await _databaseService.insertChild(child1);
      final child2Id = await _databaseService.insertChild(child2);

      // Add demo health records for child 1
      final record1 = HealthRecord(
        userId: demoUserId,
        childId: child1Id,
        visitDate: DateTime.now().subtract(const Duration(days: 30)),
        weight: 12.5,
        height: 85.0,
        headCircumference: 45.0,
        temperature: 37.2,
        heartRate: 120,
        vaccinationName: 'BCG',
        vaccinationDate: DateTime.now().subtract(const Duration(days: 30)),
        symptoms: 'None',
        diagnosis: 'Healthy',
        treatment: 'Routine checkup',
        doctorName: 'Dr. Amit Patel',
        hospitalName: 'Community Health Center',
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now().subtract(const Duration(days: 30)),
      );

      final record2 = HealthRecord(
        userId: demoUserId,
        childId: child1Id,
        visitDate: DateTime.now().subtract(const Duration(days: 15)),
        weight: 13.2,
        height: 87.0,
        headCircumference: 45.5,
        temperature: 36.8,
        heartRate: 115,
        vaccinationName: 'DPT',
        vaccinationDate: DateTime.now().subtract(const Duration(days: 15)),
        symptoms: 'Mild fever',
        diagnosis: 'Common cold',
        treatment: 'Rest and fluids',
        medications: 'Paracetamol',
        doctorName: 'Dr. Amit Patel',
        hospitalName: 'Community Health Center',
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        updatedAt: DateTime.now().subtract(const Duration(days: 15)),
      );

      // Add demo health records for child 2
      final record3 = HealthRecord(
        userId: demoUserId,
        childId: child2Id,
        visitDate: DateTime.now().subtract(const Duration(days: 45)),
        weight: 15.8,
        height: 92.0,
        headCircumference: 47.0,
        temperature: 37.0,
        heartRate: 110,
        vaccinationName: 'MMR',
        vaccinationDate: DateTime.now().subtract(const Duration(days: 45)),
        symptoms: 'None',
        diagnosis: 'Healthy',
        treatment: 'Routine checkup',
        doctorName: 'Dr. Priya Singh',
        hospitalName: 'Rural Health Clinic',
        createdAt: DateTime.now().subtract(const Duration(days: 45)),
        updatedAt: DateTime.now().subtract(const Duration(days: 45)),
      );

      await _databaseService.insertHealthRecord(record1);
      await _databaseService.insertHealthRecord(record2);
      await _databaseService.insertHealthRecord(record3);

    } catch (e) {
      // Handle error silently for demo purposes
    }
  }

  static Future<void> clearDemoData() async {
    const demoUserId = 'demo-user';
    try {
      final children = await _databaseService.getAllChildren(demoUserId);
      for (final child in children) {
        await _databaseService.deleteChild(child.id!);
      }
    } catch (e) {
      // Handle error silently for demo purposes
    }
  }
} 