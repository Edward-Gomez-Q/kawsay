class Patient {
  final int id;
  final int personId;
  const Patient({required this.id, this.personId = 0});

  Map<String, dynamic> toMap() {
    return {'person_id': personId};
  }

  factory Patient.fromMap(Map<String, dynamic> map) {
    return Patient(
      id: map['id'] as int,
      personId: map['person_id'] as int? ?? 0,
    );
  }
  @override
  String toString() {
    return 'Patient(id: $id, personId: $personId)';
  }
}
