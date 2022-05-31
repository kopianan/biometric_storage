import 'package:biometric/application/secure_apps_cubit.dart';
import 'package:biometric/application/secureapps_controller.dart';
import 'package:biometric/feature/local_secure_storage_helper.dart';
import 'package:get_it/get_it.dart';

import '../services/life_cycle_service.dart';

final getIt = GetIt.instance;

void setup() {
  getIt.registerFactory<LocationService>(() => LocationService());

  getIt.registerFactory<LocalSecureStorageHelper>(
      () => LocalSecureStorageHelper());
  getIt.registerFactory<SecureAppsCubit>(
      () => SecureAppsCubit(getIt<LocalSecureStorageHelper>()));
}
