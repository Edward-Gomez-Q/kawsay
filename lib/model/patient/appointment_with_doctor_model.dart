class AppointmentWithDoctorModel {
  final int id;
  final int sharingSessionId;
  final DateTime appointmentDate;
  final String appointmentStatus;
  final String consultationType;
  final int patientId;
  final int doctorId;
  final String doctorNames;
  final String doctorFirstLastName;
  final String doctorSecondLastName;
  final String doctorSpecialization;
  final String doctorMedicalCollege;
  final int doctorYearsExperience;
  final String shareCode;

  AppointmentWithDoctorModel({
    required this.id,
    required this.sharingSessionId,
    required this.appointmentDate,
    required this.appointmentStatus,
    required this.consultationType,
    required this.patientId,
    required this.doctorId,
    required this.doctorNames,
    required this.doctorFirstLastName,
    required this.doctorSecondLastName,
    required this.doctorSpecialization,
    required this.doctorMedicalCollege,
    required this.doctorYearsExperience,
    required this.shareCode,
  });

  factory AppointmentWithDoctorModel.fromJson(Map<String, dynamic> json) {
    return AppointmentWithDoctorModel(
      id: json['id'],
      sharingSessionId: json['sharing_session_id'],
      appointmentDate: DateTime.parse(json['appointment_date']),
      appointmentStatus: json['appointment_status'],
      consultationType: json['consultation_type'],
      patientId: json['patient_id'],
      doctorId: json['doctor_id'],
      doctorNames: json['doctor']['person']['names'],
      doctorFirstLastName: json['doctor']['person']['first_last_name'],
      doctorSecondLastName: json['doctor']['person']['second_last_name'],
      doctorSpecialization: json['doctor']['specialization'],
      doctorMedicalCollege: json['doctor']['medical_college'],
      doctorYearsExperience: json['doctor']['years_experience'],
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
      'doctor_names': doctorNames,
      'doctor_first_last_name': doctorFirstLastName,
      'doctor_second_last_name': doctorSecondLastName,
      'doctor_specialization': doctorSpecialization,
      'doctor_medical_college': doctorMedicalCollege,
      'doctor_years_experience': doctorYearsExperience,
      'share_code': shareCode,
    };
  }
}
