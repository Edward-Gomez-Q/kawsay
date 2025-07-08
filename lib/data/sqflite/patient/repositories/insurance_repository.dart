import 'package:project_3_kawsay/data/sqflite/patient/db/database_helper.dart';
import 'package:project_3_kawsay/model/patient/insurance.dart';

class InsuranceRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<int> create(Insurance insurance) async {
    final db = await _dbHelper.database;
    return await db.insert('insurance', insurance.toMap());
  }

  Future<int> delete(int id) async {
    final db = await _dbHelper.database;
    return await db.delete('insurance', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Insurance>> getAllByPatientId(int patientId) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'insurance',
      where: 'patient_id = ?',
      whereArgs: [patientId],
    );
    return result.map((map) => Insurance.fromMap(map)).toList();
  }
}
