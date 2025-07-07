import 'package:supabase_flutter/supabase_flutter.dart';

class RoleUserReposiotrySp {
  final SupabaseClient _client;
  final String _tableName = 'role_user';

  RoleUserReposiotrySp({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  // CREATE - Crear una nueva relación entre rol y usuario
  Future<void> createRoleUser(int authRoleId, int authUserId) async {
    try {
      final response = await _client
          .from(_tableName)
          .insert({'auth_role_id': authRoleId, 'auth_user_id': authUserId})
          .select()
          .single();

      print('RoleUser created: $response');
    } catch (e) {
      print('Error al crear RoleUser: $e');
      throw Exception('Error al crear RoleUser: $e');
    }
  }
}
