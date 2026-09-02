import 'package:injectable/injectable.dart';

import '../entities/location.dart';
import '../repositories/location_repository.dart';

@lazySingleton
final class GetCurrentLocationUseCase {
  const GetCurrentLocationUseCase(this._repository);

  final LocationRepository _repository;

  Future<Location> call() {
    return _repository.getCurrentLocation();
  }
}
