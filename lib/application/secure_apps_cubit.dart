import 'package:biometric/feature/local_secure_storage_helper.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'secure_apps_state.dart';

class SecureAppsCubit extends Cubit<SecureAppsState> {
  SecureAppsCubit(this.localSecureStorageHelper) : super(SecureAppsInitial());
  final LocalSecureStorageHelper localSecureStorageHelper;
  
  String? keyData;

  void removeKey() {
    print("Key removed");
    keyData = null;
    print(keyData);
  }

  void readSecretKey() async {
    emit(OnGettingSecretKey());
    var _result = await localSecureStorageHelper.readData(key: "key");
    if (_result == null) {
      emit(OnErrorSecretKey("Key not found"));
    } else {
      keyData = _result;
      emit(OnSecretKeyReady());
    }
  }
}
