import 'package:project_3_kawsay/model/patient/medical_critical_info.dart';

class MedicalCriticalInfoState {
  final MedicalCriticalInfo? medicalCriticalInfo;
  final bool isLoading;
  final bool isEditing;
  final String? error;

  MedicalCriticalInfoState({
    this.medicalCriticalInfo,
    this.isLoading = false,
    this.isEditing = false,
    this.error,
  });
  MedicalCriticalInfoState copyWith({
    MedicalCriticalInfo? medicalCriticalInfo,
    bool? isLoading,
    bool? isEditing,
    String? error,
  }) {
    return MedicalCriticalInfoState(
      medicalCriticalInfo: medicalCriticalInfo ?? this.medicalCriticalInfo,
      isLoading: isLoading ?? this.isLoading,
      isEditing: isEditing ?? this.isEditing,
      error: error ?? this.error,
    );
  }
}
