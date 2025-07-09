import 'package:project_3_kawsay/model/common/person_model.dart';
import 'package:project_3_kawsay/model/doctor/doctor_model.dart';
import 'package:project_3_kawsay/model/patient/patient.dart';

class AuthModel {
  final bool isAuthenticated;
  final bool isLoading;
  final int? userId;
  final int? role;
  final PersonModel? person;
  final DoctorModel? doctor;
  final Patient? patientId;

  AuthModel({
    required this.isAuthenticated,
    required this.isLoading,
    this.userId,
    this.role,
    this.person,
    this.doctor,
    this.patientId,
  });

  AuthModel copyWith({
    bool? isAuthenticated,
    bool? isLoading,
    int? userId,
    int? role,
    PersonModel? person,
    DoctorModel? doctor,
    Patient? patientId,
  }) {
    return AuthModel(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      userId: userId ?? this.userId,
      role: role ?? this.role,
      person: person ?? this.person,
      doctor: doctor ?? this.doctor,
      patientId: patientId ?? this.patientId,
    );
  }

  @override
  String toString() {
    return 'AuthModel(isAuthenticated: $isAuthenticated, isLoading: $isLoading, userId: $userId, role: $role, person: $person, doctor: $doctor, patientId: $patientId)';
  }
}
