import 'package:project_3_kawsay/model/common/person_model.dart';
import 'package:project_3_kawsay/model/common/user_model.dart';
import 'package:project_3_kawsay/model/doctor/doctor_model.dart';

enum UserType { patient, doctor }

class UserSignUpData {
  final UserType userType;
  final PersonModel personalData;
  final DoctorModel? medicalData;
  final UserModel userCredentials;

  UserSignUpData({
    required this.userType,
    required this.personalData,
    this.medicalData,
    required this.userCredentials,
  });

  //CopyWith
  UserSignUpData copyWith({
    UserType? userType,
    PersonModel? personalData,
    DoctorModel? medicalData,
    UserModel? userCredentials,
  }) {
    return UserSignUpData(
      userType: userType ?? this.userType,
      personalData: personalData ?? this.personalData,
      medicalData: medicalData ?? this.medicalData,
      userCredentials: userCredentials ?? this.userCredentials,
    );
  }
}
