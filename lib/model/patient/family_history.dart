class FamilyHistory {
  final int? id;
  final int patientId;
  final String relationship;
  final String condition;
  final int ageOfOnset;

  FamilyHistory({
    this.id,
    required this.patientId,
    required this.relationship,
    required this.condition,
    required this.ageOfOnset,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'patient_id': patientId,
      'relationship': relationship,
      'condition': condition,
      'age_of_onset': ageOfOnset,
    };
  }

  factory FamilyHistory.fromMap(Map<String, dynamic> map) {
    return FamilyHistory(
      id: map['id'],
      patientId: map['patient_id'],
      relationship: map['relationship'],
      condition: map['condition'],
      ageOfOnset: map['age_of_onset'],
    );
  }
}
