import 'dart:io';
import 'package:biometric/core/error/exceptions.dart';
import 'package:biometric/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;

class BiometricHelper {
  static final BiometricHelper _instance = BiometricHelper._internal();
  BiometricHelper._internal();
  final _auth = LocalAuthentication();

  factory BiometricHelper() {
    return _instance;
  }

  ///Check if the device has a biometric system.
  ///Return true if biometric is available.
  Future<Either<Failure, bool>> hasBiometrics() async {
    try {
      var _result = await _auth.isDeviceSupported();
      if (!_result) {
        return const Left(NotSupportFailure("Device is not supported"));
      }
      return const Right(true);
    } on PlatformException catch (e) {
      return Left(_biometricErrroCheck(e));
    }
  }

  //This function will always return true if the device has enrolled the PIN/Pattern/Password/Biometric
  //Even if the fingerprint (on Android) was not enrolled, this function will reutrn [true]
  Future<Either<Failure, bool>> canUseBiometrics() async {
    try {
      var _result = await _auth.canCheckBiometrics;
      if (!_result) {
        return const Left(NotEnrolledFailure("Device is not supported"));
      }
      return const Right(true);
    } on PlatformException catch (e) {
      return Left(_biometricErrroCheck(e));
    }
  }

  Future<Either<Failure, bool>> _authenticateToBiometric() async {
    try {
      await hasBiometrics();
      await canUseBiometrics();
      var _result = await _auth.authenticate(
          localizedReason: await _localizedReason(),
          biometricOnly: true,
          useErrorDialogs: true,
          stickyAuth: false,
          sensitiveTransaction: false);
      return Right(_result);
    } on PlatformException catch (e) {
      return Left(_biometricErrroCheck(e));
    }
  }

  ///Call biometric prompt
  Future<Either<Failure, bool>> authenticate() async {
    //Check if device support for biometrics or not

    try {
      final _result = await _authenticateToBiometric();
      return _result.fold(
        (l) => Left(ServerFailure("False")),
        (r) => Right(r),
      );
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure("error"));
    }
  }

  Future<bool> cancelBiometrics() async {
    try {
      var _result = await _auth.stopAuthentication();
      return _result;
    } on PlatformException catch (e) {
      return true;
    }
  }

  Future<String> _localizedReason() async {
    List<BiometricType> _availableBiometrics;

    _availableBiometrics = await _auth.getAvailableBiometrics();
    String reason;
    if (Platform.isIOS) {
      if (_availableBiometrics.contains(BiometricType.face)) {
        reason = "Scan your Face on the device scanner to confirm";
      } else if (_availableBiometrics.contains(BiometricType.fingerprint)) {
        reason = "Use your TouchID Scanner on the device scanner to confirm.";
      } else {
        reason = "Use your Iris to confirm";
      }
    } else {
      reason = "Use your fingerprint on the device to confirm";
    }

    return reason;
  }
}

Failure _biometricErrroCheck(PlatformException e) {
  switch (e.code) {
    case auth_error.lockedOut:
      return LockedOutFailure("");

    case auth_error.notAvailable:
      return NotAvailableFailure("");

    case auth_error.notEnrolled:
      return NotEnrolledFailure("");

    case auth_error.otherOperatingSystem:
      return OtherOperatingSystemFailure("");

    case auth_error.passcodeNotSet:
      return PasscodeNotSetFailure("");

    case auth_error.permanentlyLockedOut:
      return PermanentlyLockedOutFailure("");

    default:
      return ServerFailure("Something wrong");
  }
}

class PasscodeNotSetFailure extends Failure {
  const PasscodeNotSetFailure(String str) : super(str);
}

class NotEnrolledFailure extends Failure {
  const NotEnrolledFailure(String str) : super(str);
}

class NotAvailableFailure extends Failure {
  const NotAvailableFailure(String str) : super(str);
}

class NotSupportFailure extends Failure {
  const NotSupportFailure(String str) : super(str);
}

class OtherOperatingSystemFailure extends Failure {
  const OtherOperatingSystemFailure(String str) : super(str);
}

class LockedOutFailure extends Failure {
  const LockedOutFailure(String str) : super(str);
}

/// Indicates the API being disabled due to too many lock outs.
/// Strong authentication like PIN/Pattern/Password is required to unlock.
class PermanentlyLockedOutFailure extends Failure {
  const PermanentlyLockedOutFailure(String str) : super(str);
}
