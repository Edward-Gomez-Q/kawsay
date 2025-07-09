class EmergencyContact {
  final int? id;
  final int patientId;
  final String fullName;
  final String relationship;
  final String phone;
  final bool isFamilyDoctor;

  EmergencyContact({
    this.id,
    required this.patientId,
    required this.fullName,
    required this.relationship,
    required this.phone,
    required this.isFamilyDoctor,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'patient_id': patientId,
      'full_name': fullName,
      'relationship': relationship,
      'phone': phone,
      'is_family_doctor': isFamilyDoctor ? 1 : 0,
    };
  }

  factory EmergencyContact.fromMap(Map<String, dynamic> map) {
    return EmergencyContact(
      id: map['id'],
      patientId: map['patient_id'],
      fullName: map['full_name'],
      relationship: map['relationship'],
      phone: map['phone'],
      isFamilyDoctor: map['is_family_doctor'] == 1,
    );
  }

  @override
  String toString() {
    return 'EmergencyContact{id: $id, patientId: $patientId, fullName: $fullName, relationship: $relationship, phone: $phone, isFamilyDoctor: $isFamilyDoctor}';
  }
}
