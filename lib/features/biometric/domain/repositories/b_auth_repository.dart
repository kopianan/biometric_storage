import 'package:biometric/core/error/failures.dart';
import 'package:dartz/dartz.dart';

abstract class BAuthRepository {
  Future<Either<Failure, bool>> authenticate();
}
