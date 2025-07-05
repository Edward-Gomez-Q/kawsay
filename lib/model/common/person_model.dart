class PersonModel {
  final int id;
  final String names;
  final String firstLastName;
  final String secondLastName;
  final String documentId;
  final String personalPhoneNumber;
  final String accessType;
  final String gender;
  final DateTime birthDate;
  final String country;
  final String city;
  final String neighborhood;
  final String address;

  PersonModel({
    required this.id,
    required this.names,
    required this.firstLastName,
    required this.secondLastName,
    required this.documentId,
    required this.personalPhoneNumber,
    required this.accessType,
    required this.gender,
    required this.birthDate,
    required this.country,
    required this.city,
    required this.neighborhood,
    required this.address,
  });
  // Método para convertir el modelo a un mapa (por ejemplo para SQLite o JSON)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'names': names,
      'first_last_name': firstLastName,
      'second_last_name': secondLastName,
      'document_id': documentId,
      'personal_phone_number': personalPhoneNumber,
      'access_type': accessType,
      'gender': gender,
      'birth_date': birthDate.toIso8601String(), // formato ISO 8601
      'country': country,
      'city': city,
      'neighborhood': neighborhood,
      'address': address,
    };
  }

  // Método para crear un modelo desde un mapa
  factory PersonModel.fromMap(Map<String, dynamic> map) {
    return PersonModel(
      id: map['id'],
      names: map['names'],
      firstLastName: map['first_last_name'],
      secondLastName: map['second_last_name'],
      documentId: map['document_id'],
      personalPhoneNumber: map['personal_phone_number'],
      accessType: map['access_type'],
      gender: map['gender'],
      birthDate: DateTime.parse(map['birth_date']),
      country: map['country'],
      city: map['city'],
      neighborhood: map['neighborhood'],
      address: map['address'],
    );
  }
}
