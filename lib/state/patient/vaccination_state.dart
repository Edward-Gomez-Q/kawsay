import 'package:project_3_kawsay/model/patient/vaccination.dart';

class VaccinationState {
  final List<Vaccination> vaccinations;
  final bool isLoading;
  final String? error;

  VaccinationState({
    this.vaccinations = const [],
    this.isLoading = false,
    this.error,
  });

  VaccinationState copyWith({
    List<Vaccination>? vaccinations,
    bool? isLoading,
    String? error,
  }) {
    return VaccinationState(
      vaccinations: vaccinations ?? this.vaccinations,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}
