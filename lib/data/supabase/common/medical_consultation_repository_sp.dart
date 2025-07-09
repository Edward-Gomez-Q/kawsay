import 'package:project_3_kawsay/model/common/medical_consultation_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MedicalConsultationRepositorySp {
  final SupabaseClient _client;
  final String _tableName = 'medical_consultation';
  MedicalConsultationRepositorySp({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  Future<MedicalConsultationModel> createMedicalConsultation(
    MedicalConsultationModel consultation,
  ) async {
    try {
      final data = consultation.toJson();
      data.remove('id');
      final response = await _client
          .from(_tableName)
          .insert(data)
          .select()
          .single();
      return MedicalConsultationModel.fromJson(response);
    } catch (e) {
      print('Error al crear consulta médica: $e');
      throw Exception('Error al crear consulta médica: $e');
    }
  }

  Future<List<MedicalConsultationModel>> getMedicalConsultationsByDoctorId(
    int doctorId,
  ) async {
    try {
      final response = await _client
          .from(_tableName)
          .select('''
          *,
          appointment!inner(
            doctor_id,
            patient_id,
            appointment_date,
            patient:patient_id (
              person:person_id (
                names,
                first_last_name,
                second_last_name
              )
            )
          )
        ''')
          .eq('appointment.doctor_id', doctorId)
          .order('follow_up_date', ascending: false);

      return (response as List)
          .map((json) => MedicalConsultationModel.fromJson(json))
          .toList();
    } catch (e) {
      print('Error al obtener consultas médicas del doctor: $e');
      throw Exception('Error al obtener consultas médicas del doctor: $e');
    }
  }

  //Obtener consultas médicas por paciente
  Future<List<MedicalConsultationModel>> getMedicalConsultationsByPatientId(
    int patientId,
  ) async {
    try {
      final response = await _client
          .from(_tableName)
          .select('''
          *,
          appointment!inner(
            doctor_id,
            patient_id,
            appointment_date,
            patient:patient_id (
              person:person_id (
                names,
                first_last_name,
                second_last_name
              )
            )
          )
        ''')
          .eq('appointment.patient_id', patientId)
          .order('follow_up_date', ascending: false);

      return (response as List)
          .map((json) => MedicalConsultationModel.fromJson(json))
          .toList();
    } catch (e) {
      print('Error al obtener consultas médicas del paciente: $e');
      throw Exception('Error al obtener consultas médicas del paciente: $e');
    }
  }

  //Obtener consultas medicas por id de appointment
  Future<List<MedicalConsultationModel>> getMedicalConsultationByAppointmentId(
    int appointmentId,
  ) async {
    try {
      final response = await _client
          .from(_tableName)
          .select('''
          *,
          appointment!inner(
            doctor_id,
            patient_id,
            appointment_date,
            patient:patient_id (
              person:person_id (
                names,
                first_last_name,
                second_last_name
              )
            )
          )
        ''')
          .eq('appointment.id', appointmentId)
          .order('follow_up_date', ascending: false);

      return (response as List)
          .map((json) => MedicalConsultationModel.fromJson(json))
          .toList();
    } catch (e) {
      print('Error al obtener consulta médica por ID de cita: $e');
      throw Exception('Error al obtener consulta médica por ID de cita: $e');
    }
  }

  //Obtener la cantidad de consultas médicas por doctor
  Future<int> getMedicalConsultationCountByDoctorId(int doctorId) async {
    try {
      final response = await _client
          .from(_tableName)
          .select()
          .eq('appointment.doctor_id', doctorId)
          .count();

      return response.count;
    } catch (e) {
      print('Error al obtener cantidad de consultas médicas del doctor: $e');
      return 0;
    }
  }
}
