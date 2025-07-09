import 'package:path/path.dart';
import 'package:project_3_kawsay/data/sqflite/patient/db/database_initializer.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'medical_records.db');
    return await openDatabase(
      path,
      version: 3,
      onCreate: DatabaseInitializer.createDatabase,
    );
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }

  Future<void> syncPatientIfNeeded(int patientId) async {
    final db = await database;
    final result = await db.query(
      'patient',
      where: 'id = ?',
      whereArgs: [patientId],
    );

    if (result.isEmpty) {
      await db.insert('patient', {'id': patientId, 'percentage_completed': 0});
      await db.insert('lifestyle', {
        'patient_id': patientId,
        'smokes': 0,
        'drinks_alcohol': 0,
        'drinks_alcohol_frequency_per_mounth': 0,
        'exercises': 0,
        'exercises_frequency_per_week': 0,
        'sleep_hours': 8,
        'diet_type': 'Normal',
      });
      await db.insert('medical_critical_info', {
        'patient_id': patientId,
        'blood_type': 'O+',
        'pregnant': 0,
        'has_implants': 0,
        'notes': '',
      });
    }
  }
}
