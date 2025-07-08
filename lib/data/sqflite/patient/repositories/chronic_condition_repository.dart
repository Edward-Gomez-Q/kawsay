import 'package:project_3_kawsay/data/sqflite/patient/db/database_helper.dart';
import 'package:project_3_kawsay/model/patient/chronic_condition.dart';

class ChronicConditionRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<int> create(ChronicCondition condition) async {
    final db = await _dbHelper.database;
    return await db.insert('chronic_condition', condition.toMap());
  }

  Future<int> delete(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'chronic_condition',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<ChronicCondition>> getAllByPatientId(int patientId) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'chronic_condition',
      where: 'patient_id = ?',
      whereArgs: [patientId],
    );
    return result.map((map) => ChronicCondition.fromMap(map)).toList();
  }
}
