import 'package:project_3_kawsay/model/common/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthUserRepositorySp {
  final SupabaseClient _client;
  static const String _tableName = 'auth_user';
  AuthUserRepositorySp({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;
  // CREATE - Crear un nuevo usuario
  Future<UserModel> createUser(UserModel user, int personId) async {
    try {
      final data = user.toMap();
      data.remove('id');
      data['person_id'] = personId;
      print('Creating user: $data');
      final response = await _client
          .from(_tableName)
          .insert(data)
          .select()
          .single();

      return UserModel.fromMap(response);
    } catch (e) {
      print('Error al crear usuario: $e');
      throw Exception('Error al crear usuario: $e');
    }
  }

  //Login
  Future<UserModel?> login(String email, String password) async {
    try {
      final response = await _client
          .from(_tableName)
          .select()
          .eq('email', email)
          .eq('password', password)
          .single();
      return response != null ? UserModel.fromMap(response) : null;
    } catch (e) {
      print('Error al iniciar sesión: $e');
      throw Exception('Error al iniciar sesión: $e');
    }
  }
}
