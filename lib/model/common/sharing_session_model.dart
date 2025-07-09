class SharingSessionModel {
  final int id;
  final int patientId;
  final String shareCode;
  final String sharedData;
  final DateTime expiresAt;
  final DateTime createdAt;
  final bool isActive;

  SharingSessionModel({
    required this.id,
    required this.patientId,
    required this.shareCode,
    required this.sharedData,
    required this.expiresAt,
    required this.createdAt,
    required this.isActive,
  });
  // Método para convertir el modelo a un mapa
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'patient_id': patientId,
      'share_code': shareCode,
      'shared_data': sharedData,
      'expires_at': expiresAt.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'is_active': isActive ? 1 : 0,
    };
  }

  // Método para crear un modelo desde un mapa
  factory SharingSessionModel.fromMap(Map<String, dynamic> map) {
    return SharingSessionModel(
      id: map['id'],
      patientId: map['patient_id'],
      shareCode: map['share_code'],
      sharedData: map['shared_data'],
      expiresAt: DateTime.parse(map['expires_at']),
      createdAt: DateTime.parse(map['created_at']),
      isActive: map['is_active'] == 1,
    );
  }

  @override
  String toString() {
    return 'SharingSessionModel(id: $id, patientId: $patientId, shareCode: $shareCode, sharedData: $sharedData, expiresAt: $expiresAt, createdAt: $createdAt, isActive: $isActive)';
  }
}
