import 'package:project_3_kawsay/data/sqflite/patient/db/database_helper.dart';
import 'package:project_3_kawsay/model/patient/medical_critical_info.dart';

class MedicalCriticalInfoRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<int> update(MedicalCriticalInfo medicalInfo) async {
    final db = await _dbHelper.database;
    return await db.update(
      'medical_critical_info',
      medicalInfo.toMap(),
      where: 'patient_id = ?',
      whereArgs: [medicalInfo.patientId],
    );
  }

  Future<MedicalCriticalInfo?> getByPatientId(int patientId) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'medical_critical_info',
      where: 'patient_id = ?',
      whereArgs: [patientId],
    );
    return result.isNotEmpty ? MedicalCriticalInfo.fromMap(result.first) : null;
  }
}
