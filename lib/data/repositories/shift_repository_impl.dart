import 'package:injectable/injectable.dart';

import '../../domain/entities/shift.dart';
import '../../domain/repositories/shift_repository.dart';
import '../datasources/shift_remote_data_source.dart';

@LazySingleton(as: ShiftRepository)
final class ShiftRepositoryImpl implements ShiftRepository {
  const ShiftRepositoryImpl({required this.remoteDataSource});

  final ShiftRemoteDataSource remoteDataSource;

  @override
  Future<Shift> startShift({required String driverId}) async {
    final shiftModel = await remoteDataSource.startShift(driverId: driverId);

    return shiftModel.toEntity();
  }

  @override
  Future<Shift> endShift({required String driverId}) async {
    final shiftModel = await remoteDataSource.endShift(driverId: driverId);

    return shiftModel.toEntity();
  }
}
