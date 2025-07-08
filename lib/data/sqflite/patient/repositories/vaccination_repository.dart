import 'package:project_3_kawsay/data/sqflite/patient/db/database_helper.dart';
import 'package:project_3_kawsay/model/patient/vaccination.dart';

class VaccinationRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<int> create(Vaccination vaccination) async {
    final db = await _dbHelper.database;
    return await db.insert('vaccination', vaccination.toMap());
  }

  Future<int> delete(int id) async {
    final db = await _dbHelper.database;
    return await db.delete('vaccination', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Vaccination>> getAllByPatientId(int patientId) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'vaccination',
      where: 'patient_id = ?',
      whereArgs: [patientId],
    );
    return result.map((map) => Vaccination.fromMap(map)).toList();
  }
}
