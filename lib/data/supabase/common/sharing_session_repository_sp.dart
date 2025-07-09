import 'package:project_3_kawsay/model/common/sharing_session_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SharingSessionRepositorySp {
  final SupabaseClient _client;
  final String _tableName = 'sharing_session';
  SharingSessionRepositorySp({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;
  // CREATE - Crear una nueva sesión de compartición
  Future<SharingSessionModel> createSharingSession(
    SharingSessionModel session,
  ) async {
    try {
      final data = session.toMap();
      data.remove('id');
      final response = await _client
          .from(_tableName)
          .insert(data)
          .select()
          .single();
      return SharingSessionModel.fromMap(response);
    } catch (e) {
      print('Error al crear sesión de compartición: $e');
      throw Exception('Error al crear sesión de compartición: $e');
    }
  }

  // Obtener una sesión de compartición por share_code
  Future<SharingSessionModel?> getSharingSessionByShareCode(
    String shareCode,
  ) async {
    try {
      final response = await _client
          .from(_tableName)
          .select()
          .eq('share_code', shareCode)
          .single();
      return SharingSessionModel.fromMap(response);
    } catch (e) {
      if (e is PostgrestException && e.code == 'PGRST116') {
        return null;
      }
      throw Exception('Error al obtener sesión de compartición: $e');
    }
  }
}
