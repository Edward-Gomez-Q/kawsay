import 'package:project_3_kawsay/data/sqflite/patient/db/database_helper.dart';
import 'package:project_3_kawsay/model/patient/emergency_contact.dart';

class EmergencyContactRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<int> create(EmergencyContact contact) async {
    final db = await _dbHelper.database;
    return await db.insert('emergency_contact', contact.toMap());
  }

  Future<int> delete(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'emergency_contact',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<EmergencyContact>> getAllByPatientId(int patientId) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'emergency_contact',
      where: 'patient_id = ?',
      whereArgs: [patientId],
    );
    return result.map((map) => EmergencyContact.fromMap(map)).toList();
  }
}
