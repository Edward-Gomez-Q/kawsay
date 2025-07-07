import 'package:project_3_kawsay/model/common/person_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PersonRepositorySp {
  final SupabaseClient _client;
  static const String _tableName = 'person';
  PersonRepositorySp({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;
  // CREATE - Crear una nueva persona
  Future<PersonModel> createPerson(PersonModel person) async {
    print('Creating person: ${person.toMap()}');
    try {
      final data = person.toMap();
      data.remove('id');
      final response = await _client
          .from(_tableName)
          .insert(data)
          .select()
          .single();

      return PersonModel.fromMap(response);
    } catch (e) {
      print('Error al crear persona: $e');
      throw Exception('Error al crear persona: $e');
    }
  }

  // READ - Obtener todas las personas
  Future<List<PersonModel>> getAllPersons() async {
    try {
      final response = await _client
          .from(_tableName)
          .select()
          .order('id', ascending: true);

      return (response as List)
          .map((data) => PersonModel.fromMap(data))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener personas: $e');
    }
  }

  // READ - Obtener persona por ID
  Future<PersonModel?> getPersonById(int id) async {
    try {
      final response = await _client
          .from(_tableName)
          .select()
          .eq('id', id)
          .maybeSingle();

      if (response == null) return null;
      return PersonModel.fromMap(response);
    } catch (e) {
      throw Exception('Error al obtener persona por ID: $e');
    }
  }

  // READ - Buscar personas por nombre
  Future<List<PersonModel>> searchPersonsByName(String name) async {
    try {
      final response = await _client
          .from(_tableName)
          .select()
          .ilike('names', '%$name%')
          .order('names', ascending: true);

      return (response as List)
          .map((data) => PersonModel.fromMap(data))
          .toList();
    } catch (e) {
      throw Exception('Error al buscar personas: $e');
    }
  }

  // READ - Buscar persona por documento
  Future<PersonModel?> getPersonByDocumentId(String documentId) async {
    try {
      final response = await _client
          .from(_tableName)
          .select()
          .eq('document_id', documentId)
          .maybeSingle();

      if (response == null) return null;
      return PersonModel.fromMap(response);
    } catch (e) {
      throw Exception('Error al buscar persona por documento: $e');
    }
  }

  // UPDATE - Actualizar persona
  Future<PersonModel> updatePerson(PersonModel person) async {
    try {
      final response = await _client
          .from(_tableName)
          .update(person.toMap())
          .eq('id', person.id)
          .select()
          .single();

      return PersonModel.fromMap(response);
    } catch (e) {
      throw Exception('Error al actualizar persona: $e');
    }
  }

  // DELETE - Eliminar persona por ID
  Future<void> deletePerson(int id) async {
    try {
      await _client.from(_tableName).delete().eq('id', id);
    } catch (e) {
      throw Exception('Error al eliminar persona: $e');
    }
  }

  // READ - Obtener personas con paginación
  Future<List<PersonModel>> getPersonsPaginated({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final from = (page - 1) * limit;
      final to = from + limit - 1;

      final response = await _client
          .from(_tableName)
          .select()
          .range(from, to)
          .order('id', ascending: true);

      return (response as List)
          .map((data) => PersonModel.fromMap(data))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener personas paginadas: $e');
    }
  }

  // READ - Contar total de personas
  Future<int> getPersonsCount() async {
    try {
      final response = await _client
          .from(_tableName)
          .select('*')
          .count(CountOption.exact);

      return response.count;
    } catch (e) {
      throw Exception('Error al contar personas: $e');
    }
  }

  // READ - Filtrar personas por tipo de acceso
  Future<List<PersonModel>> getPersonsByAccessType(int accessType) async {
    try {
      final response = await _client
          .from(_tableName)
          .select()
          .eq('access_type', accessType)
          .order('names', ascending: true);

      return (response as List)
          .map((data) => PersonModel.fromMap(data))
          .toList();
    } catch (e) {
      throw Exception('Error al filtrar personas por tipo de acceso: $e');
    }
  }

  // BATCH OPERATIONS - Crear múltiples personas
  Future<List<PersonModel>> createMultiplePersons(
    List<PersonModel> persons,
  ) async {
    try {
      final dataList = persons.map((person) {
        final data = person.toMap();
        data.remove('id'); // Remover ID para que Supabase lo genere
        return data;
      }).toList();

      final response = await _client.from(_tableName).insert(dataList).select();

      return (response as List)
          .map((data) => PersonModel.fromMap(data))
          .toList();
    } catch (e) {
      throw Exception('Error al crear múltiples personas: $e');
    }
  }

  // UTILITY - Verificar si existe una persona por documento
  Future<bool> existsByDocumentId(String documentId) async {
    try {
      final response = await _client
          .from(_tableName)
          .select('id')
          .eq('document_id', documentId)
          .maybeSingle();

      return response != null;
    } catch (e) {
      throw Exception('Error al verificar existencia por documento: $e');
    }
  }
}
