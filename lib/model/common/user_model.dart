class UserModel {
  final int id;
  final String email;
  final String password;

  UserModel({required this.id, required this.email, required this.password});

  // Método para convertir el modelo a un mapa
  Map<String, dynamic> toMap() {
    return {'id': id, 'email': email, 'password': password};
  }

  // Método para crear un modelo desde un mapa
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      email: map['email'],
      password: map['password'],
    );
  }
}
