import 'package:biometric/core/error/failures.dart';
import 'package:biometric/features/biometric/domain/repositories/b_auth_repository.dart';
import 'package:biometric/features/global/util/biometric_helper.dart';
import 'package:dartz/dartz.dart';

class BAuthRepositoryImpl implements BAuthRepository {
  BiometricHelper _biometricHelper;
  BAuthRepositoryImpl(this._biometricHelper);
  @override
  Future<Either<Failure, bool>> authenticate() async {
    var _data = await _biometricHelper.authenticate();
    _data.fold(
      (l) => {},
      (r) => {},
    );
    return _data;
  }
}
