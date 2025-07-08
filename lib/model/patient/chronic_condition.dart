class ChronicCondition {
  final int? id;
  final int patientId;
  final String condition;
  final DateTime? diagnosisDate;
  final bool controlled;

  ChronicCondition({
    this.id,
    required this.patientId,
    required this.condition,
    this.diagnosisDate,
    required this.controlled,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'patient_id': patientId,
      'condition': condition,
      'diagnosis_date': diagnosisDate?.toIso8601String(),
      'controlled': controlled ? 1 : 0,
    };
  }

  factory ChronicCondition.fromMap(Map<String, dynamic> map) {
    return ChronicCondition(
      id: map['id'],
      patientId: map['patient_id'],
      condition: map['condition'],
      diagnosisDate: map['diagnosis_date'] != null
          ? DateTime.parse(map['diagnosis_date'])
          : null,
      controlled: map['controlled'] == 1,
    );
  }
  @override
  String toString() {
    return 'ChronicCondition{id: $id, patientId: $patientId, condition: $condition, diagnosisDate: $diagnosisDate, controlled: $controlled}';
  }
}
