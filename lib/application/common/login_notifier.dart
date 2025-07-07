import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_kawsay/data/supabase/common/auth_user_repository_sp.dart';
import 'package:project_3_kawsay/data/supabase/common/doctor_repository_sp.dart';
import 'package:project_3_kawsay/data/supabase/common/person_repository_sp.dart';
import 'package:project_3_kawsay/data/supabase/common/role_user_reposiotry_sp.dart';
import 'package:project_3_kawsay/state/common/login_state.dart';

class LoginNotifier extends StateNotifier<LoginState> {
  final AuthUserRepositorySp _authUserRepository = AuthUserRepositorySp();
  final RoleUserReposiotrySp _roleUserRepository = RoleUserReposiotrySp();
  final DoctorRepositorySp _doctorRepository = DoctorRepositorySp();
  final PersonRepositorySp _personRepository = PersonRepositorySp();
  LoginNotifier() : super(LoginState.empty());

  void setEmail(String email) {
    state = state.copyWith(emailController: TextEditingController(text: email));
  }

  void setPassword(String password) {
    state = state.copyWith(
      passwordController: TextEditingController(text: password),
    );
  }

  void reset() {
    state = LoginState.empty();
  }

  Future<void> login() async {
    if (!state.formKey.currentState!.validate()) {
      return;
    }
    state = state.copyWith(isLoading: true, error: null);
    try {
      final user = await _authUserRepository.login(
        state.emailController.text,
        state.passwordController.text,
      );
      if (user != null) {
        final role = await _roleUserRepository.getRoleByUserId(user.id);
        if (role != null) {
          final person = await _personRepository.getPersonById(user.personId);
          if (person == null) {
            state = state.copyWith(error: 'Person not found for user');
            return;
          }
          state = state.copyWith(doctor: null);
          if (role == 1) {
            final doctor = await _doctorRepository.getDoctorByPersonId(
              person.id,
            );
            state = state.copyWith(doctor: doctor);
          }

          state = state.copyWith(
            role: role,
            userId: user.id,
            error: null,
            person: person,
          );
        } else {
          state = state.copyWith(error: 'User role not found');
        }
      } else {
        state = state.copyWith(error: 'Invalid email or password');
      }
    } catch (e) {
      state = state.copyWith(error: 'Login failed: $e');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

final loginProvider = StateNotifierProvider<LoginNotifier, LoginState>(
  (ref) => LoginNotifier(),
);
