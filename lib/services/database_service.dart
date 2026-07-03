import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/child.dart';
import '../models/health_record.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'child_health_record.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create children table
    await db.execute('''
      CREATE TABLE children (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId TEXT NOT NULL,
        name TEXT NOT NULL,
        dateOfBirth TEXT NOT NULL,
        gender TEXT NOT NULL,
        parentName TEXT NOT NULL,
        contactNumber TEXT NOT NULL,
        address TEXT NOT NULL,
        village TEXT NOT NULL,
        district TEXT NOT NULL,
        state TEXT NOT NULL,
        photoPath TEXT,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL
      )
    ''');

    // Create health_records table
    await db.execute('''
      CREATE TABLE health_records (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId TEXT NOT NULL,
        childId INTEGER NOT NULL,
        visitDate TEXT NOT NULL,
        weight REAL,
        height REAL,
        headCircumference REAL,
        temperature REAL,
        heartRate INTEGER,
        bloodPressureSystolic INTEGER,
        bloodPressureDiastolic INTEGER,
        vaccinationName TEXT,
        vaccinationDate TEXT,
        symptoms TEXT,
        diagnosis TEXT,
        treatment TEXT,
        medications TEXT,
        notes TEXT,
        doctorName TEXT,
        hospitalName TEXT,
        isUploaded INTEGER DEFAULT 0,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL,
        FOREIGN KEY (childId) REFERENCES children (id) ON DELETE CASCADE
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE children ADD COLUMN userId TEXT;');
      await db.execute('ALTER TABLE health_records ADD COLUMN userId TEXT;');
    }
  }

  // Child operations
  Future<int> insertChild(Child child) async {
    final db = await database;
    return await db.insert('children', child.toMap());
  }

  Future<List<Child>> getAllChildren(String userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'children',
      where: 'userId = ?',
      whereArgs: [userId],
    );
    return List.generate(maps.length, (i) => Child.fromMap(maps[i]));
  }

  Future<Child?> getChildById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'children',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Child.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateChild(Child child) async {
    final db = await database;
    return await db.update(
      'children',
      child.toMap(),
      where: 'id = ?',
      whereArgs: [child.id],
    );
  }

  Future<int> deleteChild(int id) async {
    final db = await database;
    return await db.delete(
      'children',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Health Record operations
  Future<int> insertHealthRecord(HealthRecord record) async {
    final db = await database;
    return await db.insert('health_records', record.toMap());
  }

  Future<List<HealthRecord>> getHealthRecordsByChildId(int childId, String userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'health_records',
      where: 'childId = ? AND userId = ?',
      whereArgs: [childId, userId],
      orderBy: 'visitDate DESC',
    );
    return List.generate(maps.length, (i) => HealthRecord.fromMap(maps[i]));
  }

  Future<HealthRecord?> getHealthRecordById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'health_records',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return HealthRecord.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateHealthRecord(HealthRecord record) async {
    final db = await database;
    return await db.update(
      'health_records',
      record.toMap(),
      where: 'id = ?',
      whereArgs: [record.id],
    );
  }

  Future<int> deleteHealthRecord(int id) async {
    final db = await database;
    return await db.delete(
      'health_records',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Get unuploaded records for sync
  Future<List<HealthRecord>> getUnuploadedRecords() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'health_records',
      where: 'isUploaded = ?',
      whereArgs: [0],
    );
    return List.generate(maps.length, (i) => HealthRecord.fromMap(maps[i]));
  }

  // Mark records as uploaded
  Future<int> markRecordAsUploaded(int recordId) async {
    final db = await database;
    return await db.update(
      'health_records',
      {'isUploaded': 1, 'updatedAt': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [recordId],
    );
  }

  // Search children by name
  Future<List<Child>> searchChildren(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'children',
      where: 'name LIKE ? OR parentName LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
    );
    return List.generate(maps.length, (i) => Child.fromMap(maps[i]));
  }

  // Get statistics
  Future<Map<String, dynamic>> getStatistics() async {
    final db = await database;
    
    final childrenCount = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM children')
    ) ?? 0;
    
    final recordsCount = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM health_records')
    ) ?? 0;
    
    final unuploadedCount = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM health_records WHERE isUploaded = 0')
    ) ?? 0;

    return {
      'totalChildren': childrenCount,
      'totalRecords': recordsCount,
      'unuploadedRecords': unuploadedCount,
    };
  }
} 