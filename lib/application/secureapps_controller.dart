import 'package:flutter/material.dart';
import 'package:secure_application/secure_application.dart';

class SecureappsController extends ChangeNotifier {
  SecureApplicationController? secureNotifier = SecureApplicationController(SecureApplicationState());

  void setupApplicationController(SecureApplicationController? controller) {
    secureNotifier = controller;
    notifyListeners();
  }

  SecureApplicationController? get getSecureNotifier => secureNotifier;
}
