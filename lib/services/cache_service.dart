import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  static const String _prefix = 'scamtap_';

  /// Save data to local cache
  Future<void> saveResult(String key, Map<String, dynamic> data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final fullKey = _prefix + key;
      await prefs.setString(fullKey, jsonEncode(data));
    } catch (e) {
      print('Cache save error: $e');
    }
  }

  /// Get data from local cache
  Future<Map<String, dynamic>?> getResult(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final fullKey = _prefix + key;
      final String? saved = prefs.getString(fullKey);
      
      if (saved != null) {
        return jsonDecode(saved);
      }
      return null;
    } catch (e) {
      print('Cache get error: $e');
      return null;
    }
  }

  /// Clear specific cache entry
  Future<void> clearCache(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final fullKey = _prefix + key;
      await prefs.remove(fullKey);
    } catch (e) {
      print('Cache clear error: $e');
    }
  }

  /// Clear all cache entries for this app
  Future<void> clearAllCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();
      
      for (String key in keys) {
        if (key.startsWith(_prefix)) {
          await prefs.remove(key);
        }
      }
    } catch (e) {
      print('Cache clear all error: $e');
    }
  }

  /// Get all cached results
  Future<Map<String, dynamic>> getAllCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final Map<String, dynamic> allCache = {};
      
      for (String key in prefs.getKeys()) {
        if (key.startsWith(_prefix)) {
          final cleanKey = key.replaceFirst(_prefix, '');
          final value = prefs.getString(key);
          if (value != null) {
            allCache[cleanKey] = jsonDecode(value);
          }
        }
      }
      return allCache;
    } catch (e) {
      print('Cache get all error: $e');
      return {};
    }
  }

  /// Check if cache key exists
  Future<bool> hasCache(String key) async {
    try {
      final result = await getResult(key);
      return result != null;
    } catch (e) {
      return false;
    }
  }
}
