import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_kawsay/data/sqflite/patient/repositories/vaccination_repository.dart';
import 'package:project_3_kawsay/model/patient/vaccination.dart';
import 'package:project_3_kawsay/state/patient/vaccination_state.dart';

class VaccinationNotifier extends StateNotifier<VaccinationState> {
  final VaccinationRepository _repository;
  final int patientId;

  VaccinationNotifier(this._repository, this.patientId)
    : super(VaccinationState()) {
    loadVaccinations();
  }

  Future<void> loadVaccinations() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final vaccinations = await _repository.getAllByPatientId(patientId);
      state = state.copyWith(vaccinations: vaccinations, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error al cargar vacunas: $e',
      );
    }
  }

  Future<void> createVaccination(Vaccination vaccination) async {
    try {
      await _repository.create(vaccination);
      await loadVaccinations();
    } catch (e) {
      state = state.copyWith(error: 'Error al registrar vacuna: $e');
    }
  }

  Future<void> deleteVaccination(int id) async {
    try {
      await _repository.delete(id);
      await loadVaccinations();
    } catch (e) {
      state = state.copyWith(error: 'Error al eliminar vacuna: $e');
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final vaccinationProvider =
    StateNotifierProvider.family<VaccinationNotifier, VaccinationState, int>(
      (ref, patientId) =>
          VaccinationNotifier(VaccinationRepository(), patientId),
    );
