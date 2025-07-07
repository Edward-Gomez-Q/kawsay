class RoleUserModel {
  final int id;
  final int authRoleId;
  final int authUserId;

  RoleUserModel({
    required this.id,
    required this.authRoleId,
    required this.authUserId,
  });
  // Método para convertir el modelo a un mapa (por ejemplo para SQLite o JSON)
  Map<String, dynamic> toMap() {
    return {'id': id, 'auth_role_id': authRoleId, 'auth_user_id': authUserId};
  }

  // Método para crear un modelo desde un mapa
  factory RoleUserModel.fromMap(Map<String, dynamic> map) {
    return RoleUserModel(
      id: map['id'],
      authRoleId: map['auth_role_id'],
      authUserId: map['auth_user_id'],
    );
  }
}
