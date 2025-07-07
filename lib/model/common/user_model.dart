class UserModel {
  final int id;
  final String email;
  final String password;
  final int personId;

  UserModel({
    required this.id,
    required this.email,
    required this.password,
    required this.personId,
  });

  // Método para convertir el modelo a un mapa
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'person_id': personId,
    };
  }

  // Método para crear un modelo desde un mapa
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      email: map['email'],
      password: map['password'],
      personId: map['person_id'],
    );
  }
  // CopyWith method
  UserModel copyWith({
    int? id,
    String? email,
    String? password,
    int? personId,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      password: password ?? this.password,
      personId: personId ?? this.personId,
    );
  }

  // toString method for debugging
  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, password: $password, person_id: $personId)';
  }
}
