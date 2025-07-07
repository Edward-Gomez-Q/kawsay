import 'package:project_3_kawsay/state/common/user_sign_up_data_state.dart';

class SignUpState {
  final int currentStep;
  final UserSignUpData? registrationData;
  final bool isLoading;
  final String? error;
  SignUpState({
    this.currentStep = 0,
    this.registrationData,
    this.isLoading = false,
    this.error,
  });
  // CopyWith method
  SignUpState copyWith({
    int? currentStep,
    UserSignUpData? registrationData,
    bool? isLoading,
    String? error,
  }) {
    return SignUpState(
      currentStep: currentStep ?? this.currentStep,
      registrationData: registrationData ?? this.registrationData,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
