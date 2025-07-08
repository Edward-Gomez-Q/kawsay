import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_kawsay/data/sqflite/patient/repositories/surgical_history_repository.dart';
import 'package:project_3_kawsay/model/patient/surgical_history.dart';
import 'package:project_3_kawsay/state/patient/surgical_history_state.dart';

class SurgicalHistoryNotifier extends StateNotifier<SurgicalHistoryState> {
  final SurgicalHistoryRepository _repository;

  SurgicalHistoryNotifier(this._repository)
    : super(const SurgicalHistoryState());

  Future<void> loadSurgicalHistory(int patientId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final surgicalHistory = await _repository.getAllByPatientId(patientId);
      state = state.copyWith(
        surgicalHistoryList: surgicalHistory,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Error al cargar historial quirúrgico: $e',
        isLoading: false,
      );
    }
  }

  Future<void> createSurgicalHistory(SurgicalHistory surgery) async {
    state = state.copyWith(isCreating: true, error: null);

    try {
      final id = await _repository.create(surgery);
      final newSurgical = SurgicalHistory(
        id: id,
        patientId: surgery.patientId,
        complications: surgery.complications,
        surgery: surgery.surgery,
        surgeryDate: surgery.surgeryDate,
        noteComplications: surgery.noteComplications,
      );
      state = state.copyWith(
        surgicalHistoryList: [...state.surgicalHistoryList, newSurgical],
        isCreating: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Error al crear historial quirúrgico: $e',
        isCreating: false,
      );
    }
  }

  Future<void> deleteSurgicalHistory(int id, int patientId) async {
    try {
      await _repository.delete(id);
      state = state.copyWith(
        surgicalHistoryList: state.surgicalHistoryList
            .where((surgery) => surgery.id != id)
            .toList(),
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Error al eliminar historial quirúrgico: $e',
      );
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final surgicalHistoryProvider =
    StateNotifierProvider<SurgicalHistoryNotifier, SurgicalHistoryState>((ref) {
      return SurgicalHistoryNotifier(SurgicalHistoryRepository());
    });
