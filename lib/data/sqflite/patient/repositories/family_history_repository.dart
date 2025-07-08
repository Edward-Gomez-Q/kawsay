import 'package:project_3_kawsay/data/sqflite/patient/db/database_helper.dart';
import 'package:project_3_kawsay/model/patient/family_history.dart';

class FamilyHistoryRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<int> create(FamilyHistory history) async {
    final db = await _dbHelper.database;
    return await db.insert('family_history', history.toMap());
  }

  Future<int> delete(int id) async {
    final db = await _dbHelper.database;
    return await db.delete('family_history', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<FamilyHistory>> getAllByPatientId(int patientId) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'family_history',
      where: 'patient_id = ?',
      whereArgs: [patientId],
    );
    return result.map((map) => FamilyHistory.fromMap(map)).toList();
  }
}
