final class AuthenticatedUser {
  const AuthenticatedUser({
    required this.id,
    required this.fullName,
    required this.email,
  });

  final String id;
  final String fullName;
  final String email;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AuthenticatedUser &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            fullName == other.fullName &&
            email == other.email;
  }

  @override
  int get hashCode {
    return Object.hash(id, fullName, email);
  }
}
