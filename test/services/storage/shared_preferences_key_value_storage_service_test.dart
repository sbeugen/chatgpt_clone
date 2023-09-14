import 'package:chatgpt_clone/services/storage/shared_preferences_key_value_storage_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  final initialValue = <String, String>{
    'key1': 'value1',
    'key2': 'value2',
  };

  setUp(() {
    SharedPreferences.setMockInitialValues(initialValue);
  });

  group('read', () {
    test('returns value if key exists', () async {
      final testee = SharedPreferencesKeyValueStorageRepository();
      final result = await testee.read('key1');

      expect(result, 'value1');
    });

    test('returns nulll if key does not exist', () async {
      final testee = SharedPreferencesKeyValueStorageRepository();
      final result = await testee.read('keyNotExisting');

      expect(result, null);
    });
  });

  group('write', () {
    test('should store given value with given key', () async {
      final testee = SharedPreferencesKeyValueStorageRepository();
      await testee.write('someKey', 'someValue');

      final result = await testee.read('someKey');
      expect(result, 'someValue');
    });
  });

  group('delete', () {
    test('should delete given given key', () async {
      final testee = SharedPreferencesKeyValueStorageRepository();
      final existingValue = await testee.read('key1');
      expect(existingValue, 'value1');

      await testee.delete('key1');
      final deletedValue = await testee.read('key1');
      expect(deletedValue, null);
    });
  });
}
