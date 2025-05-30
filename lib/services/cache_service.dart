import 'dart:convert';

import 'package:get/get.dart';

import 'package:ecom_modwir/services/shared_preferences_service.dart';

class CacheService extends GetxService {
  static CacheService get to => Get.find();

  final _prefs = SharedPreferencesService.to;

  final Map<String, CacheItem> _memoryCache = {};

  // Cache durations

  static const Duration shortDuration = Duration(minutes: 5);

  static const Duration mediumDuration = Duration(hours: 1);

  static const Duration longDuration = Duration(days: 1);

  // Store data in cache with expiration

  void store(String key, dynamic data, {Duration? duration}) {
    final expiry = DateTime.now().add(duration ?? mediumDuration);

    final cacheItem = CacheItem(data: data, expiry: expiry);

    // Store in memory

    _memoryCache[key] = cacheItem;

    // Store in persistent storage for important data

    if (duration == null || duration.inHours >= 1) {
      _prefs.setString(
          'cache_$key',
          jsonEncode({
            'data': data,
            'expiry': expiry.millisecondsSinceEpoch,
          }));
    }
  }

  // Retrieve data from cache

  T? get<T>(String key) {
    // Check memory cache first

    final memoryCacheItem = _memoryCache[key];

    if (memoryCacheItem != null && !memoryCacheItem.isExpired) {
      return memoryCacheItem.data as T?;
    }

    // Check persistent cache

    final cachedString = _prefs.getString('cache_$key');

    if (cachedString != null) {
      try {
        final cachedData = jsonDecode(cachedString);

        final expiry =
            DateTime.fromMillisecondsSinceEpoch(cachedData['expiry']);

        if (DateTime.now().isBefore(expiry)) {
          final data = cachedData['data'] as T;

          // Restore to memory cache

          _memoryCache[key] = CacheItem(data: data, expiry: expiry);

          return data;
        } else {
          // Remove expired cache

          _prefs.remove('cache_$key');
        }
      } catch (e) {
        // Invalid cache data, remove it

        _prefs.remove('cache_$key');
      }
    }

    return null;
  }

  // Check if cache exists and is valid

  bool exists(String key) {
    return get(key) != null;
  }

  // Remove specific cache item

  void remove(String key) {
    _memoryCache.remove(key);

    _prefs.remove('cache_$key');
  }

  // Clear all cache

  void clearAll() {
    _memoryCache.clear();

    // Remove all cache keys from persistent storage

    // This would require getting all keys and filtering
  }

  // Clear expired cache items

  void clearExpired() {
    final now = DateTime.now();

    _memoryCache.removeWhere((key, item) => item.isExpired);

    // For persistent storage, we'd need to iterate through all keys

    // This is simplified for the example
  }

  // Get cache statistics

  CacheStats getStats() {
    final total = _memoryCache.length;

    final expired = _memoryCache.values.where((item) => item.isExpired).length;

    final valid = total - expired;

    return CacheStats(
      totalItems: total,
      validItems: valid,
      expiredItems: expired,
    );
  }
}

class CacheItem {
  final dynamic data;

  final DateTime expiry;

  CacheItem({required this.data, required this.expiry});

  bool get isExpired => DateTime.now().isAfter(expiry);
}

class CacheStats {
  final int totalItems;

  final int validItems;

  final int expiredItems;

  CacheStats({
    required this.totalItems,
    required this.validItems,
    required this.expiredItems,
  });
}
