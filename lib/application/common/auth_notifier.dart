import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_kawsay/model/common/auth_model.dart';
import 'package:project_3_kawsay/model/common/person_model.dart';
import 'package:project_3_kawsay/model/common/user_model.dart';

class AuthNotifier extends StateNotifier<AuthModel> {
  AuthNotifier()
    : super(
        AuthModel(
          isAuthenticated: false,
          isLoading: false,
          isPatient: false,
          user: null,
          errorMessage: null,
          token: null,
          userId: null,
          mail: null,
        ),
      );

  void login(PersonModel user, String token, String userId, String userName) {
    state = state.copyWith(
      isAuthenticated: true,
      isLoading: false,
      user: user,
      token: token,
      userId: userId,
      mail: userName,
    );
  }

  void logout() {
    state = AuthModel(
      isAuthenticated: false,
      isLoading: false,
      isPatient: false,
      user: null,
      errorMessage: null,
      token: null,
      userId: null,
      mail: null,
    );
  }

  void signUp(UserModel user) {}
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthModel>(
  (ref) => AuthNotifier(),
);
