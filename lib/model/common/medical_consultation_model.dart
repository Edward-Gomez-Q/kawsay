class MedicalConsultationModel {
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

  MedicalConsultationModel({
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
  });

  factory MedicalConsultationModel.fromJson(Map<String, dynamic> json) {
    return MedicalConsultationModel(
      id: json['id'],
      appointmentId: json['appointment_id'],
      chiefComplaint: json['chief_complaint'],
      physicalExamination: json['physical_examination'],
      vitalSigns: json['vital_signs'],
      diagnosis: json['diagnosis'],
      treatmentPlan: json['treatment_plan'],
      observations: json['observations'],
      followUpInstructions: json['follow_up_instructions'],
      nextAppointmentRecommended: json['next_appointment_recommended'],
      followUpDate: DateTime.parse(json['follow_up_date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'appointment_id': appointmentId,
      'chief_complaint': chiefComplaint,
      'physical_examination': physicalExamination,
      'vital_signs': vitalSigns,
      'diagnosis': diagnosis,
      'treatment_plan': treatmentPlan,
      'observations': observations,
      'follow_up_instructions': followUpInstructions,
      'next_appointment_recommended': nextAppointmentRecommended,
      'follow_up_date': followUpDate.toIso8601String(),
    };
  }
}
