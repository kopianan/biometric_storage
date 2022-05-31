part of 'secure_apps_cubit.dart';

@immutable
abstract class SecureAppsState {}

class SecureAppsInitial extends SecureAppsState {}

class OnGettingSecretKey extends SecureAppsState {}

class OnSecretKeyRemoved extends SecureAppsState {}

class OnErrorSecretKey extends SecureAppsState {
  OnErrorSecretKey(this.errorMsg);
  final String errorMsg;
}

class OnSecretKeyReady extends SecureAppsState {}
