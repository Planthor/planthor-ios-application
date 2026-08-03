import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:planthor_ios_application/core/storage/local_store.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SharedPreferencesLocalStore.get<T>', () {
    late SharedPreferencesLocalStore store;

    setUp(() async {
      SharedPreferences.setMockInitialValues({
        'str_key': 'hello',
        'int_key': 42,
        'bool_key': true,
        'double_key': 3.14,
      });
      final prefs = await SharedPreferences.getInstance();
      store = SharedPreferencesLocalStore(prefs);
    });

    test('returns String for matching key', () {
      expect(store.get<String>('str_key'), 'hello');
    });

    test('returns int for matching key', () {
      expect(store.get<int>('int_key'), 42);
    });

    test('returns bool for matching key', () {
      expect(store.get<bool>('bool_key'), isTrue);
    });

    test('returns double for matching key', () {
      expect(store.get<double>('double_key'), 3.14);
    });

    test('returns null (no throw) when type mismatches stored value', () {
      // key holds String — caller asks for int
      expect(() => store.get<int>('str_key'), returnsNormally);
      expect(store.get<int>('str_key'), isNull);
    });

    test('returns null (no throw) when int key asked as String', () {
      expect(() => store.get<String>('int_key'), returnsNormally);
      expect(store.get<String>('int_key'), isNull);
    });

    test('returns null for missing key', () {
      expect(store.get<String>('no_such_key'), isNull);
    });

    test('returns null (no throw) for missing key with any type', () {
      expect(() => store.get<int>('no_such_key'), returnsNormally);
    });
  });

  group('SharedPreferencesLocalStore.set / containsKey / remove', () {
    late SharedPreferencesLocalStore store;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      store = SharedPreferencesLocalStore(prefs);
    });

    test('set and get String round-trips', () async {
      await store.set<String>('k', 'value');
      expect(store.get<String>('k'), 'value');
    });

    test('set and get int round-trips', () async {
      await store.set<int>('k', 7);
      expect(store.get<int>('k'), 7);
    });

    test('containsKey true after set', () async {
      await store.set<String>('k', 'v');
      expect(store.containsKey('k'), isTrue);
    });

    test('containsKey false after remove', () async {
      await store.set<String>('k', 'v');
      await store.remove('k');
      expect(store.containsKey('k'), isFalse);
    });

    test('clear removes all keys', () async {
      await store.set<String>('a', '1');
      await store.set<String>('b', '2');
      await store.clear();
      expect(store.containsKey('a'), isFalse);
      expect(store.containsKey('b'), isFalse);
    });

    test('set unsupported type throws ArgumentError', () async {
      expect(() => store.set<List<int>>('k', [1, 2]), throwsArgumentError);
    });
  });
}
