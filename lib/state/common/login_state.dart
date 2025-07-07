import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_kawsay/model/common/person_model.dart';
import 'package:project_3_kawsay/model/doctor/doctor_model.dart';

class LoginState {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final GlobalKey<FormState> formKey;
  final bool obscurePassword;
  final bool isLoading;
  final String? error;
  final int? role;
  final int? userId;
  final PersonModel? person;
  final DoctorModel? doctor;
  LoginState({
    required this.emailController,
    required this.passwordController,
    required this.formKey,
    this.obscurePassword = true,
    this.isLoading = false,
    this.error,
    this.role,
    this.userId,
    this.person,
    this.doctor,
  });
  LoginState.empty()
    : emailController = TextEditingController(),
      passwordController = TextEditingController(),
      formKey = GlobalKey<FormState>(),
      isLoading = false,
      obscurePassword = true,
      error = null,
      role = null,
      userId = null,
      person = null,
      doctor = null;
  LoginState copyWith({
    TextEditingController? emailController,
    TextEditingController? passwordController,
    GlobalKey<FormState>? formKey,
    bool? obscurePassword,
    bool? isLoading,
    String? error,
    int? role,
    int? userId,
    PersonModel? person,
    DoctorModel? doctor,
  }) {
    return LoginState(
      emailController: emailController ?? this.emailController,
      passwordController: passwordController ?? this.passwordController,
      formKey: formKey ?? this.formKey,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      role: role ?? this.role,
      userId: userId ?? this.userId,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      person: person ?? this.person,
      doctor: doctor ?? this.doctor,
    );
  }

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }
}

final loginStateProvider = StateProvider<LoginState>((ref) {
  return LoginState.empty();
});
