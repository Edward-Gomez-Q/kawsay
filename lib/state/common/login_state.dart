import 'package:flutter/widgets.dart';
import 'package:project_3_kawsay/model/common/person_model.dart';
import 'package:project_3_kawsay/model/doctor/doctor_model.dart';
import 'package:project_3_kawsay/model/patient/patient.dart';

class LoginState {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final GlobalKey<FormState> formKey;
  final bool obscurePassword;
  final bool isLoading;
  final bool isError;
  final String? error;
  final int? role;
  final int? userId;
  final PersonModel? person;
  final DoctorModel? doctor;
  final Patient? patient;
  LoginState({
    required this.emailController,
    required this.passwordController,
    required this.formKey,
    this.obscurePassword = true,
    this.isLoading = false,
    this.isError = false,
    this.error,
    this.role,
    this.userId,
    this.person,
    this.doctor,
    this.patient,
  });
  LoginState.empty()
    : emailController = TextEditingController(),
      passwordController = TextEditingController(),
      formKey = GlobalKey<FormState>(),
      isLoading = false,
      isError = false,
      obscurePassword = true,
      error = null,
      role = null,
      userId = null,
      person = null,
      doctor = null,
      patient = null;

  LoginState copyWith({
    TextEditingController? emailController,
    TextEditingController? passwordController,
    GlobalKey<FormState>? formKey,
    bool? obscurePassword,
    bool? isLoading,
    bool? isError,
    String? error,
    int? role,
    int? userId,
    PersonModel? person,
    DoctorModel? doctor,
    Patient? patient,
  }) {
    return LoginState(
      emailController: emailController ?? this.emailController,
      passwordController: passwordController ?? this.passwordController,
      formKey: formKey ?? this.formKey,
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
      error: error ?? this.error,
      role: role ?? this.role,
      userId: userId ?? this.userId,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      person: person ?? this.person,
      doctor: doctor ?? this.doctor,
      patient: patient ?? this.patient,
    );
  }

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }

  String toString2() {
    return 'LoginState(email: ${emailController.text}, password: ${passwordController.text}, isLoading: $isLoading, isError: $isError, error: $error, role: $role, userId: $userId, person: $person, doctor: $doctor, patient: $patient)';
  }
}
