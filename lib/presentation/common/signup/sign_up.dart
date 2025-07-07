import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_kawsay/application/common/sign_up_notifier.dart';
import 'package:project_3_kawsay/state/common/user_sign_up_data_state.dart';
import 'package:project_3_kawsay/presentation/common/signup/steps/doctor_data_step.dart';
import 'package:project_3_kawsay/presentation/common/signup/steps/personal_data_step.dart';
import 'package:project_3_kawsay/presentation/common/signup/steps/user_credentials_step.dart';
import 'package:project_3_kawsay/presentation/common/signup/steps/user_type_selection_step.dart';
import 'package:project_3_kawsay/state/common/sign_up_state.dart';

class SignUp extends ConsumerWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signUpState = ref.watch(signUpProvider);
    final signUpNotifier = ref.read(signUpProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro'),
        leading: signUpState.currentStep > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  signUpNotifier.previousStep();
                },
              )
            : null,
      ),
      body: Column(
        children: [
          _buildProgressIndicator(signUpState),
          Expanded(child: _buildCurrentStep(signUpState)),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator(SignUpState state) {
    final maxSteps = state.registrationData?.userType == UserType.doctor
        ? 4
        : 3;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: List.generate(maxSteps, (index) {
          final isActive = index <= state.currentStep;
          final isCompleted = index < state.currentStep;

          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 4,
              decoration: BoxDecoration(
                color: isActive
                    ? (isCompleted ? Colors.green : Colors.blue)
                    : Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCurrentStep(SignUpState state) {
    switch (state.currentStep) {
      case 0:
        return const UserTypeSelectionStep();
      case 1:
        return const PersonalDataStep();
      case 2:
        if (state.registrationData?.userType == UserType.doctor) {
          return const DoctorDataStep();
        } else {
          return const UserCredentialsStep();
        }
      case 3:
        return const UserCredentialsStep();
      default:
        return const UserTypeSelectionStep();
    }
  }
}
