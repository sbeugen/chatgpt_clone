import 'package:chatgpt_clone/services/storage/key_value_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesKeyValueStorageService extends KeyValueStorageService {
  @override
  Future<String?> read(String key) async {
    return (await _getSharedPreferencesInstance()).getString(key);
  }

  @override
  Future<void> write(String key, String value) async {
    (await _getSharedPreferencesInstance()).setString(key, value);
  }

  @override
  Future<void> delete(String key) async {
    (await _getSharedPreferencesInstance()).remove(key);
  }

  Future<SharedPreferences> _getSharedPreferencesInstance() async =>
      await SharedPreferences.getInstance();
}
