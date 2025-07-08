import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_kawsay/data/sqflite/patient/repositories/family_history_repository.dart';
import 'package:project_3_kawsay/model/patient/family_history.dart';
import 'package:project_3_kawsay/state/patient/family_history_state.dart';

class FamilyHistoryNotifier extends StateNotifier<FamilyHistoryState> {
  final FamilyHistoryRepository _repository;
  FamilyHistoryNotifier(this._repository) : super(FamilyHistoryState());
  Future<void> loadFamilyHistory(int patientId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final familyHistory = await _repository.getAllByPatientId(patientId);
      state = state.copyWith(
        familyHistoryList: familyHistory,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Error al cargar historial familiar: $e',
        isLoading: false,
      );
    }
  }

  Future<void> createFamilyHistory(FamilyHistory history) async {
    state = state.copyWith(isCreating: true, error: null);

    try {
      final id = await _repository.create(history);
      final newHistory = FamilyHistory(
        id: id,
        patientId: history.patientId,
        relationship: history.relationship,
        condition: history.condition,
        ageOfOnset: history.ageOfOnset,
      );
      state = state.copyWith(
        familyHistoryList: [...state.familyHistoryList, newHistory],
        isCreating: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Error al crear historial familiar: $e',
        isCreating: false,
      );
    }
  }

  Future<void> deleteFamilyHistory(int id, int patientId) async {
    try {
      await _repository.delete(id);
      state = state.copyWith(
        familyHistoryList: state.familyHistoryList
            .where((history) => history.id != id)
            .toList(),
      );
    } catch (e) {
      state = state.copyWith(error: 'Error al eliminar historial familiar: $e');
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final familyHistoryProvider =
    StateNotifierProvider<FamilyHistoryNotifier, FamilyHistoryState>((ref) {
      return FamilyHistoryNotifier(FamilyHistoryRepository());
    });
