import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_kawsay/data/sqflite/patient/repositories/medical_critical_info_repository.dart';
import 'package:project_3_kawsay/model/patient/medical_critical_info.dart';
import 'package:project_3_kawsay/state/patient/medical_critical_info_state.dart';

class MedicalCriticalInfoNotifier
    extends StateNotifier<MedicalCriticalInfoState> {
  final MedicalCriticalInfoRepository _repository;

  MedicalCriticalInfoNotifier(this._repository)
    : super(MedicalCriticalInfoState());

  // Cargar información médica crítica por ID del paciente
  Future<void> loadMedicalInfo(int patientId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final medicalInfo = await _repository.getByPatientId(patientId);
      state = state.copyWith(
        medicalCriticalInfo: medicalInfo,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Error al cargar información médica: $e',
        isLoading: false,
      );
    }
  }

  // Actualizar información médica crítica
  Future<void> updateMedicalInfo(MedicalCriticalInfo updatedInfo) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _repository.update(updatedInfo);
      state = state.copyWith(
        medicalCriticalInfo: updatedInfo,
        isLoading: false,
        isEditing: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Error al actualizar información médica: $e',
        isLoading: false,
      );
    }
  }

  // Alternar modo de edición
  void toggleEditing() {
    state = state.copyWith(isEditing: !state.isEditing);
  }

  // Cancelar edición
  void cancelEditing() {
    state = state.copyWith(isEditing: false);
  }

  // Limpiar error
  void clearError() {
    state = state.copyWith(error: null);
  }
}

final medicalCriticalInfoProvider =
    StateNotifierProvider<
      MedicalCriticalInfoNotifier,
      MedicalCriticalInfoState
    >((ref) => MedicalCriticalInfoNotifier(MedicalCriticalInfoRepository()));
