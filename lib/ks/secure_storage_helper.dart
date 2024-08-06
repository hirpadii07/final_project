import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Author: Khushpreet Kaur
///
/// A helper class for managing secure storage using the FlutterSecureStorage package.
class SecureStorageHelper {
  /// The singleton instance of the SecureStorageHelper.
  static final SecureStorageHelper _instance = SecureStorageHelper._internal();

  /// The secure storage instance.
  final _storage = const FlutterSecureStorage();

  /// Private constructor for creating an instance of SecureStorageHelper.
  SecureStorageHelper._internal();

  /// Factory constructor to return the singleton instance.
  factory SecureStorageHelper() {
    return _instance;
  }

  /// Saves a value to secure storage.
  ///
  /// [key] is the key under which the value will be stored.
  /// [value] is the value to be stored.
  Future<void> saveData(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  /// Retrieves a value from secure storage.
  ///
  /// [key] is the key under which the value is stored.
  ///
  /// Returns the value associated with the key, or null if the key does not exist.
  Future<String?> getData(String key) async {
    return await _storage.read(key: key);
  }

  /// Deletes a value from secure storage.
  ///
  /// [key] is the key under which the value is stored.
  Future<void> deleteData(String key) async {
    await _storage.delete(key: key);
  }
}
