import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_kawsay/application/common/sign_up_notifier.dart';
import 'package:project_3_kawsay/model/common/user_model.dart';

class UserCredentialsState {
  final TextEditingController email;
  final TextEditingController password;
  final TextEditingController confirmPassword;
  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final GlobalKey<FormState> formKey;

  UserCredentialsState({
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.formKey,
    this.obscurePassword = true,
    this.obscureConfirmPassword = true,
  });
  UserCredentialsState.empty()
    : email = TextEditingController(),
      password = TextEditingController(),
      confirmPassword = TextEditingController(),
      formKey = GlobalKey<FormState>(),
      obscurePassword = false,
      obscureConfirmPassword = false;

  UserCredentialsState copyWith({
    TextEditingController? email,
    TextEditingController? password,
    TextEditingController? confirmPassword,
    GlobalKey<FormState>? formKey,
    bool? obscurePassword,
    bool? obscureConfirmPassword,
  }) {
    return UserCredentialsState(
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      formKey: formKey ?? this.formKey,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      obscureConfirmPassword:
          obscureConfirmPassword ?? this.obscureConfirmPassword,
    );
  }

  void dispose() {
    email.dispose();
    password.dispose();
    confirmPassword.dispose();
  }

  UserModel toUserModel() {
    return UserModel(
      id: 0,
      email: email.text,
      password: password.text,
      personId: 0,
    );
  }
}

final userFormProvider = StateProvider<UserCredentialsState>((ref) {
  final signUp = ref.watch(signUpProvider).registrationData?.userCredentials;
  return UserCredentialsState(
    email: TextEditingController(text: signUp?.email ?? ''),
    password: TextEditingController(text: signUp?.password ?? ''),
    confirmPassword: TextEditingController(text: ''),
    formKey: GlobalKey<FormState>(),
  );
});
