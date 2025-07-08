class Vaccination {
  final int? id;
  final int patientId;
  final String vaccine;
  final String dose;
  final DateTime dateVaccine;
  final String institution;

  Vaccination({
    this.id,
    required this.patientId,
    required this.vaccine,
    required this.dose,
    required this.dateVaccine,
    required this.institution,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'patient_id': patientId,
      'vaccine': vaccine,
      'dose': dose,
      'date_vaccine': dateVaccine.toIso8601String(),
      'institution': institution,
    };
  }

  factory Vaccination.fromMap(Map<String, dynamic> map) {
    return Vaccination(
      id: map['id'],
      patientId: map['patient_id'],
      vaccine: map['vaccine'],
      dose: map['dose'],
      dateVaccine: DateTime.parse(map['date_vaccine']),
      institution: map['institution'],
    );
  }
}
