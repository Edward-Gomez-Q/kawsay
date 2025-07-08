import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_kawsay/data/sqflite/patient/repositories/lifestyle_repository.dart';
import 'package:project_3_kawsay/model/patient/lifestyle.dart';
import 'package:project_3_kawsay/state/patient/lifestyle_state.dart';

class LifestyleNotifier extends StateNotifier<LifestyleState> {
  final LifestyleRepository _repository;
  final int patientId;

  LifestyleNotifier(this._repository, this.patientId) : super(LifestyleState());

  Future<void> loadLifestyle() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final lifestyle = await _repository.getByPatientId(patientId);
      state = state.copyWith(lifestyle: lifestyle, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error al cargar estilo de vida: $e',
      );
    }
  }

  Future<void> updateLifestyle(Lifestyle lifestyle) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _repository.update(lifestyle);
      state = state.copyWith(
        lifestyle: lifestyle,
        isLoading: false,
        isEditing: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error al actualizar estilo de vida: $e',
      );
    }
  }

  void toggleEditing() {
    state = state.copyWith(isEditing: !state.isEditing);
  }

  void cancelEditing() {
    state = state.copyWith(isEditing: false);
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final lifestyleProvider =
    StateNotifierProvider.family<LifestyleNotifier, LifestyleState, int>(
      (ref, patientId) => LifestyleNotifier(LifestyleRepository(), patientId),
    );
