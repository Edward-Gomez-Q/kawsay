class AppRoutes {
  //Comunes
  static const String welcome = '/';
  static const String splash = '/splash';
  static const String login = '/login';
  static const String signUp = '/sign-up';

  //Paciente
  static const String patient = '/patient';
  static const String homePatient = '$patient/home';
  //Doctor
  static const String doctor = '/doctor';
  static const String homeDoctor = '$doctor/home';
  static const String patientList = '$doctor/patient-list';
  static const String patientDiagnostics = '$doctor/diagnostics';
  static const String receiveCode = '$doctor/receive-code';
  static const String profileDoctor = '$doctor/profile';
}
