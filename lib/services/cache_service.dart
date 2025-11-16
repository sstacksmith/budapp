import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  static const String _cachePrefix = 'cache_';
  static const Duration _defaultCacheDuration = Duration(hours: 24);

  static final CacheService _instance = CacheService._internal();
  factory CacheService() => _instance;
  CacheService._internal();

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> saveToCache(String key, Map<String, dynamic> data, {Duration? duration}) async {
    final cacheKey = '$_cachePrefix$key';
    final expiryTime = DateTime.now().add(duration ?? _defaultCacheDuration).millisecondsSinceEpoch;
    
    final cacheData = {
      'data': data,
      'expiry': expiryTime,
    };
    
    await _prefs?.setString(cacheKey, jsonEncode(cacheData));
  }

  Map<String, dynamic>? getFromCache(String key) {
    final cacheKey = '$_cachePrefix$key';
    final String? cacheString = _prefs?.getString(cacheKey);
    
    if (cacheString == null) {
      return null;
    }

    try {
      final cacheData = jsonDecode(cacheString) as Map<String, dynamic>;
      final expiryTime = cacheData['expiry'] as int;
      
      if (DateTime.now().millisecondsSinceEpoch > expiryTime) {
        _prefs?.remove(cacheKey);
        return null;
      }
      
      return cacheData['data'] as Map<String, dynamic>;
    } catch (e) {
      _prefs?.remove(cacheKey);
      return null;
    }
  }

  Future<void> clearCache(String key) async {
    final cacheKey = '$_cachePrefix$key';
    await _prefs?.remove(cacheKey);
  }

  // Clear all cache
  Future<void> clearAllCache() async {
    final keys = _prefs?.getKeys() ?? {};
    for (final key in keys) {
      if (key.startsWith(_cachePrefix)) {
        await _prefs?.remove(key);
      }
    }
  }

  bool isCacheValid(String key) {
    final cacheKey = '$_cachePrefix$key';
    final String? cacheString = _prefs?.getString(cacheKey);
    
    if (cacheString == null) return false;

    try {
      final cacheData = jsonDecode(cacheString) as Map<String, dynamic>;
      final expiryTime = cacheData['expiry'] as int;
      return DateTime.now().millisecondsSinceEpoch <= expiryTime;
    } catch (e) {
      return false;
    }
  }
}


