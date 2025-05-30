import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:get/get.dart';

import 'package:ecom_modwir/linkapi.dart';

import 'package:ecom_modwir/controllers/language_controller.dart';

import 'package:ecom_modwir/utils/app_utils.dart';

class EnhancedApiService {
  static const String baseUrl = AppLink.server;

  static String? _authToken;

  static String _apiKey = 'admin_panel_key_2025';

  static Map<String, String> get headers => {
        'Content-Type': 'application/json; charset=utf-8',
        'Accept': 'application/json',
        if (_authToken != null) 'Authorization': 'Bearer $_authToken',
      };

  // Authentication

  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${AppLink.AdminLink}/auth/login.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 'success') {
          _authToken = data['data']['token'];

          return data['data'];
        } else {
          throw Exception(data['message']);
        }
      } else {
        throw Exception('Login failed');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  static Future<void> logout() async {
    try {
      if (_authToken != null) {
        await http.post(
          Uri.parse('${AppLink.AdminLink}/auth/logout.php'),
          headers: headers,
        );

        _authToken = null;
      }
    } catch (e) {
      // Silent fail for logout
    }
  }

  // Advanced Analytics

  static Future<Map<String, dynamic>> getAdvancedAnalytics({
    required String type,
    String? dateFrom,
    String? dateTo,
  }) async {
    try {
      String url =
          '${AppLink.AdminLink}/analytics/advanced_reports.php?action=$type&api_key=$_apiKey';

      if (dateFrom != null) url += '&date_from=$dateFrom';

      if (dateTo != null) url += '&date_to=$dateTo';

      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 'success') {
          return data['data'];
        } else {
          throw Exception(data['message']);
        }
      } else {
        throw Exception('Failed to load analytics');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Bulk Operations

  static Future<Map<String, dynamic>> bulkOperation({
    required String action,
    required Map<String, dynamic> data,
  }) async {
    try {
      final formData = <String, String>{
        'action': action,
        'api_key': _apiKey,
      };

      data.forEach((key, value) {
        formData[key] = value.toString();
      });

      final response = await http.post(
        Uri.parse('${AppLink.AdminLink}/bulk_operations.php'),
        body: formData,
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['status'] == 'success') {
          return responseData;
        } else {
          throw Exception(responseData['message']);
        }
      } else {
        throw Exception('Bulk operation failed');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Advanced Search

  static Future<Map<String, dynamic>> advancedSearch({
    required String type,
    required String query,
    String? lang,
  }) async {
    try {
      final languageController = Get.find<LanguageController>();

      final searchLang = lang ?? languageController.currentLanguage.value;

      final response = await http.get(
        Uri.parse(
            '${AppLink.AdminLink}/search/advanced_search.php?type=$type&q=${Uri.encodeComponent(query)}&lang=$searchLang&api_key=$_apiKey'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 'success') {
          return data['data'];
        } else {
          return {};
        }
      } else {
        throw Exception('Search failed');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Cached Dashboard

  static Future<Map<String, dynamic>> getCachedDashboardStats() async {
    try {
      final response = await http.get(
        Uri.parse(
            '${AppLink.AdminLink}/cached_dashboard.php?action=dashboard_stats&api_key=$_apiKey'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 'success') {
          return data['data'];
        } else {
          throw Exception(data['message']);
        }
      } else {
        throw Exception('Failed to load dashboard');
      }
    } catch (e) {
      throw Exception('Network error: $e');
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

      // Add API key

      request.fields['api_key'] = _apiKey;

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

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 'success') {
          return List<Map<String, dynamic>>.from(data['uploaded_files'] ?? []);
        } else {
          throw Exception(data['message']);
        }
      } else {
        throw Exception('Upload failed');
      }
    } catch (e) {
      throw Exception('Upload error: $e');
    }
  }
}
