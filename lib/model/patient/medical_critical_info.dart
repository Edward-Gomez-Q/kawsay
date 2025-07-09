class MedicalCriticalInfo {
  final int? id;
  final int patientId;
  final String bloodType;
  final bool pregnant;
  final bool hasImplants;
  final String? notes;

  MedicalCriticalInfo({
    this.id,
    required this.patientId,
    required this.bloodType,
    required this.pregnant,
    required this.hasImplants,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'patient_id': patientId,
      'blood_type': bloodType,
      'pregnant': pregnant ? 1 : 0,
      'has_implants': hasImplants ? 1 : 0,
      'notes': notes,
    };
  }

  factory MedicalCriticalInfo.fromMap(Map<String, dynamic> map) {
    return MedicalCriticalInfo(
      id: map['id'],
      patientId: map['patient_id'],
      bloodType: map['blood_type'],
      pregnant: map['pregnant'] == 1,
      hasImplants: map['has_implants'] == 1,
      notes: map['notes'],
    );
  }
  @override
  String toString() {
    return 'MedicalCriticalInfo{id: $id, patientId: $patientId, bloodType: $bloodType, pregnant: $pregnant, hasImplants: $hasImplants, notes: $notes}';
  }
}
