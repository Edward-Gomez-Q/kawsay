import 'package:project_3_kawsay/model/common/appointment_model.dart';
import 'package:project_3_kawsay/model/doctor/appointment_with_patient_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppointmentRepositorySp {
  final SupabaseClient _client;
  static const String _tableName = 'appointment';
  AppointmentRepositorySp({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  Future<AppointmentModel?> createAppointment(
    AppointmentModel appointment,
  ) async {
    try {
      final data = appointment.toJson();
      data.remove('id');
      print('Creating appointment: $data');
      final response = await _client
          .from(_tableName)
          .insert(data)
          .select()
          .single();

      return AppointmentModel.fromJson(response);
    } catch (e) {
      print('Error al crear cita: $e');
      return null;
    }
  }

  Future<List<AppointmentWithPatientModel>> getAppointmentsByDoctor(
    int doctorId,
  ) async {
    try {
      final response = await _client
          .from(_tableName)
          .select('''
            id,
            sharing_session_id,
            appointment_date,
            appointment_status,
            consultation_type,
            patient_id,
            doctor_id,
            patient:patient_id (
              person:person_id (
                names,
                first_last_name,
                second_last_name
              )
            ),
            sharing_session:sharing_session_id (
              share_code
            )
          ''')
          .eq('doctor_id', doctorId)
          .order('appointment_date', ascending: false);

      return (response as List)
          .map((json) => AppointmentWithPatientModel.fromJson(json))
          .toList();
    } catch (e) {
      print('Error al obtener citas del doctor: $e');
      return [];
    }
  }

  //Obtener la cantidad de citas por doctor
  Future<int> getAppointmentCountByDoctor(int doctorId) async {
    try {
      final response = await _client
          .from(_tableName)
          .select()
          .eq('doctor_id', doctorId)
          .count();

      return response.count;
    } catch (e) {
      print('Error al obtener cantidad de citas del doctor: $e');
      return 0;
    }
  }
}
