import 'package:project_3_kawsay/model/common/medical_consultation_model.dart';

class DiagnosticsState {
  final List<MedicalConsultationModel> consultations;
  final bool isLoading;
  final String? error;

  const DiagnosticsState({
    this.consultations = const [],
    this.isLoading = false,
    this.error,
  });
  DiagnosticsState copyWith({
    List<MedicalConsultationModel>? consultations,
    bool? isLoading,
    String? error,
  }) {
    return DiagnosticsState(
      consultations: consultations ?? this.consultations,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
