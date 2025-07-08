import 'package:project_3_kawsay/model/patient/insurance.dart';

class InsuranceState {
  final List<Insurance> insurances;
  final bool isLoading;
  final String? error;

  InsuranceState({
    this.insurances = const [],
    this.isLoading = false,
    this.error,
  });

  InsuranceState copyWith({
    List<Insurance>? insurances,
    bool? isLoading,
    String? error,
  }) {
    return InsuranceState(
      insurances: insurances ?? this.insurances,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}
