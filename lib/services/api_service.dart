import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:ecom_modwir/controllers/language_controller.dart';
import 'package:ecom_modwir/services/error_handler_service.dart';
import 'package:ecom_modwir/services/shared_preferences_service.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:ecom_modwir/linkapi.dart';

import 'package:ecom_modwir/modules/user_model.dart';

import 'package:ecom_modwir/modules/service_model.dart';

import 'package:ecom_modwir/modules/order_model.dart';

import 'package:ecom_modwir/modules/payment_model.dart';

import 'package:ecom_modwir/modules/dashboard_stats.dart';

import 'package:ecom_modwir/modules/vehicle_model.dart';

import 'package:ecom_modwir/modules/car_make_model.dart';

import 'package:ecom_modwir/modules/sub_service_model.dart';

import 'package:ecom_modwir/modules/notification_model.dart';

class ApiService {
  final String baseUrl = AppLink.server;
  final SharedPreferencesService _prefs = Get.find<SharedPreferencesService>();
  final ErrorHandlerService _errorHandler =
      Get.put(ErrorHandlerService()); // Or Get.find if already bound

  static Map<String, String> get headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  Future<Map<String, dynamic>> _request(String method, String endpoint,
      {Map<String, dynamic>? body,
      Map<String, String>? queryParams,
      bool requiresAuth = true}) async {
    Uri uri;
    if (queryParams != null) {
      uri =
          Uri.parse("$baseUrl$endpoint").replace(queryParameters: queryParams);
    } else {
      uri = Uri.parse("$baseUrl$endpoint");
    }

    Map<String, String> headers = {
      "Content-Type": "application/json; charset=UTF-8",

      "Accept": "application/json",
      // Add language header if needed by backend

      "Accept-Language": Get.find<LanguageController>().currentLanguage.value,
    };

    if (requiresAuth) {
      final token = _prefs.authToken;
      if (token == null) {
        // Handle missing token - maybe redirect to login or throw specific error
        // For now, throw an error that can be caught by the caller
        throw Exception("Unauthorized: No authentication token found.");
      }
      headers["Authorization"] =
          "Bearer $token"; // Adjust based on backend expectation
    }

    http.Response response;
    String? requestBody = body != null ? jsonEncode(body) : null;

    print("[API Request] $method $uri\nHeaders: $headers\nBody: $requestBody");

    try {
      switch (method.toUpperCase()) {
        case "GET":
          response = await http
              .get(uri, headers: headers)
              .timeout(const Duration(seconds: 30));
          break;
        case "POST":
          response = await http
              .post(uri, headers: headers, body: requestBody)
              .timeout(const Duration(seconds: 30));
          break;
        case "PUT":
          response = await http
              .put(uri, headers: headers, body: requestBody)
              .timeout(const Duration(seconds: 30));
          break;
        case "DELETE":
          response = await http
              .delete(uri, headers: headers, body: requestBody)
              .timeout(const Duration(seconds: 30));
          break;
        default:
          throw Exception("Unsupported HTTP method: $method");
      }

      print(
          "[API Response] ${response.statusCode} ${response.reasonPhrase}\nBody: ${response.body}");

      // Attempt to decode JSON regardless of status code, as errors might be in JSON format
      Map<String, dynamic> responseData = {};
      try {
        responseData = jsonDecode(response.body);
      } catch (e) {
        // If decoding fails, use the raw body (or part of it) as the message
        responseData = {
          "status": "error",
          "message":
              "Failed to decode JSON response: ${response.body.substring(0, 100)}",
          "data": null
        };
      }

      if (response.statusCode >= 200 && response.statusCode < 300) {
        // Check for backend-defined success status if applicable
        if (responseData.containsKey("status") &&
            responseData["status"] != "success") {
          // Handle backend error message
          throw Exception(responseData["message"] ??
              "API returned status: ${responseData["status"]}");
        }
        return responseData; // Return decoded JSON
      } else {
        // Handle HTTP error status codes using ErrorHandlerService
        _errorHandler.handleError(
          response.statusCode,
        );
        // Throw an exception to be caught by the calling controller
        throw Exception(
            responseData["message"] ?? "HTTP Error: ${response.statusCode}");
      }
    } on SocketException catch (e) {
      print("[API Error - SocketException] $e");
      _errorHandler.handleError(e);
      throw Exception("Network error: Could not connect to the server.");
    } on http.ClientException catch (e) {
      print("[API Error - ClientException] $e");
      _errorHandler.handleError(e);
      throw Exception("Network error: ${e.message}");
    } on TimeoutException catch (e) {
      print("[API Error - TimeoutException] $e");
      _errorHandler.handleError(e);
      throw Exception("Request timed out. Please try again.");
    } catch (e) {
      print("[API Error - General] $e");
      rethrow;
    }
  }

  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> body,
      {bool requiresAuth = true}) async {
    // Ensure the endpoint starts with a slash if needed by the base URL structure
    String formattedEndpoint =
        endpoint.startsWith("/") ? endpoint : "/$endpoint";
    // Use the correct base URL (assuming AppLink.server includes the base path)
    return await _request("POST", formattedEndpoint,
        body: body, requiresAuth: requiresAuth);
  }

  // Dashboard API

  static Future<DashboardStats> getDashboardStats() async {
    try {
      final response = await http.get(
        Uri.parse('${AppLink.AdminLink}/dashboard.php?action=dashboard_stats'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 'success') {
          return DashboardStats.fromJson(data['data']);
        } else {
          throw Exception(data['message'] ?? 'Failed to load dashboard stats');
        }
      } else {
        throw Exception('HTTP ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Users API

  static Future<List<UserModel>> getUsers(
      {String? search, String? status}) async {
    try {
      String url = '${AppLink.AdminLink}/users/view.php?lang=en';

      if (search?.isNotEmpty == true) url += '&search=$search';

      if (status?.isNotEmpty == true) url += '&status=$status';

      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 'success') {
          List<dynamic> usersJson = data['data'];

          return usersJson.map((json) => UserModel.fromJson(json)).toList();
        } else {
          return [];
        }
      } else {
        throw Exception('HTTP ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  static Future<VehicleModel?> getVehicleById(int vehicleId) async {
    try {
      print('Loading vehicle details for ID: $vehicleId');

      // Use existing vehicle endpoint with vehicle_id filter

      String url =
          '${AppLink.vehicleView}?lang=${Get.find<LanguageController>().currentLanguage.value}&vehicle_id=$vehicleId';

      final response = await http.get(Uri.parse(url), headers: headers);

      print('Vehicle API Response Status: ${response.statusCode}');

      print('Vehicle API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 'success') {
          List<dynamic> vehiclesJson = data['data'];

          print('Found ${vehiclesJson.length} vehicles');

          if (vehiclesJson.isNotEmpty) {
            print('Parsing vehicle data: ${vehiclesJson.first}');

            return VehicleModel.fromJson(vehiclesJson.first);
          } else {
            print('No vehicles found in response data');
          }
        } else {
          print(
              'API returned error status: ${data['message'] ?? 'Unknown error'}');
        }
      } else {
        print('HTTP error: ${response.statusCode}');
      }

      return null;
    } catch (e, stackTrace) {
      print('Error getting vehicle by ID: $e');

      print('Stack trace: $stackTrace');

      return null;
    }
  }

  static Future<void> updateUserStatus(int userId, String status) async {
    try {
      final response = await http.post(
        Uri.parse('${AppLink.AdminLink}/users/update_status.php'),
        headers: headers,
        body: jsonEncode({
          'user_id': userId,
          'status': status,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] != 'success') {
          throw Exception(data['message'] ?? 'Failed to update user status');
        }
      } else {
        throw Exception('HTTP ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Services API

  static Future<List<ServiceModel>> getServices({String? status}) async {
    try {
      String url = '${AppLink.serviceDisplay}?lang=en';

      if (status?.isNotEmpty == true) url += '&status=$status';

      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 'success') {
          List<dynamic> servicesJson = data['data'];

          return servicesJson
              .map((json) => ServiceModel.fromJson(json))
              .toList();
        } else {
          return [];
        }
      } else {
        throw Exception('HTTP ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  static Future<void> deleteService(int serviceId) async {
    try {
      final response = await http.post(
        Uri.parse('${AppLink.linkServices}/delete.php'),
        headers: headers,
        body: jsonEncode({'service_id': serviceId}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] != 'success') {
          throw Exception(data['message'] ?? 'Failed to delete service');
        }
      } else {
        throw Exception('HTTP ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Orders API

  static Future<List<OrderModel>> getOrders({String? status}) async {
    try {
      String url = '${AppLink.detailsOrders}?lang=en';

      if (status?.isNotEmpty == true) url += '&status=$status';

      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 'success') {
          List<dynamic> ordersJson = data['data'];

          return ordersJson.map((json) => OrderModel.fromJson(json)).toList();
        } else {
          return [];
        }
      } else {
        throw Exception('HTTP ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  static Future<void> updateOrderStatus(int orderId, int status,
      {String? notes}) async {
    try {
      final response = await http.post(
        Uri.parse('${AppLink.ordersLink}/update_status.php'),
        headers: headers,
        body: jsonEncode({
          'order_id': orderId,
          'status': status,
          'notes': notes,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] != 'success') {
          throw Exception(data['message'] ?? 'Failed to update order status');
        }
      } else {
        throw Exception('HTTP ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Payments API

  static Future<List<PaymentModel>> getPayments({String? status}) async {
    try {
      String url = '${AppLink.processPayment}/view.php';

      if (status?.isNotEmpty == true) url += '?status=$status';

      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 'success') {
          List<dynamic> paymentsJson = data['data'];

          return paymentsJson
              .map((json) => PaymentModel.fromJson(json))
              .toList();
        } else {
          return [];
        }
      } else {
        throw Exception('HTTP ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Vehicles API

  static Future<List<VehicleModel>> getVehicles(
      {int? userId, int? makeId}) async {
    try {
      String url = '${AppLink.vehicleView}?lang=en';

      if (userId != null) url += '&user_id=$userId';

      if (makeId != null) url += '&make_id=$makeId';

      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 'success') {
          List<dynamic> vehiclesJson = data['data'];

          return vehiclesJson
              .map((json) => VehicleModel.fromJson(json))
              .toList();
        } else {
          return [];
        }
      } else {
        throw Exception('HTTP ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  static Future<void> deleteVehicle(int vehicleId) async {
    try {
      final response = await http.post(
        Uri.parse('${AppLink.vehicleRemove}'),
        headers: headers,
        body: jsonEncode({'vehicle_id': vehicleId}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] != 'success') {
          throw Exception(data['message'] ?? 'Failed to delete vehicle');
        }
      } else {
        throw Exception('HTTP ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Car Makes API

  static Future<List<CarMakeModel>> getCarMakes({String? search}) async {
    try {
      String url = '${AppLink.carsMakeDisplay}?lang=en';

      if (search?.isNotEmpty == true) url += '&search=$search';

      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 'success') {
          List<dynamic> makesJson = data['data'];

          return makesJson.map((json) => CarMakeModel.fromJson(json)).toList();
        } else {
          return [];
        }
      } else {
        throw Exception('HTTP ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Sub Services API

  static Future<List<SubServiceModel>> getSubServices({int? serviceId}) async {
    try {
      String url = '${AppLink.subserviceDisplay}?lang=en';

      if (serviceId != null) url += '&service_id=$serviceId';

      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 'success') {
          List<dynamic> subServicesJson = data['data'];

          return subServicesJson
              .map((json) => SubServiceModel.fromJson(json))
              .toList();
        } else {
          return [];
        }
      } else {
        throw Exception('HTTP ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Notifications API

  static Future<List<NotificationModel>> getNotifications(
      {int? userId, int? read}) async {
    try {
      String url = '${AppLink.notificationLink}/view.php?lang=en';

      if (userId != null) url += '&user_id=$userId';

      if (read != null) url += '&read=$read';

      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 'success') {
          List<dynamic> notificationsJson = data['data'];

          return notificationsJson
              .map((json) => NotificationModel.fromJson(json))
              .toList();
        } else {
          return [];
        }
      } else {
        throw Exception('HTTP ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  static Future<void> markNotificationRead(int notificationId) async {
    try {
      final response = await http.post(
        Uri.parse('${AppLink.markNotiRead}'),
        headers: headers,
        body: jsonEncode({'notification_id': notificationId}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] != 'success') {
          throw Exception(
              data['message'] ?? 'Failed to mark notification as read');
        }
      } else {
        throw Exception('HTTP ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  static Future<void> markAllNotificationsRead({int? userId}) async {
    try {
      final response = await http.post(
        Uri.parse('${AppLink.markAllNotiRead}'),
        headers: headers,
        body: jsonEncode({'user_id': userId}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] != 'success') {
          throw Exception(
              data['message'] ?? 'Failed to mark all notifications as read');
        }
      } else {
        throw Exception('HTTP ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  static Future<void> sendNotification(
      String title, String body, int userId) async {
    try {
      final response = await http.post(
        Uri.parse('${AppLink.notificatoin}'),
        headers: headers,
        body: jsonEncode({
          'title': title,
          'body': body,
          'user_id': userId,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] != 'success') {
          throw Exception(data['message'] ?? 'Failed to send notification');
        }
      } else {
        throw Exception('HTTP ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Settings API

  static Future<Map<String, dynamic>> getSettings() async {
    try {
      final response = await http.get(
        Uri.parse('${AppLink.AdminLink}/settings/view.php'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 'success') {
          return data['data'][0] ?? {};
        } else {
          return {};
        }
      } else {
        throw Exception('HTTP ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  static Future<void> updateSetting(String key, dynamic value) async {
    try {
      final response = await http.post(
        Uri.parse('${AppLink.AdminLink}/settings/update.php'),
        headers: headers,
        body: jsonEncode({
          'key': key,
          'value': value,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] != 'success') {
          throw Exception(data['message'] ?? 'Failed to update setting');
        }
      } else {
        throw Exception('HTTP ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Export API

  static Future<String> exportData(String dataType) async {
    try {
      final response = await http.get(
        Uri.parse('${AppLink.AdminLink}/export.php?type=$dataType'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('HTTP ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  static assignServiceToCar(int subServiceId, int makeId) {}
}
