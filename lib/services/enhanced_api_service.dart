import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:ecom_modwir/linkapi.dart';
import 'package:ecom_modwir/controllers/language_controller.dart';
import 'package:ecom_modwir/utils/app_utils.dart';
import 'package:ecom_modwir/services/shared_preferences_service.dart';

class EnhancedApiService {
  static const String baseUrl = AppLink.server;
  static String _apiKey = 'admin_panel_key_2025';

  static SharedPreferencesService get _prefs => SharedPreferencesService.to;
  static String? get _authToken => _prefs.authToken;

  static Map<String, String> get headers => {
        'Content-Type': 'application/json; charset=utf-8',
        'Accept': 'application/json',
        'Accept-Language': Get.find<LanguageController>().currentLanguage.value,
        if (_authToken != null) 'Authorization': 'Bearer $_authToken',
        'X-API-Key': _apiKey,
      };

  // Base HTTP methods with error handling
  static Future<Map<String, dynamic>> _makeRequest(
    String method,
    String url, {
    Map<String, dynamic>? body,
    Map<String, String>? customHeaders,
    Duration? timeout,
  }) async {
    try {
      final uri = Uri.parse(url);
      final requestHeaders = {...headers, ...?customHeaders};
      final timeoutDuration = timeout ?? const Duration(seconds: 30);

      http.Response response;

      switch (method.toUpperCase()) {
        case 'GET':
          response = await http
              .get(uri, headers: requestHeaders)
              .timeout(timeoutDuration);
          break;
        case 'POST':
          response = await http
              .post(
                uri,
                headers: requestHeaders,
                body: body != null ? jsonEncode(body) : null,
              )
              .timeout(timeoutDuration);
          break;
        case 'PUT':
          response = await http
              .put(
                uri,
                headers: requestHeaders,
                body: body != null ? jsonEncode(body) : null,
              )
              .timeout(timeoutDuration);
          break;
        case 'DELETE':
          response = await http
              .delete(uri, headers: requestHeaders)
              .timeout(timeoutDuration);
          break;
        default:
          throw Exception('Unsupported HTTP method: $method');
      }

      return _handleResponse(response);
    } on SocketException {
      throw Exception('No internet connection');
    } on TimeoutException {
      throw Exception('Request timeout');
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  static Map<String, dynamic> _handleResponse(http.Response response) {
    final statusCode = response.statusCode;

    if (statusCode >= 200 && statusCode < 300) {
      try {
        final data = jsonDecode(response.body);
        if (data is Map<String, dynamic>) {
          return data;
        } else {
          return {'data': data, 'status': 'success'};
        }
      } catch (e) {
        return {'data': response.body, 'status': 'success'};
      }
    } else {
      String errorMessage = 'Request failed with status: $statusCode';
      try {
        final errorData = jsonDecode(response.body);
        errorMessage = errorData['message'] ?? errorMessage;
      } catch (e) {
        // Use default error message
      }
      throw Exception(errorMessage);
    }
  }

  // Authentication methods
  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    final response = await _makeRequest(
        'POST', '${AppLink.AdminLink}/auth/login.php',
        body: {
          'email': email,
          'password': password,
        });

    if (response['status'] == 'success') {
      final token = response['data']['token'];
      if (token != null) {
        await _prefs.setAuthToken(token);
        await _prefs.setUserData(jsonEncode(response['data']));
      }
      return response['data'];
    } else {
      throw Exception(response['message'] ?? 'Login failed');
    }
  }

  static Future<void> logout() async {
    try {
      if (_authToken != null) {
        await _makeRequest('POST', '${AppLink.AdminLink}/auth/logout.php');
      }
    } catch (e) {
      // Silent fail for logout
    } finally {
      await _prefs.removeAuthToken();
      await _prefs.removeUserData();
    }
  }

  // Dashboard and Analytics
  static Future<Map<String, dynamic>> getDashboardStats() async {
    final response = await _makeRequest('GET',
        '${AppLink.AdminLink}/dashboard.php?action=dashboard_stats&api_key=$_apiKey');

    if (response['status'] == 'success') {
      return response['data'];
    } else {
      throw Exception(response['message'] ?? 'Failed to load dashboard stats');
    }
  }

  static Future<Map<String, dynamic>> getAdvancedAnalytics({
    required String type,
    String? dateFrom,
    String? dateTo,
  }) async {
    String url =
        '${AppLink.AdminLink}/analytics/advanced_reports.php?action=$type&api_key=$_apiKey';

    if (dateFrom != null) url += '&date_from=$dateFrom';
    if (dateTo != null) url += '&date_to=$dateTo';

    final response = await _makeRequest('GET', url);

    if (response['status'] == 'success') {
      return response['data'];
    } else {
      throw Exception(response['message'] ?? 'Failed to load analytics');
    }
  }

  // System Monitoring
  static Future<Map<String, dynamic>> getSystemMonitorData(String type) async {
    final response = await _makeRequest('GET',
        '${AppLink.AdminLink}/dev_tools/system_monitor.php?type=$type&api_key=$_apiKey');

    if (response['status'] == 'success') {
      return response['data'];
    } else {
      throw Exception(response['message'] ?? 'Failed to load system data');
    }
  }

  static Future<void> clearSystemCache({bool all = false}) async {
    final response = await _makeRequest(
        'POST', '${AppLink.AdminLink}/dev_tools/system_monitor.php',
        body: {
          'action': 'clear_cache',
          'all': all,
          'api_key': _apiKey,
        });

    if (response['status'] != 'success') {
      throw Exception(response['message'] ?? 'Failed to clear cache');
    }
  }

  static Future<void> toggleMaintenanceMode() async {
    final response = await _makeRequest(
        'POST', '${AppLink.AdminLink}/dev_tools/system_monitor.php',
        body: {
          'action': 'toggle_maintenance',
          'api_key': _apiKey,
        });

    if (response['status'] != 'success') {
      throw Exception(
          response['message'] ?? 'Failed to toggle maintenance mode');
    }
  }

  // Bulk Operations
  static Future<Map<String, dynamic>> bulkOperation({
    required String action,
    required Map<String, dynamic> data,
  }) async {
    final requestData = {
      'action': action,
      'api_key': _apiKey,
      ...data,
    };

    final response = await _makeRequest(
        'POST', '${AppLink.AdminLink}/bulk_operations.php',
        body: requestData);

    if (response['status'] == 'success') {
      return response;
    } else {
      throw Exception(response['message'] ?? 'Bulk operation failed');
    }
  }

  // Advanced Search
  static Future<Map<String, dynamic>> advancedSearch({
    required String type,
    required String query,
    String? lang,
  }) async {
    final languageController = Get.find<LanguageController>();
    final searchLang = lang ?? languageController.currentLanguage.value;

    final url =
        '${AppLink.AdminLink}/search/advanced_search.php?type=$type&q=${Uri.encodeComponent(query)}&lang=$searchLang&api_key=$_apiKey';

    final response = await _makeRequest('GET', url);

    if (response['status'] == 'success') {
      return response['data'];
    } else {
      return {};
    }
  }

  // Cached Dashboard
  static Future<Map<String, dynamic>> getCachedDashboardStats() async {
    final response = await _makeRequest('GET',
        '${AppLink.AdminLink}/cached_dashboard.php?action=dashboard_stats&api_key=$_apiKey');

    if (response['status'] == 'success') {
      return response['data'];
    } else {
      throw Exception(response['message'] ?? 'Failed to load dashboard');
    }
  }

  // File Upload with Progress
  static Future<List<Map<String, dynamic>>> uploadFiles({
    required String endpoint,
    required List<String> filePaths,
    Map<String, String>? additionalData,
    Function(double)? onProgress,
  }) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(endpoint));

