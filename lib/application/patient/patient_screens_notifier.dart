import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:project_3_kawsay/data/sqflite/patient/repositories/patient_data_repository.dart';
import 'package:project_3_kawsay/state/patient/patient_screens_state.dart';

class PatientScreensNotifier extends StateNotifier<PatientScreensState> {
  final PatientDataRepository _repository = PatientDataRepository();
  PatientScreensNotifier() : super(PatientScreensState()) {
    _loadInitData();
  }
  Future<void> _loadInitData() async {
    final patient = await _repository.getPatientById(1);
    if (patient != null) {
      state = state.copyWith(isLoading: false);
    } else {
      state = state.copyWith(isLoading: false);
    }
  }

  void goToStep(int step) {
    state = state.copyWith(currentStep: step);
  }

  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  void reset() {
    state = PatientScreensState();
  }
}

final patientScreensProvider =
    StateNotifierProvider<PatientScreensNotifier, PatientScreensState>(
      (ref) => PatientScreensNotifier(),
    );
