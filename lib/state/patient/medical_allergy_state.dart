import 'package:project_3_kawsay/model/patient/medical_allergy.dart';

class MedicalAllergyState {
  final List<MedicalAllergy> allergies;
  final bool isLoading;
  final bool isCreating;
  final String? error;

  MedicalAllergyState({
    this.allergies = const [],
    this.isLoading = false,
    this.isCreating = false,
    this.error,
  });
  MedicalAllergyState copyWith({
    List<MedicalAllergy>? allergies,
    bool? isLoading,
    bool? isCreating,
    String? error,
  }) {
    return MedicalAllergyState(
      allergies: allergies ?? this.allergies,
      isLoading: isLoading ?? this.isLoading,
      isCreating: isCreating ?? this.isCreating,
      error: error ?? this.error,
    );
  }
}
