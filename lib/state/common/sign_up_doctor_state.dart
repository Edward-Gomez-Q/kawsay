import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_kawsay/application/common/sign_up_notifier.dart';

class SignUpDoctorState {
  final TextEditingController specialization;
  final TextEditingController medicalCollege;
  final TextEditingController yearsExperience;
  final GlobalKey<FormState> formKey;
  SignUpDoctorState({
    required this.specialization,
    required this.medicalCollege,
    required this.yearsExperience,
    required this.formKey,
  });
  SignUpDoctorState.empty()
    : specialization = TextEditingController(),
      medicalCollege = TextEditingController(),
      yearsExperience = TextEditingController(),
      formKey = GlobalKey<FormState>();
  SignUpDoctorState copyWith({
    TextEditingController? specialization,
    TextEditingController? medicalCollege,
    TextEditingController? yearsExperience,
    GlobalKey<FormState>? formKey,
  }) {
    return SignUpDoctorState(
      specialization: specialization ?? this.specialization,
      medicalCollege: medicalCollege ?? this.medicalCollege,
      yearsExperience: yearsExperience ?? this.yearsExperience,
      formKey: formKey ?? this.formKey,
    );
  }

  void dispose() {
    specialization.dispose();
    medicalCollege.dispose();
    yearsExperience.dispose();
  }
}

final signUpDoctorProvider = StateProvider<SignUpDoctorState>((ref) {
  final medicalData = ref.watch(signUpProvider).registrationData?.medicalData;
  return SignUpDoctorState(
    specialization: TextEditingController(
      text: medicalData?.specialization ?? '',
    ),
    medicalCollege: TextEditingController(
      text: medicalData?.medicalCollege ?? '',
    ),
    yearsExperience: TextEditingController(
      text: medicalData?.yearsExperience.toString() ?? '',
    ),
    formKey: GlobalKey<FormState>(),
  );
});
