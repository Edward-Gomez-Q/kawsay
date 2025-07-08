import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_kawsay/state/patient/patient_screens_state.dart';

class PatientScreensNotifier extends StateNotifier<PatientScreensState> {
  PatientScreensNotifier() : super(PatientScreensState());

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
