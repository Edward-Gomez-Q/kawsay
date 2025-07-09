import 'package:project_3_kawsay/model/common/appointment_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppointmentRepositorySp {
  final SupabaseClient _client;
  static const String _tableName = 'appointment';
  AppointmentRepositorySp({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  // CREATE - Crear una nueva cita
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
}
