import 'package:project_3_kawsay/data/sqflite/patient/db/database_helper.dart';
import 'package:project_3_kawsay/model/patient/lifestyle.dart';

class LifestyleRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<int> update(Lifestyle lifestyle) async {
    final db = await _dbHelper.database;
    return await db.update(
      'lifestyle',
      lifestyle.toMap(),
      where: 'patient_id = ?',
      whereArgs: [lifestyle.patientId],
    );
  }

  Future<Lifestyle?> getByPatientId(int patientId) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'lifestyle',
      where: 'patient_id = ?',
      whereArgs: [patientId],
    );
    return result.isNotEmpty ? Lifestyle.fromMap(result.first) : null;
  }
}
