import 'package:project_3_kawsay/model/common/person_model.dart';
import 'package:project_3_kawsay/model/doctor/doctor_model.dart';

class AuthModel {
  final bool isAuthenticated;
  final bool isLoading;
  final int? userId;
  final int? role;
  final PersonModel? person;
  final DoctorModel? doctor;

  AuthModel({
    required this.isAuthenticated,
    required this.isLoading,
    this.userId,
    this.role,
    this.person,
    this.doctor,
  });

  AuthModel copyWith({
    bool? isAuthenticated,
    bool? isLoading,
    int? userId,
    int? role,
    PersonModel? person,
    DoctorModel? doctor,
  }) {
    return AuthModel(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      userId: userId ?? this.userId,
      role: role ?? this.role,
      person: person ?? this.person,
      doctor: doctor ?? this.doctor,
    );
  }
}
