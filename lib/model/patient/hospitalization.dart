class Hospitalization {
  final int? id;
  final int patientId;
  final String reason;
  final DateTime admissionDate;
  final DateTime dischargeDate;

  Hospitalization({
    this.id,
    required this.patientId,
    required this.reason,
    required this.admissionDate,
    required this.dischargeDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'patient_id': patientId,
      'reason': reason,
      'admission_date': admissionDate.toIso8601String(),
      'discharge_date': dischargeDate.toIso8601String(),
    };
  }

  factory Hospitalization.fromMap(Map<String, dynamic> map) {
    return Hospitalization(
      id: map['id'],
      patientId: map['patient_id'],
      reason: map['reason'],
      admissionDate: DateTime.parse(map['admission_date']),
      dischargeDate: DateTime.parse(map['discharge_date']),
    );
  }
  @override
  String toString() {
    return 'Hospitalization{id: $id, patientId: $patientId, reason: $reason, admissionDate: $admissionDate, dischargeDate: $dischargeDate}';
  }
}
