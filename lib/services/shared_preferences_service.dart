// lib/services/shared_preferences_service.dart
import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService extends GetxService {
  static SharedPreferencesService get to => Get.find();

  late SharedPreferences _prefs;

  // Initialize the service
  Future<SharedPreferencesService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  // Theme Settings
  bool get isDarkMode => _prefs.getBool('isDarkMode') ?? true;

  Future<void> setThemeMode(bool isDark) async {
    await _prefs.setBool('isDarkMode', isDark);
  }

  // Language Settings
  String get language => _prefs.getString('language') ?? 'en';

  Future<void> setLanguage(String languageCode) async {
    await _prefs.setString('language', languageCode);
  }

  // Authentication - Fixed method names
  String? get authToken => _prefs.getString('auth_token');
  String? getToken() => _prefs.getString('auth_token'); // Added this method

  Future<void> setAuthToken(String token) async {
    await _prefs.setString('auth_token', token);
  }

  Future<void> saveToken(String token) async {
    // Added this method
    await _prefs.setString('auth_token', token);
  }

  Future<void> removeAuthToken() async {
    await _prefs.remove('auth_token');
  }

  // User Data
  String? get userData => _prefs.getString('user_data');

  Future<void> setUserData(String userData) async {
    await _prefs.setString('user_data', userData);
  }

  Future<void> removeUserData() async {
    await _prefs.remove('user_data');
  }

  Map<String, dynamic>? getUserData() {
    // Added this method
    final userData = _prefs.getString('user_data');
    if (userData != null) {
      try {
        return json.decode(userData);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  Future<void> saveUserData(Map<String, dynamic> data) async {
    // Added this method
    await _prefs.setString('user_data', json.encode(data));
  }

  // Clear Authentication Data - Fixed method
  Future<void> clearAuthData() async {
    await removeAuthToken();
    await removeUserData();
  }

  // Generic String Storage
  String? getString(String key) => _prefs.getString(key);

  Future<void> setString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  // Generic Int Storage
  int? getInt(String key) => _prefs.getInt(key);

  Future<void> setInt(String key, int value) async {
    await _prefs.setInt(key, value);
  }

  // Generic Bool Storage
  bool? getBool(String key) => _prefs.getBool(key);

  Future<void> setBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  // Generic Double Storage
  double? getDouble(String key) => _prefs.getDouble(key);

  Future<void> setDouble(String key, double value) async {
    await _prefs.setDouble(key, value);
  }

  // Remove specific key
  Future<void> remove(String key) async {
    await _prefs.remove(key);
  }

  // Clear all preferences
  Future<void> clearAll() async {
    await _prefs.clear();
  }

  // Check if key exists
  bool containsKey(String key) => _prefs.containsKey(key);

  // Get all keys
  Set<String> getAllKeys() => _prefs.getKeys();

  // App Settings
  String get lastUsedVersion =>
      _prefs.getString('last_used_version') ?? '1.0.0';

  Future<void> setLastUsedVersion(String version) async {
    await _prefs.setString('last_used_version', version);
  }

  // First Launch
  bool get isFirstLaunch => _prefs.getBool('is_first_launch') ?? true;

  Future<void> setFirstLaunchComplete() async {
    await _prefs.setBool('is_first_launch', false);
  }

  // Dashboard Preferences
  String get defaultDashboardView =>
      _prefs.getString('default_dashboard_view') ?? 'grid';

  Future<void> setDefaultDashboardView(String view) async {
    await _prefs.setString('default_dashboard_view', view);
  }

  // Notification Preferences
  bool get notificationsEnabled =>
      _prefs.getBool('notifications_enabled') ?? true;

  Future<void> setNotificationsEnabled(bool enabled) async {
    await _prefs.setBool('notifications_enabled', enabled);
  }

  // Auto-refresh Settings
  bool get autoRefreshEnabled => _prefs.getBool('auto_refresh_enabled') ?? true;

  Future<void> setAutoRefreshEnabled(bool enabled) async {
    await _prefs.setBool('auto_refresh_enabled', enabled);
  }

  int get autoRefreshInterval =>
      _prefs.getInt('auto_refresh_interval') ?? 30; // seconds

  Future<void> setAutoRefreshInterval(int seconds) async {
    await _prefs.setInt('auto_refresh_interval', seconds);
  }

  // Cache Settings
  int get cacheTimeout => _prefs.getInt('cache_timeout') ?? 300; // 5 minutes

  Future<void> setCacheTimeout(int seconds) async {
    await _prefs.setInt('cache_timeout', seconds);
  }

  // Developer Settings
  bool get developerMode => _prefs.getBool('developer_mode') ?? false;

  Future<void> setDeveloperMode(bool enabled) async {
    await _prefs.setBool('developer_mode', enabled);
  }

  bool get debugLogging => _prefs.getBool('debug_logging') ?? false;

  Future<void> setDebugLogging(bool enabled) async {
    await _prefs.setBool('debug_logging', enabled);
  }

  // Recent Searches
  List<String> get recentSearches =>
      _prefs.getStringList('recent_searches') ?? [];

  Future<void> addRecentSearch(String search) async {
    final searches = recentSearches;
    searches.remove(search); // Remove if exists
    searches.insert(0, search); // Add to beginning

    // Keep only last 10
    if (searches.length > 10) {
      searches.removeRange(10, searches.length);
    }

    await _prefs.setStringList('recent_searches', searches);
  }

  Future<void> clearRecentSearches() async {
    await _prefs.remove('recent_searches');
  }

  // Favorite Items
  List<String> getFavorites(String type) =>
      _prefs.getStringList('favorites_$type') ?? [];

  Future<void> addToFavorites(String type, String itemId) async {
    final favorites = getFavorites(type);
    if (!favorites.contains(itemId)) {
      favorites.add(itemId);
      await _prefs.setStringList('favorites_$type', favorites);
    }
  }

  Future<void> removeFromFavorites(String type, String itemId) async {
    final favorites = getFavorites(type);
    favorites.remove(itemId);
    await _prefs.setStringList('favorites_$type', favorites);
  }

  bool isFavorite(String type, String itemId) {
    return getFavorites(type).contains(itemId);
  }
}
