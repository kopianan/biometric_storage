import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/auth_strings.dart';
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
  Future<bool> hasBiometrics() async {
    try {
      var _result = await _auth.isDeviceSupported();
      return _result;
    } on PlatformException catch (e) {
      if (e.code == auth_error.notAvailable) {
        throw Exception('Device does not support Fingerprint/FaceID');
      }
      throw Exception('Something wrong on biometrics');
    }
  }

  Future<bool> canUseBiometrics() async {
    try {
      var _result = await _auth.canCheckBiometrics;

      return _result;
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }

  ///Call biometric prompt
  Future<bool> authenticate() async {
    //Check if device support for biometrics or not
    final _isAvailable = await hasBiometrics();
    if (!_isAvailable) return false;

    //Check what kind of biometrics on phone
    try {
      var _result = await _auth.authenticate(

        localizedReason: await _localizedReason(),
        biometricOnly: true,
        androidAuthStrings: AndroidAuthMessages(
          cancelButton: "Cancel",
          biometricHint: "Biometric Hint",
          biometricSuccess: "Biometri Success",
          signInTitle: "SIgnin"
        ),

        useErrorDialogs: true,
        stickyAuth: false,
        sensitiveTransaction: false,
      );

      return _result;
    } on PlatformException catch (e) {
      if (e.code == auth_error.notEnrolled) {
        throw Exception(e.message);
      }else if (e.code == auth_error.lockedOut){
        throw Exception("locked"); 
      }
      throw Exception(e.message);
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
