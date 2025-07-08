import 'package:project_3_kawsay/data/sqflite/patient/db/database_helper.dart';
import 'package:project_3_kawsay/model/patient/medical_allergy.dart';

class MedicalAllergyRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<int> create(MedicalAllergy allergy) async {
    final db = await _dbHelper.database;
    return await db.insert('medical_allergy', allergy.toMap());
  }

  Future<int> delete(int id) async {
    final db = await _dbHelper.database;
    return await db.delete('medical_allergy', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<MedicalAllergy>> getAllByPatientId(int patientId) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'medical_allergy',
      where: 'patient_id = ?',
      whereArgs: [patientId],
    );
    return result.map((map) => MedicalAllergy.fromMap(map)).toList();
  }
}
