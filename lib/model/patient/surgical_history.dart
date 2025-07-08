class SurgicalHistory {
  final int? id;
  final int patientId;
  final String surgery;
  final DateTime surgeryDate;
  final bool complications;
  final String? noteComplications;

  SurgicalHistory({
    this.id,
    required this.patientId,
    required this.surgery,
    required this.surgeryDate,
    required this.complications,
    this.noteComplications,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'patient_id': patientId,
      'surgery': surgery,
      'surgery_date': surgeryDate.toIso8601String(),
      'complications': complications ? 1 : 0,
      'note_complications': noteComplications,
    };
  }

  factory SurgicalHistory.fromMap(Map<String, dynamic> map) {
    return SurgicalHistory(
      id: map['id'],
      patientId: map['patient_id'],
      surgery: map['surgery'],
      surgeryDate: DateTime.parse(map['surgery_date']),
      complications: map['complications'] == 1,
      noteComplications: map['note_complications'],
    );
  }
}
