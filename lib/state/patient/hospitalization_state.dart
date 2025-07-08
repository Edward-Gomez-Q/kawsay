import 'package:project_3_kawsay/model/patient/hospitalization.dart';

class HospitalizationState {
  final List<Hospitalization> hospitalizations;
  final bool isLoading;
  final String? error;

  HospitalizationState({
    this.hospitalizations = const [],
    this.isLoading = false,
    this.error,
  });

  HospitalizationState copyWith({
    List<Hospitalization>? hospitalizations,
    bool? isLoading,
    String? error,
  }) {
    return HospitalizationState(
      hospitalizations: hospitalizations ?? this.hospitalizations,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}
