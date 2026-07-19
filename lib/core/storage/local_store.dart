import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class LocalStore {
  T? get<T>(String key);
  Future<void> set<T>(String key, T value);
  Future<void> remove(String key);
  Future<void> clear();
  bool containsKey(String key);
}

class SharedPreferencesLocalStore implements LocalStore {
  SharedPreferencesLocalStore(this._prefs);

  final SharedPreferences _prefs;

  @override
  T? get<T>(String key) {
    final value = _prefs.get(key);
    if (value is T) return value;
    return null;
  }

  @override
  Future<void> set<T>(String key, T value) async {
    if (value is String) {
      await _prefs.setString(key, value);
    } else if (value is int) {
      await _prefs.setInt(key, value);
    } else if (value is double) {
      await _prefs.setDouble(key, value);
    } else if (value is bool) {
      await _prefs.setBool(key, value);
    } else if (value is List<String>) {
      await _prefs.setStringList(key, value);
    } else {
      throw ArgumentError('Unsupported type: ${value.runtimeType}');
    }
  }

  @override
  Future<void> remove(String key) => _prefs.remove(key);

  @override
  Future<void> clear() => _prefs.clear();

  @override
  bool containsKey(String key) => _prefs.containsKey(key);
}

final localStoreProvider = FutureProvider<LocalStore>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return SharedPreferencesLocalStore(prefs);
});
