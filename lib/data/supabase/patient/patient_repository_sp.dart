import 'package:project_3_kawsay/model/patient/patient.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PatientRepositorySp {
  final Supabase _client;
  final String _tableName = 'patient';
  PatientRepositorySp({Supabase? client})
    : _client = client ?? Supabase.instance;
  // CREATE - Crear un nuevo paciente
  Future<int> createPatient(Patient patientData) async {
    try {
      final response = await _client.client
          .from(_tableName)
          .insert(patientData.toMap())
          .select()
          .single();
      final createdPatient = Patient.fromMap(response);
      return createdPatient.id;
    } catch (e) {
      throw Exception('Error creating patient: $e');
    }
  }

  Future getPatientByPersonId(int personId) async {
    try {
      final response = await _client.client
          .from(_tableName)
          .select()
          .eq('person_id', personId)
          .single();
      return Patient.fromMap(response);
    } catch (e) {
      throw Exception('Error fetching patient by person ID: $e');
    }
  }
}
