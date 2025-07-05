import 'package:project_3_kawsay/model/common/person_model.dart';

class AuthModel {
  final bool isAuthenticated;
  final bool isLoading;
  final bool isPatient;
  final PersonModel? user;
  final String? errorMessage;
  final String? token;
  final String? userId;
  final String? mail;

  AuthModel({
    required this.isAuthenticated,
    required this.isLoading,
    required this.isPatient,
    this.user,
    this.errorMessage,
    this.token,
    this.userId,
    this.mail,
  });

  AuthModel copyWith({
    bool? isAuthenticated,
    bool? isLoading,
    bool? isPatient,
    PersonModel? user,
    String? errorMessage,
    String? token,
    String? userId,
    String? mail,
  }) {
    return AuthModel(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      isPatient: isPatient ?? this.isPatient,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
      token: token ?? this.token,
      userId: userId ?? this.userId,
      mail: mail ?? this.mail,
    );
  }
}
