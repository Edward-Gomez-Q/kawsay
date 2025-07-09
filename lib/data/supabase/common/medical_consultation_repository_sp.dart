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
}
