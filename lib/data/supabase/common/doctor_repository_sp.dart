import 'package:project_3_kawsay/model/doctor/doctor_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DoctorRepositorySp {
  final SupabaseClient _client;
  static const String _tableName = 'doctor';
  DoctorRepositorySp({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;
  // CREATE - Crear un nuevo doctor
  Future<DoctorModel> createDoctor(
    DoctorModel doctorModel,
    int personId,
  ) async {
    try {
      final data = doctorModel.toMap();
      data.remove('id');
      data['person_id'] = personId;
      final response = await _client
          .from(_tableName)
          .insert(data)
          .select()
          .single();
      return DoctorModel.fromMap(response);
    } catch (e) {
      throw Exception('Error al crear doctor: $e');
    }
  }

  Future<DoctorModel> getDoctorByPersonId(int personId) async {
    try {
      final response = await _client
          .from(_tableName)
          .select()
          .eq('person_id', personId)
          .single();
      return DoctorModel.fromMap(response);
    } catch (e) {
      throw Exception('Error al obtener doctor por ID de persona: $e');
    }
  }
}
