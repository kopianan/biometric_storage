import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalSecureStorageHelper {
  static final LocalSecureStorageHelper _instance =
      LocalSecureStorageHelper._internal();
  LocalSecureStorageHelper._internal();

  factory LocalSecureStorageHelper() {
    return _instance;
  }

  final _storage = const FlutterSecureStorage(
      iOptions: IOSOptions(),
      aOptions: AndroidOptions(encryptedSharedPreferences: false));

  void writeData({required String key, required String value}) async {
    try {
      await _storage.write(
        key: key,
        value: value,
      );
    } catch (e) {
      throw Exception(e);
    }
  }

  void removeData({required String key}) async {
    try {
      await _storage.delete(key: key);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<String?> readData({required String key}) async {
    try {
      var _result = await _storage.read(key: key);
      return _result;
    } catch (e) {
      throw Exception(e);
    }
  }
}
