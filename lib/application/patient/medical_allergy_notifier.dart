import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_kawsay/data/sqflite/patient/repositories/medical_allergy_repository.dart';
import 'package:project_3_kawsay/model/patient/medical_allergy.dart';
import 'package:project_3_kawsay/state/patient/medical_allergy_state.dart';

class MedicalAllergyNotifier extends StateNotifier<MedicalAllergyState> {
  final MedicalAllergyRepository _repository;
  MedicalAllergyNotifier(this._repository) : super(MedicalAllergyState());
  // Cargar todas las alergias por ID del paciente
  Future<void> loadAllergies(int patientId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final allergies = await _repository.getAllByPatientId(patientId);
      state = state.copyWith(allergies: allergies, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        error: 'Error al cargar alergias: $e',
        isLoading: false,
      );
    }
  }

  // Crear nueva alergia
  Future<void> createAllergy(MedicalAllergy allergy) async {
    state = state.copyWith(isCreating: true, error: null);

    try {
      final id = await _repository.create(allergy);
      final newAllergy = MedicalAllergy(
        id: id,
        patientId: allergy.patientId,
        allergenFrom: allergy.allergenFrom,
        allergen: allergy.allergen,
        reaction: allergy.reaction,
        severity: allergy.severity,
      );

      state = state.copyWith(
        allergies: [...state.allergies, newAllergy],
        isCreating: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Error al crear alergia: $e',
        isCreating: false,
      );
    }
  }

  // Eliminar alergia
  Future<void> deleteAllergy(int id) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _repository.delete(id);
      state = state.copyWith(
        allergies: state.allergies
            .where((allergy) => allergy.id != id)
            .toList(),
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Error al eliminar alergia: $e',
        isLoading: false,
      );
    }
  }

  // Limpiar error
  void clearError() {
    state = state.copyWith(error: null);
  }
}

final medicalAllergyProvider =
    StateNotifierProvider<MedicalAllergyNotifier, MedicalAllergyState>((ref) {
      return MedicalAllergyNotifier(MedicalAllergyRepository());
    });
