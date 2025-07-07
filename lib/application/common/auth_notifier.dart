import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_kawsay/state/common/auth_state.dart';

class AuthNotifier extends StateNotifier<AuthModel> {
  AuthNotifier()
    : super(
        AuthModel(
          isAuthenticated: false,
          isLoading: false,
          role: null,
          userId: null,
        ),
      );

  void login(int userId, int role) {
    state = state.copyWith(
      isAuthenticated: true,
      isLoading: false,
      role: role,
      userId: userId,
    );
  }

  //Implemntar logout
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthModel>(
  (ref) => AuthNotifier(),
);
