import 'package:project_3_kawsay/data/sqflite/patient/db/database_helper.dart';
import 'package:project_3_kawsay/model/patient/surgical_history.dart';

class SurgicalHistoryRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<int> create(SurgicalHistory surgery) async {
    final db = await _dbHelper.database;
    return await db.insert('surgical_history', surgery.toMap());
  }

  Future<int> delete(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'surgical_history',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<SurgicalHistory>> getAllByPatientId(int patientId) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'surgical_history',
      where: 'patient_id = ?',
      whereArgs: [patientId],
    );
    return result.map((map) => SurgicalHistory.fromMap(map)).toList();
  }
}