      // Add API key and auth headers
      request.fields['api_key'] = _apiKey;
      if (_authToken != null) {
        request.headers['Authorization'] = 'Bearer $_authToken';
      }

      // Add additional data
      if (additionalData != null) {
        request.fields.addAll(additionalData);
      }

      // Add files
      for (int i = 0; i < filePaths.length; i++) {
        request.files.add(await http.MultipartFile.fromPath(
          'attachments[]',
          filePaths[i],
        ));
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      final responseData = _handleResponse(response);

      if (responseData['status'] == 'success') {
        return List<Map<String, dynamic>>.from(
            responseData['uploaded_files'] ?? []);
      } else {
        throw Exception(responseData['message'] ?? 'Upload failed');
      }
    } catch (e) {
      throw Exception('Upload error: $e');
    }
  }

  // Users Management
  static Future<List<Map<String, dynamic>>> getUsers({
    String? search,
    String? status,
    int? page,
    int? limit,
  }) async {
    String url =
        '${AppLink.AdminLink}/users/view.php?lang=${Get.find<LanguageController>().currentLanguage.value}';

    if (search?.isNotEmpty == true)
      url += '&search=${Uri.encodeComponent(search!)}';
    if (status?.isNotEmpty == true) url += '&status=$status';
    if (page != null) url += '&page=$page';
    if (limit != null) url += '&limit=$limit';

    final response = await _makeRequest('GET', url);

    if (response['status'] == 'success') {
      return List<Map<String, dynamic>>.from(response['data'] ?? []);
    } else {
      return [];
    }
  }

  static Future<void> updateUserStatus(int userId, String status) async {
    final response = await _makeRequest(
        'POST', '${AppLink.AdminLink}/users/update_status.php',
        body: {
          'user_id': userId,
          'status': status,
        });

    if (response['status'] != 'success') {
      throw Exception(response['message'] ?? 'Failed to update user status');
    }
  }

  // Orders Management
  static Future<List<Map<String, dynamic>>> getOrders({
    String? status,
    String? search,
    int? page,
    int? limit,
  }) async {
    String url =
        '${AppLink.detailsOrders}?lang=${Get.find<LanguageController>().currentLanguage.value}';

    if (status?.isNotEmpty == true) url += '&status=$status';
    if (search?.isNotEmpty == true)
      url += '&search=${Uri.encodeComponent(search!)}';
    if (page != null) url += '&page=$page';
    if (limit != null) url += '&limit=$limit';

    final response = await _makeRequest('GET', url);

    if (response['status'] == 'success') {
      return List<Map<String, dynamic>>.from(response['data'] ?? []);
    } else {
      return [];
    }
  }

  static Future<Map<String, dynamic>> getOrderDetails(int orderId) async {
    final response = await _makeRequest('GET',
        '${AppLink.detailsOrders}?order_id=$orderId&lang=${Get.find<LanguageController>().currentLanguage.value}');

    if (response['status'] == 'success') {
      return response['data'];
    } else {
      throw Exception(response['message'] ?? 'Failed to load order details');
    }
  }

  static Future<void> updateOrderStatus(int orderId, int status,
      {String? notes}) async {
    final response = await _makeRequest(
        'POST', '${AppLink.ordersLink}/update_status.php',
        body: {
          'order_id': orderId,
          'status': status,
          if (notes != null) 'notes': notes,
        });

    if (response['status'] != 'success') {
      throw Exception(response['message'] ?? 'Failed to update order status');
    }
  }

  // Services Management
  static Future<List<Map<String, dynamic>>> getServices(
      {String? status}) async {
    String url =
        '${AppLink.serviceDisplay}?lang=${Get.find<LanguageController>().currentLanguage.value}';

    if (status?.isNotEmpty == true) url += '&status=$status';

    final response = await _makeRequest('GET', url);

    if (response['status'] == 'success') {
      return List<Map<String, dynamic>>.from(response['data'] ?? []);
    } else {
      return [];
    }
  }

  static Future<void> deleteService(int serviceId) async {
    final response =
        await _makeRequest('POST', '${AppLink.linkServices}/delete.php', body: {
      'service_id': serviceId,
    });

    if (response['status'] != 'success') {
      throw Exception(response['message'] ?? 'Failed to delete service');
    }
  }

  // Vehicles Management
  static Future<List<Map<String, dynamic>>> getVehicles({
    int? userId,
    int? makeId,
    String? search,
  }) async {
    String url =
        '${AppLink.vehicleView}?lang=${Get.find<LanguageController>().currentLanguage.value}';

    if (userId != null) url += '&user_id=$userId';
    if (makeId != null) url += '&make_id=$makeId';
    if (search?.isNotEmpty == true)
      url += '&search=${Uri.encodeComponent(search!)}';

    final response = await _makeRequest('GET', url);

    if (response['status'] == 'success') {
      return List<Map<String, dynamic>>.from(response['data'] ?? []);
    } else {
      return [];
    }
  }

  static Future<void> deleteVehicle(int vehicleId) async {
    final response = await _makeRequest('POST', AppLink.vehicleRemove, body: {
      'vehicle_id': vehicleId,
    });

    if (response['status'] != 'success') {
      throw Exception(response['message'] ?? 'Failed to delete vehicle');
    }
  }

  // Payments Management
  static Future<List<Map<String, dynamic>>> getPayments(
      {String? status}) async {
    String url = '${AppLink.processPayment}/view.php';

    if (status?.isNotEmpty == true) url += '?status=$status';

    final response = await _makeRequest('GET', url);

    if (response['status'] == 'success') {
      return List<Map<String, dynamic>>.from(response['data'] ?? []);
    } else {
      return [];
    }
  }

  // Notifications Management
  static Future<List<Map<String, dynamic>>> getNotifications({
    int? userId,
    int? read,
  }) async {
    String url =
        '${AppLink.notificationLink}/view.php?lang=${Get.find<LanguageController>().currentLanguage.value}';

    if (userId != null) url += '&user_id=$userId';
    if (read != null) url += '&read=$read';

    final response = await _makeRequest('GET', url);

    if (response['status'] == 'success') {
      return List<Map<String, dynamic>>.from(response['data'] ?? []);
    } else {
      return [];
    }
  }

  static Future<void> markNotificationRead(int notificationId) async {
    final response = await _makeRequest('POST', AppLink.markNotiRead, body: {
      'notification_id': notificationId,
    });

    if (response['status'] != 'success') {
      throw Exception(
          response['message'] ?? 'Failed to mark notification as read');
    }
  }

  static Future<void> markAllNotificationsRead({int? userId}) async {
    final response = await _makeRequest('POST', AppLink.markAllNotiRead, body: {
      if (userId != null) 'user_id': userId,
    });

    if (response['status'] != 'success') {
      throw Exception(
          response['message'] ?? 'Failed to mark all notifications as read');
    }
  }

  static Future<void> sendNotification(
      String title, String body, int userId) async {
    final response = await _makeRequest('POST', AppLink.notificatoin, body: {
      'title': title,
      'body': body,
      'user_id': userId,
    });

    if (response['status'] != 'success') {
      throw Exception(response['message'] ?? 'Failed to send notification');
    }
  }

  // Settings Management
  static Future<Map<String, dynamic>> getSettings() async {
    final response =
        await _makeRequest('GET', '${AppLink.AdminLink}/settings/view.php');

    if (response['status'] == 'success') {
      return response['data'];
    } else {
      return {};
    }
  }

  static Future<void> updateSetting(String key, dynamic value) async {
    final response = await _makeRequest(
        'POST', '${AppLink.AdminLink}/settings/update.php',
        body: {
          'key': key,
          'value': value,
        });

    if (response['status'] != 'success') {
      throw Exception(response['message'] ?? 'Failed to update setting');
    }
  }

  // Export functionality
  static Future<String> exportData(
    String dataType, {
    String format = 'csv',
    Map<String, dynamic>? filters,
  }) async {
    String url =
        '${AppLink.AdminLink}/export.php?type=$dataType&format=$format';

    if (filters != null) {
      filters.forEach((key, value) {
        url += '&$key=${Uri.encodeComponent(value.toString())}';
      });
    }

    final response = await _makeRequest('GET', url);

    if (response is String) {
      return response;
    } else if (response['status'] == 'success') {
      return response['data'] ?? '';
    } else {
      throw Exception(response['message'] ?? 'Export failed');
    }
  }

  // Car Makes and Models
  static Future<List<Map<String, dynamic>>> getCarMakes(
      {String? search}) async {
    String url =
        '${AppLink.carsMakeDisplay}?lang=${Get.find<LanguageController>().currentLanguage.value}';

    if (search?.isNotEmpty == true)
      url += '&search=${Uri.encodeComponent(search!)}';

    final response = await _makeRequest('GET', url);

    if (response['status'] == 'success') {
      return List<Map<String, dynamic>>.from(response['data'] ?? []);
    } else {
      return [];
    }
  }

  // Sub Services
  static Future<List<Map<String, dynamic>>> getSubServices(
      {int? serviceId}) async {
    String url =
        '${AppLink.subserviceDisplay}?lang=${Get.find<LanguageController>().currentLanguage.value}';

    if (serviceId != null) url += '&service_id=$serviceId';

    final response = await _makeRequest('GET', url);

    if (response['status'] == 'success') {
      return List<Map<String, dynamic>>.from(response['data'] ?? []);
    } else {
      return [];
    }
  }

  // Error handling helper
  static void handleApiError(dynamic error) {
    String message = 'An error occurred';

    if (error is Exception) {
      message = error.toString().replaceFirst('Exception: ', '');
    } else if (error is String) {
      message = error;
    }

    AppUtils.showError(message);
  }
}
