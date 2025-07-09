class MedicalAllergy {
  final int? id;
  final int patientId;
  final String allergenFrom;
  final String allergen;
  final String? reaction;
  final String? severity;

  MedicalAllergy({
    this.id,
    required this.patientId,
    required this.allergenFrom,
    required this.allergen,
    this.reaction,
    this.severity,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'patient_id': patientId,
      'allergen_from': allergenFrom,
      'allergen': allergen,
      'reaction': reaction,
      'severity': severity,
    };
  }

  factory MedicalAllergy.fromMap(Map<String, dynamic> map) {
    return MedicalAllergy(
      id: map['id'],
      patientId: map['patient_id'],
      allergenFrom: map['allergen_from'],
      allergen: map['allergen'],
      reaction: map['reaction'],
      severity: map['severity'],
    );
  }
  @override
  String toString() {
    return 'MedicalAllergy{id: $id, patientId: $patientId, allergenFrom: $allergenFrom, allergen: $allergen, reaction: $reaction, severity: $severity}';
  }
}
