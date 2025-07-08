import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_kawsay/data/sqflite/patient/repositories/chronic_condition_repository.dart';
import 'package:project_3_kawsay/model/patient/chronic_condition.dart';
import 'package:project_3_kawsay/state/patient/chronic_condition_state.dart';

class ChronicConditionNotifier extends StateNotifier<ChronicConditionState> {
  final ChronicConditionRepository _repository;

  ChronicConditionNotifier(this._repository) : super(ChronicConditionState());

  // Cargar todas las condiciones crónicas por ID del paciente
  Future<void> loadConditions(int patientId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final conditions = await _repository.getAllByPatientId(patientId);
      state = state.copyWith(conditions: conditions, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        error: 'Error al cargar condiciones crónicas: $e',
        isLoading: false,
      );
    }
  }

  // Crear nueva condición crónica
  Future<void> createCondition(ChronicCondition condition) async {
    state = state.copyWith(isCreating: true, error: null);

    try {
      final id = await _repository.create(condition);
      final newCondition = ChronicCondition(
        id: id,
        patientId: condition.patientId,
        condition: condition.condition,
        diagnosisDate: condition.diagnosisDate,
        controlled: condition.controlled,
      );

      state = state.copyWith(
        conditions: [...state.conditions, newCondition],
        isCreating: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Error al crear condición crónica: $e',
        isCreating: false,
      );
    }
  }

  // Eliminar condición crónica
  Future<void> deleteCondition(int id) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _repository.delete(id);
      state = state.copyWith(
        conditions: state.conditions
            .where((condition) => condition.id != id)
            .toList(),
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Error al eliminar condición crónica: $e',
        isLoading: false,
      );
    }
  }

  // Limpiar error
  void clearError() {
    state = state.copyWith(error: null);
  }
}

final chronicConditionProvider =
    StateNotifierProvider<ChronicConditionNotifier, ChronicConditionState>((
      ref,
    ) {
      return ChronicConditionNotifier(ChronicConditionRepository());
    });
