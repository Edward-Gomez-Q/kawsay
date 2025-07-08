import 'package:project_3_kawsay/data/sqflite/patient/db/database_helper.dart';
import 'package:project_3_kawsay/model/patient/hospitalization.dart';

class HospitalizationRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<int> create(Hospitalization hospitalization) async {
    final db = await _dbHelper.database;
    return await db.insert('hospitalization', hospitalization.toMap());
  }

  Future<int> delete(int id) async {
    final db = await _dbHelper.database;
    return await db.delete('hospitalization', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Hospitalization>> getAllByPatientId(int patientId) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'hospitalization',
      where: 'patient_id = ?',
      whereArgs: [patientId],
    );
    return result.map((map) => Hospitalization.fromMap(map)).toList();
  }
}
