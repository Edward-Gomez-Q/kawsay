class AuthModel {
  final bool isAuthenticated;
  final bool isLoading;
  final int? userId;
  final int? role;

  AuthModel({
    required this.isAuthenticated,
    required this.isLoading,
    this.userId,
    this.role,
  });

  AuthModel copyWith({
    bool? isAuthenticated,
    bool? isLoading,
    int? userId,
    int? role,
  }) {
    return AuthModel(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      userId: userId ?? this.userId,
      role: role ?? this.role,
    );
  }
}
