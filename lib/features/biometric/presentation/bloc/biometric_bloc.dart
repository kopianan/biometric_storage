import 'dart:async';

import 'package:biometric/features/biometric/domain/usecases/authenticate_with_biometric.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'biometric_event.dart';
part 'biometric_state.dart';

class BiometricBloc extends Bloc<BiometricEvent, BiometricState> {
  AuthenticateWithBiometric _authenticateWithBiometric;

  BiometricBloc(this._authenticateWithBiometric) : super(BiometricInitial()) {
    on<Authenticate>(_onAuthenticate);
  }

  FutureOr<void> _onAuthenticate(
      Authenticate event, Emitter<BiometricState> emit) async {
    _authenticateWithBiometric.call(NoParams());
  }
}
