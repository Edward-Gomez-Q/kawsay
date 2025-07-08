import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_kawsay/data/sqflite/patient/repositories/emergency_contact_repository.dart';
import 'package:project_3_kawsay/model/patient/emergency_contact.dart';
import 'package:project_3_kawsay/state/patient/emergency_contact_state.dart';

class EmergencyContactNotifier extends StateNotifier<EmergencyContactState> {
  final EmergencyContactRepository _repository;
  final int patientId;

  EmergencyContactNotifier(this._repository, this.patientId)
    : super(EmergencyContactState());

  Future<void> loadContacts() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final contacts = await _repository.getAllByPatientId(patientId);
      state = state.copyWith(contacts: contacts, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error al cargar contactos: $e',
      );
    }
  }

  Future<void> createContact(EmergencyContact contact) async {
    try {
      await _repository.create(contact);
      await loadContacts(); // Recargar la lista
    } catch (e) {
      state = state.copyWith(error: 'Error al crear contacto: $e');
    }
  }

  Future<void> deleteContact(int id) async {
    try {
      await _repository.delete(id);
      await loadContacts(); // Recargar la lista
    } catch (e) {
      state = state.copyWith(error: 'Error al eliminar contacto: $e');
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final emergencyContactProvider =
    StateNotifierProvider.family<
      EmergencyContactNotifier,
      EmergencyContactState,
      int
    >(
      (ref, patientId) =>
          EmergencyContactNotifier(EmergencyContactRepository(), patientId),
    );
