import 'package:project_3_kawsay/data/sqflite/patient/db/database_helper.dart';
import 'package:project_3_kawsay/model/patient/patient.dart';

class PatientDataRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  //Obtener todos los pacientes
  Future<List<Patient>> getAllPatients() async {
    final db = await _dbHelper.database;
    final result = await db.query('patient');
    return result.map((map) => Patient.fromMap(map)).toList();
  }

  //Obtener un paciente por ID
  Future<Patient?> getPatientById(int id) async {
    final db = await _dbHelper.database;
    final result = await db.query('patient', where: 'id = ?', whereArgs: [id]);
    if (result.isNotEmpty) {
      return Patient.fromMap(result.first);
    }
    return null;
  }
}
