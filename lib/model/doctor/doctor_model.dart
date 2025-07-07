class DoctorModel {
  final int id;
  final int personId;
  final String specialization;
  final String medicalCollege;
  final int yearsExperience;

  DoctorModel({
    required this.id,
    required this.personId,
    required this.specialization,
    required this.medicalCollege,
    required this.yearsExperience,
  });

  // Método para convertir el modelo a un mapa (por ejemplo para SQLite o JSON)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'person_id': personId,
      'specialization': specialization,
      'medical_college': medicalCollege,
      'years_experience': yearsExperience,
    };
  }

  // Método para crear un modelo desde un mapa
  factory DoctorModel.fromMap(Map<String, dynamic> map) {
    return DoctorModel(
      id: map['id'],
      personId: map['person_id'],
      specialization: map['specialization'],
      medicalCollege: map['medical_college'],
      yearsExperience: map['years_experience'],
    );
  }

  // CopyWith method
  DoctorModel copyWith({
    int? id,
    int? personId,
    String? specialization,
    String? medicalCollege,
    int? yearsExperience,
  }) {
    return DoctorModel(
      id: id ?? this.id,
      personId: personId ?? this.personId,
      specialization: specialization ?? this.specialization,
      medicalCollege: medicalCollege ?? this.medicalCollege,
      yearsExperience: yearsExperience ?? this.yearsExperience,
    );
  }

  // toString method for debugging
  @override
  String toString() {
    return 'DoctorModel(id: $id, personId: $personId, specialization: $specialization, medicalCollege: $medicalCollege, yearsExperience: $yearsExperience)';
  }
}
