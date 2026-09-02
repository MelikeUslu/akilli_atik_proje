import '../../domain/entities/authenticated_user.dart';

final class LoginResponseModel {
  const LoginResponseModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.accessToken,
    required this.refreshToken,
  });

  final String id;
  final String fullName;
  final String email;
  final String accessToken;
  final String refreshToken;

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
  }

  AuthenticatedUser toEntity() {
    return AuthenticatedUser(id: id, fullName: fullName, email: email);
  }
}
