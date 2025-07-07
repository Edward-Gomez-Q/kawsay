import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_kawsay/model/common/person_model.dart';
import 'package:project_3_kawsay/model/doctor/doctor_model.dart';
import 'package:project_3_kawsay/state/common/auth_state.dart';

class AuthNotifier extends StateNotifier<AuthModel> {
  AuthNotifier()
    : super(
        AuthModel(
          isAuthenticated: false,
          isLoading: false,
          role: null,
          userId: null,
          person: null,
          doctor: null,
        ),
      );

  void login(int userId, int role, PersonModel? person, DoctorModel? doctor) {
    state = state.copyWith(
      isAuthenticated: true,
      isLoading: false,
      role: role,
      userId: userId,
      person: person,
    );
    if (doctor != null) {
      state = state.copyWith(doctor: doctor);
    }
  }

  void logout() {
    state = AuthModel(
      isAuthenticated: false,
      isLoading: false,
      role: null,
      userId: null,
      person: null,
      doctor: null,
    );
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthModel>(
  (ref) => AuthNotifier(),
);
