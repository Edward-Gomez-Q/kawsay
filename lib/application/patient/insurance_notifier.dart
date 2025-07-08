import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_kawsay/data/sqflite/patient/repositories/insurance_repository.dart';
import 'package:project_3_kawsay/model/patient/insurance.dart';
import 'package:project_3_kawsay/state/patient/insurance_state.dart';

class InsuranceNotifier extends StateNotifier<InsuranceState> {
  final InsuranceRepository _repository;
  final int patientId;

  InsuranceNotifier(this._repository, this.patientId)
    : super(InsuranceState()) {
    loadInsurances();
  }

  Future<void> loadInsurances() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final insurances = await _repository.getAllByPatientId(patientId);
      state = state.copyWith(insurances: insurances, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error al cargar seguros: $e',
      );
    }
  }

  Future<void> createInsurance(Insurance insurance) async {
    try {
      await _repository.create(insurance);
      await loadInsurances();
    } catch (e) {
      state = state.copyWith(error: 'Error al crear seguro: $e');
    }
  }

  Future<void> deleteInsurance(int id) async {
    try {
      await _repository.delete(id);
      await loadInsurances();
    } catch (e) {
      state = state.copyWith(error: 'Error al eliminar seguro: $e');
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final insuranceProvider =
    StateNotifierProvider.family<InsuranceNotifier, InsuranceState, int>(
      (ref, patientId) => InsuranceNotifier(InsuranceRepository(), patientId),
    );
