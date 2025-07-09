class AppointmentWithPatientModel {
  final int id;
  final int sharingSessionId;
  final DateTime appointmentDate;
  final String appointmentStatus;
  final String consultationType;
  final int patientId;
  final int doctorId;
  final String patientNames;
  final String patientFirstLastName;
  final String patientSecondLastName;
  final String shareCode;

  AppointmentWithPatientModel({
    required this.id,
    required this.sharingSessionId,
    required this.appointmentDate,
    required this.appointmentStatus,
    required this.consultationType,
    required this.patientId,
    required this.doctorId,
    required this.patientNames,
    required this.patientFirstLastName,
    required this.patientSecondLastName,
    required this.shareCode,
  });

  factory AppointmentWithPatientModel.fromJson(Map<String, dynamic> json) {
    return AppointmentWithPatientModel(
      id: json['id'],
      sharingSessionId: json['sharing_session_id'],
      appointmentDate: DateTime.parse(json['appointment_date']),
      appointmentStatus: json['appointment_status'],
      consultationType: json['consultation_type'],
      patientId: json['patient_id'],
      doctorId: json['doctor_id'],
      patientNames: json['patient']['person']['names'],
      patientFirstLastName: json['patient']['person']['first_last_name'],
      patientSecondLastName: json['patient']['person']['second_last_name'],
      shareCode: json['sharing_session']['share_code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sharing_session_id': sharingSessionId,
      'appointment_date': appointmentDate.toIso8601String(),
      'appointment_status': appointmentStatus,
      'consultation_type': consultationType,
      'patient_id': patientId,
      'doctor_id': doctorId,
      'patient_names': patientNames,
      'patient_first_last_name': patientFirstLastName,
      'patient_second_last_name': patientSecondLastName,
      'share_code': shareCode,
    };
  }

  // Getter para obtener el nombre completo del paciente
  String get fullPatientName =>
      '$patientNames $patientFirstLastName $patientSecondLastName';
}
