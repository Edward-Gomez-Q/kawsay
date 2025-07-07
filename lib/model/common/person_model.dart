class PersonModel {
  final int id;
  final String names;
  final String firstLastName;
  final String secondLastName;
  final String documentId;
  final String personalPhoneNumber;
  final int accessTypeId;
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
    required this.accessTypeId,
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
      'access_type_id': accessTypeId,
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
      accessTypeId: map['access_type_id'],
      gender: map['gender'],
      birthDate: DateTime.parse(map['birth_date']),
      country: map['country'],
      city: map['city'],
      neighborhood: map['neighborhood'],
      address: map['address'],
    );
  }

  PersonModel copyWith({
    int? id,
    String? names,
    String? firstLastName,
    String? secondLastName,
    String? documentId,
    String? personalPhoneNumber,
    int? accessTypeId,
    String? gender,
    DateTime? birthDate,
    String? country,
    String? city,
    String? neighborhood,
    String? address,
  }) {
    return PersonModel(
      id: id ?? this.id,
      names: names ?? this.names,
      firstLastName: firstLastName ?? this.firstLastName,
      secondLastName: secondLastName ?? this.secondLastName,
      documentId: documentId ?? this.documentId,
      personalPhoneNumber: personalPhoneNumber ?? this.personalPhoneNumber,
      accessTypeId: accessTypeId ?? this.accessTypeId,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      country: country ?? this.country,
      city: city ?? this.city,
      neighborhood: neighborhood ?? this.neighborhood,
      address: address ?? this.address,
    );
  }

  //toString method for debugging
  @override
  String toString() {
    return 'PersonModel(id: $id, names: $names, firstLastName: $firstLastName, secondLastName: $secondLastName, documentId: $documentId, personalPhoneNumber: $personalPhoneNumber, accessTypeId: $accessTypeId, gender: $gender, birthDate: $birthDate, country: $country, city: $city, neighborhood: $neighborhood, address: $address)';
  }
}
