class Insurance {
  final int? id;
  final int patientId;
  final String provider;
  final String policyNumber;
  final DateTime startDate;
  final DateTime endDate;

  Insurance({
    this.id,
    required this.patientId,
    required this.provider,
    required this.policyNumber,
    required this.startDate,
    required this.endDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'patient_id': patientId,
      'provider': provider,
      'policy_number': policyNumber,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
    };
  }

  factory Insurance.fromMap(Map<String, dynamic> map) {
    return Insurance(
      id: map['id'],
      patientId: map['patient_id'],
      provider: map['provider'],
      policyNumber: map['policy_number'],
      startDate: DateTime.parse(map['start_date']),
      endDate: DateTime.parse(map['end_date']),
    );
  }
}
