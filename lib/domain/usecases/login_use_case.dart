import 'package:injectable/injectable.dart';

import '../entities/authenticated_user.dart';
import '../repositories/auth_repository.dart';

@lazySingleton
final class LoginUseCase {
  const LoginUseCase(this._repository);

  final AuthRepository _repository;

  Future<AuthenticatedUser> call({
    required String email,
    required String password,
  }) {
    return _repository.login(email: email, password: password);
  }
}
