import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_kawsay/data/sqflite/patient/repositories/hospitalization_repository.dart';
import 'package:project_3_kawsay/model/patient/hospitalization.dart';
import 'package:project_3_kawsay/state/patient/hospitalization_state.dart';

class HospitalizationNotifier extends StateNotifier<HospitalizationState> {
  final HospitalizationRepository _repository;
  final int patientId;

  HospitalizationNotifier(this._repository, this.patientId)
    : super(HospitalizationState()) {
    loadHospitalizations();
  }

  Future<void> loadHospitalizations() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final hospitalizations = await _repository.getAllByPatientId(patientId);
      state = state.copyWith(
        hospitalizations: hospitalizations,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error al cargar hospitalizaciones: $e',
      );
    }
  }

  Future<void> createHospitalization(Hospitalization hospitalization) async {
    try {
      await _repository.create(hospitalization);
      await loadHospitalizations();
    } catch (e) {
      state = state.copyWith(error: 'Error al crear hospitalización: $e');
    }
  }

  Future<void> deleteHospitalization(int id) async {
    try {
      await _repository.delete(id);
      await loadHospitalizations(); // Recargar la lista
    } catch (e) {
      state = state.copyWith(error: 'Error al eliminar hospitalización: $e');
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final hospitalizationProvider =
    StateNotifierProvider.family<
      HospitalizationNotifier,
      HospitalizationState,
      int
    >(
      (ref, patientId) =>
          HospitalizationNotifier(HospitalizationRepository(), patientId),
    );
