class AppointmentModel {
  final int id;
  final int sharingSessionId;
  final DateTime appointmentDate;
  final String appointmentStatus;
  final String consultationType;
  final int patientId;
  final int doctorId;

  AppointmentModel({
    required this.id,
    required this.sharingSessionId,
    required this.appointmentDate,
    required this.appointmentStatus,
    required this.consultationType,
    required this.patientId,
    required this.doctorId,
  });
  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['id'],
      sharingSessionId: json['sharing_session_id'],
      appointmentDate: DateTime.parse(json['appointment_date']),
      appointmentStatus: json['appointment_status'],
      consultationType: json['consultation_type'],
      patientId: json['patient_id'],
      doctorId: json['doctor_id'],
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
    };
  }
}
