class MedicalConsultationWithPatientModel {
  final int id;
  final int appointmentId;
  final String chiefComplaint;
  final String physicalExamination;
  final String vitalSigns;
  final String diagnosis;
  final String treatmentPlan;
  final String observations;
  final String followUpInstructions;
  final bool nextAppointmentRecommended;
  final DateTime followUpDate;
  final String patientNames;
  final String patientFirstLastName;
  final String patientSecondLastName;
  final DateTime appointmentDate;

  MedicalConsultationWithPatientModel({
    required this.id,
    required this.appointmentId,
    required this.chiefComplaint,
    required this.physicalExamination,
    required this.vitalSigns,
    required this.diagnosis,
    required this.treatmentPlan,
    required this.observations,
    required this.followUpInstructions,
    required this.nextAppointmentRecommended,
    required this.followUpDate,
    required this.patientNames,
    required this.patientFirstLastName,
    required this.patientSecondLastName,
    required this.appointmentDate,
  });
  String get fullPatientName =>
      '$patientNames $patientFirstLastName $patientSecondLastName';
}
