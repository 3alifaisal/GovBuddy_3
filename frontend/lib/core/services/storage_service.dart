// Storage service for managing local data persistence.
// This service wraps SharedPreferences and provides a clean API
// for storing and retrieving data

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// Singleton service for local storage operations
class StorageService {
  /// Private constructor for singleton pattern
  StorageService._privateConstructor();
  
  /// Singleton instance
  static final StorageService instance = StorageService._privateConstructor();
  
  /// SharedPreferences instance
  SharedPreferences? _prefs;
  
  /// Initialize the storage service
  ///
  /// Call this during app startup before using any storage methods
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }
  
  /// Check if storage is initialized
  bool get isInitialized => _prefs != null;
  
  // ==================== String Operations ====================
  
  /// Save a string value
  Future<bool> setString(String key, String value) async {
    _ensureInitialized();
    return await _prefs!.setString(key, value);
  }
  
  /// Get a string value
  String? getString(String key) {
    _ensureInitialized();
    return _prefs!.getString(key);
  }
  
  // ==================== Boolean Operations ====================
  
  /// Save a boolean value
  Future<bool> setBool(String key, bool value) async {
    _ensureInitialized();
    return await _prefs!.setBool(key, value);
  }
  
  /// Get a boolean value
  bool? getBool(String key) {
    _ensureInitialized();
    return _prefs!.getBool(key);
  }
  
  // ==================== JSON Operations ====================
  
  /// Save an object as JSON
  Future<bool> setJson(String key, Map<String, dynamic> value) async {
    return await setString(key, jsonEncode(value));
  }
  
  /// Get an object from JSON
  Map<String, dynamic>? getJson(String key) {
    final str = getString(key);
    if (str == null) return null;
    try {
      return jsonDecode(str) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }
  
  // ==================== List Operations ====================
  
  /// Save a list of strings
  Future<bool> setStringList(String key, List<String> value) async {
    _ensureInitialized();
    return await _prefs!.setStringList(key, value);
  }
  
  /// Get a list of strings
  List<String>? getStringList(String key) {
    _ensureInitialized();
    return _prefs!.getStringList(key);
  }
  
  // ==================== Utility Operations ====================
  
  /// Remove a value
  Future<bool> remove(String key) async {
    _ensureInitialized();
    return await _prefs!.remove(key);
  }
  
  /// Clear all stored data
  Future<bool> clear() async {
    _ensureInitialized();
    return await _prefs!.clear();
  }
  
  /// Check if a key exists
  bool containsKey(String key) {
    _ensureInitialized();
    return _prefs!.containsKey(key);
  }

  void _ensureInitialized() {
    if (!isInitialized) {
       // On web/debug sometimes hot restart might lose static instance but prefs logic might persist.
       // Ideally we should throw, but let's log.
       print('WARNING: StorageService accessed before initialization.');
    }
  }
}
