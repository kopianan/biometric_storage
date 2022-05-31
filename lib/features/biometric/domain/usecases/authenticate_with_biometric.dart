import 'package:biometric/core/error/failures.dart';
import 'package:biometric/core/usecase/usecase.dart';
import 'package:biometric/features/biometric/domain/repositories/b_auth_repository.dart';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class AuthenticateWithBiometric implements UseCase<void, NoParams> {
  final BAuthRepository _bAuthRepository;
  AuthenticateWithBiometric(this._bAuthRepository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await _bAuthRepository.authenticate();
  }
}

class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}

class Params extends Equatable {
  final int number;
  const Params({required this.number});

  @override
  List<Object> get props => [number];
}
