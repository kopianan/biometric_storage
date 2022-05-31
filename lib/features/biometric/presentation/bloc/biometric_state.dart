part of 'biometric_bloc.dart';

abstract class BiometricState extends Equatable {
  const BiometricState();

  @override
  List<Object> get props => [];
}

class BiometricInitial extends BiometricState {}

class AuthenticateSuccess extends BiometricState {}

class AuthenticateError extends BiometricState {}
