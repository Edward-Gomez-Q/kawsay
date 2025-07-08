class Patient {
  final int id;

  Patient({required this.id});

  Map<String, dynamic> toMap() {
    return {'id': id};
  }

  factory Patient.fromMap(Map<String, dynamic> map) {
    return Patient(id: map['id']);
  }
}
