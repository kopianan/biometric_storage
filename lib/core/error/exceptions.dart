//General Failures
import 'package:biometric/core/error/failures.dart';

class ServerFailure extends Failure {
  const ServerFailure(String str) : super(str);
}

class CacheFailure extends Failure {
  const CacheFailure(String str) : super(str);
}
