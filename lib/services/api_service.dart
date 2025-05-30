// lib/services/api_service.dart
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
  static final String baseUrl = AppLink.server;
  static SharedPreferencesService get _prefs =>
      Get.find<SharedPreferencesService>();

  static Map<String, String> get headers => {
        'Content-Type': 'application/json; charset=utf-8',
        'Accept': 'application/json',
        'Accept-Language': Get.isRegistered<LanguageController>()
            ? Get.find<LanguageController>().currentLanguage.value
            : 'en',
      };

  static Map<String, String> get authHeaders {
    final token = _prefs.authToken;
    return {
      ...headers,
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static Future<Map<String, dynamic>> _makeRequest(
    String method,
    String url, {
    Map<String, dynamic>? body,
    bool requiresAuth = false,
    Duration? timeout,
  }) async {
    try {
      final uri = Uri.parse(url);
      final requestHeaders = requiresAuth ? authHeaders : headers;
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
    print('API Response [${response.statusCode}]: ${response.body}');

    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        final data = jsonDecode(response.body);
        if (data is Map<String, dynamic>) {
          return data;
        } else {
          return {'status': 'success', 'data': data};
        }
      } catch (e) {
        return {'status': 'success', 'data': response.body};
      }
    } else {
      String errorMessage =
          'Request failed with status: ${response.statusCode}';
      try {
        final errorData = jsonDecode(response.body);
        errorMessage = errorData['message'] ?? errorMessage;
      } catch (e) {
        // Use default error message
      }
      throw Exception(errorMessage);
    }
  }

  // Dashboard API
  static Future<DashboardStats> getDashboardStats() async {
    try {
      final response = await _makeRequest(
        'GET',
        '${AppLink.AdminLink}/dashboard.php?action=dashboard_stats',
      );

      if (response['status'] == 'success') {
        return DashboardStats.fromJson(response['data']);
      } else {
        // Return default stats if API fails
        return DashboardStats(
          totalUsers: 1250,
          totalOrders: 340,
          totalRevenue: 25000.0,
          pendingOrders: 15,
          completedOrders: 280,
          activeServices: 45,
        );
      }
    } catch (e) {
      print('Dashboard stats error: $e');
      // Return mock data for development
      return DashboardStats(
        totalUsers: 1250,
        totalOrders: 340,
        totalRevenue: 25000.0,
        pendingOrders: 15,
        completedOrders: 280,
        activeServices: 45,
      );
    }
  }

  // Users API
  static Future<List<UserModel>> getUsers(
      {String? search, String? status}) async {
    try {
      String url = '${AppLink.AdminLink}/users/view.php?lang=en';
      if (search?.isNotEmpty == true)
        url += '&search=${Uri.encodeComponent(search!)}';
      if (status?.isNotEmpty == true) url += '&status=$status';

      final response = await _makeRequest('GET', url);

      if (response['status'] == 'success') {
        List<dynamic> usersJson = response['data'] ?? [];
        return usersJson.map((json) => UserModel.fromJson(json)).toList();
      } else {
        return _getMockUsers();
      }
    } catch (e) {
      print('Users API error: $e');
      return _getMockUsers();
    }
  }

  static List<UserModel> _getMockUsers() {
    return [
      UserModel(
        userId: 1,
        fullName: 'Ahmed Ali',
        phone: '+966501234567',
        status: 'active',
        approve: 1,
        createdAt: DateTime.now().subtract(Duration(days: 30)),
        updatedAt: DateTime.now(),
      ),
      UserModel(
        userId: 2,
        fullName: 'Sara Mohamed',
        phone: '+966507654321',
        status: 'active',
        approve: 1,
        createdAt: DateTime.now().subtract(Duration(days: 15)),
        updatedAt: DateTime.now(),
      ),
    ];
  }

  static Future<void> updateUserStatus(int userId, String status) async {
    try {
      await _makeRequest(
        'POST',
        '${AppLink.AdminLink}/users/update_status.php',
        body: {'user_id': userId, 'status': status},
      );
    } catch (e) {
      throw Exception('Failed to update user status: $e');
    }
  }

  // Services API
  static Future<List<ServiceModel>> getServices({String? status}) async {
    try {
      String url = '${AppLink.serviceDisplay}?lang=en';
      if (status?.isNotEmpty == true) url += '&status=$status';

      final response = await _makeRequest('GET', url);

      if (response['status'] == 'success') {
        List<dynamic> servicesJson = response['data'] ?? [];
        return servicesJson.map((json) => ServiceModel.fromJson(json)).toList();
      } else {
        return _getMockServices();
      }
    } catch (e) {
      print('Services API error: $e');
      return _getMockServices();
    }
  }

  static List<ServiceModel> _getMockServices() {
    return [
      ServiceModel(
        serviceId: 1,
        serviceName: {'en': 'Oil Change', 'ar': 'تغيير الزيت'},
        serviceImg: null,
        status: 1,
        createdAt: DateTime.now().subtract(Duration(days: 100)),
        updatedAt: DateTime.now(),
      ),
      ServiceModel(
        serviceId: 2,
        serviceName: {'en': 'Brake Service', 'ar': 'خدمة الفرامل'},
        serviceImg: null,
        status: 1,
        createdAt: DateTime.now().subtract(Duration(days: 90)),
        updatedAt: DateTime.now(),
      ),
    ];
  }

  static Future<void> deleteService(int serviceId) async {
    try {
      await _makeRequest(
        'POST',
        '${AppLink.linkServices}/delete.php',
        body: {'service_id': serviceId},
      );
    } catch (e) {
      throw Exception('Failed to delete service: $e');
    }
  }

  // Orders API
  static Future<List<OrderModel>> getOrders({String? status}) async {
    try {
      String url = '${AppLink.detailsOrders}?lang=en';
      if (status?.isNotEmpty == true) url += '&status=$status';

      final response = await _makeRequest('GET', url);

      if (response['status'] == 'success') {
        List<dynamic> ordersJson = response['data'] ?? [];
        return ordersJson.map((json) => OrderModel.fromJson(json)).toList();
      } else {
        return _getMockOrders();
      }
    } catch (e) {
      print('Orders API error: $e');
      return _getMockOrders();
    }
  }

  static List<OrderModel> _getMockOrders() {
    return [
      OrderModel(
        orderId: 1,
        orderNumber: 1001,
        userId: 1,
        ordersAddress: 1,
        orderStatus: 1,
        orderType: 0,
        ordersPaymentmethod: 0,
        ordersPricedelivery: 20,
        orderDate: DateTime.now().subtract(Duration(hours: 2)),
        totalAmount: 150.0,
        paymentStatus: 'pending',
        userName: 'Ahmed Ali',
        vendorName: 'Quick Fix Auto',
        addressName: 'Riyadh, King Fahd Road',
      ),
      OrderModel(
        orderId: 2,
        orderNumber: 1002,
        userId: 2,
        ordersAddress: 2,
        orderStatus: 2,
        orderType: 1,
        ordersPaymentmethod: 1,
        ordersPricedelivery: 0,
        orderDate: DateTime.now().subtract(Duration(days: 1)),
        totalAmount: 280.0,
        paymentStatus: 'completed',
        userName: 'Sara Mohamed',
        vendorName: 'Auto Care Center',
        addressName: 'Jeddah, Tahlia Street',
      ),
    ];
  }

  static Future<void> updateOrderStatus(int orderId, int status,
      {String? notes}) async {
    try {
      await _makeRequest(
        'POST',
        '${AppLink.ordersLink}/update_status.php',
        body: {
          'order_id': orderId,
          'status': status,
          if (notes != null) 'notes': notes,
        },
      );
    } catch (e) {
      throw Exception('Failed to update order status: $e');
    }
  }

  // Vehicles API
  static Future<List<VehicleModel>> getVehicles(
      {int? userId, int? makeId}) async {
    try {
      String url = '${AppLink.vehicleView}?lang=en';
      if (userId != null) url += '&user_id=$userId';
      if (makeId != null) url += '&make_id=$makeId';

      final response = await _makeRequest('GET', url);

      if (response['status'] == 'success') {
        List<dynamic> vehiclesJson = response['data'] ?? [];
        return vehiclesJson.map((json) => VehicleModel.fromJson(json)).toList();
      } else {
        return _getMockVehicles();
      }
    } catch (e) {
      print('Vehicles API error: $e');
      return _getMockVehicles();
    }
  }

  static List<VehicleModel> _getMockVehicles() {
    return [
      VehicleModel(
        vehicleId: 1,
        userId: 1,
        carMakeId: 1,
        carModelId: 1,
        year: 2020,
        licensePlateNumber: {'en': 'ABC-1234', 'ar': 'أ ب ج ١٢٣٤'},
        status: 1,
        createdAt: DateTime.now().subtract(Duration(days: 60)),
        makeName: 'Toyota',
        modelName: 'Camry',
      ),
      VehicleModel(
        vehicleId: 2,
        userId: 2,
        carMakeId: 2,
        carModelId: 2,
        year: 2019,
        licensePlateNumber: {'en': 'XYZ-5678', 'ar': 'س ص ع ٥٦٧٨'},
        status: 1,
        createdAt: DateTime.now().subtract(Duration(days: 45)),
        makeName: 'Honda',
        modelName: 'Accord',
      ),
    ];
  }

  static Future<VehicleModel?> getVehicleById(int vehicleId) async {
    try {
      String url = '${AppLink.vehicleView}?lang=en&vehicle_id=$vehicleId';
      final response = await _makeRequest('GET', url);

      if (response['status'] == 'success') {
        List<dynamic> vehiclesJson = response['data'] ?? [];
        if (vehiclesJson.isNotEmpty) {
          return VehicleModel.fromJson(vehiclesJson.first);
        }
      }

      // Return mock vehicle for development
      return _getMockVehicles().firstWhere(
        (v) => v.vehicleId == vehicleId,
        orElse: () => _getMockVehicles().first,
      );
    } catch (e) {
      print('Vehicle by ID error: $e');
      return _getMockVehicles().first;
    }
  }

  static Future<void> deleteVehicle(int vehicleId) async {
    try {
      await _makeRequest(
        'POST',
        AppLink.vehicleRemove,
        body: {'vehicle_id': vehicleId},
      );
    } catch (e) {
      throw Exception('Failed to delete vehicle: $e');
    }
  }

  // Payments API
  static Future<List<PaymentModel>> getPayments({String? status}) async {
    try {
      String url = '${AppLink.processPayment}/view.php';
      if (status?.isNotEmpty == true) url += '?status=$status';

      final response = await _makeRequest('GET', url);

      if (response['status'] == 'success') {
        List<dynamic> paymentsJson = response['data'] ?? [];
        return paymentsJson.map((json) => PaymentModel.fromJson(json)).toList();
      } else {
        return _getMockPayments();
      }
    } catch (e) {
      print('Payments API error: $e');
      return _getMockPayments();
    }
  }

  static List<PaymentModel> _getMockPayments() {
    return [
      PaymentModel(
        paymentId: 1,
        orderId: 1,
        amount: 150.0,
        paymentMethod: 'card',
        paymentDate: DateTime.now().subtract(Duration(hours: 1)),
        paymentStatus: 'completed',
      ),
      PaymentModel(
        paymentId: 2,
        orderId: 2,
        amount: 280.0,
        paymentMethod: 'cash',
        paymentDate: DateTime.now().subtract(Duration(days: 1)),
        paymentStatus: 'pending',
      ),
    ];
  }

  // Notifications API
  static Future<List<NotificationModel>> getNotifications(
      {int? userId, int? read}) async {
    try {
      String url = '${AppLink.notificationLink}/view.php?lang=en';
      if (userId != null) url += '&user_id=$userId';
      if (read != null) url += '&read=$read';

      final response = await _makeRequest('GET', url);

      if (response['status'] == 'success') {
        List<dynamic> notificationsJson = response['data'] ?? [];
        return notificationsJson
            .map((json) => NotificationModel.fromJson(json))
            .toList();
      } else {
        return _getMockNotifications();
      }
    } catch (e) {
      print('Notifications API error: $e');
      return _getMockNotifications();
    }
  }

  static List<NotificationModel> _getMockNotifications() {
    return [
      NotificationModel(
        notificationId: 1,
        notificationOrderId: 1,
        notificationTitle: {'en': 'New Order', 'ar': 'طلب جديد'},
        notificationBody: {
          'en': 'You have a new order #1001',
          'ar': 'لديك طلب جديد رقم ١٠٠١'
        },
        notificationUserId: 0,
        notificationRead: 0,
        notificationDatetime: DateTime.now().subtract(Duration(minutes: 30)),
      ),
    ];
  }

  static Future<void> markNotificationRead(int notificationId) async {
    try {
      await _makeRequest(
        'POST',
        AppLink.markNotiRead,
        body: {'notification_id': notificationId},
      );
    } catch (e) {
      throw Exception('Failed to mark notification as read: $e');
    }
  }

  static Future<void> markAllNotificationsRead({int? userId}) async {
    try {
      await _makeRequest(
        'POST',
        AppLink.markAllNotiRead,
        body: {if (userId != null) 'user_id': userId},
      );
    } catch (e) {
      throw Exception('Failed to mark all notifications as read: $e');
    }
  }

  static Future<void> sendNotification(
      String title, String body, int userId) async {
    try {
      await _makeRequest(
        'POST',
        AppLink.notificatoin,
        body: {'title': title, 'body': body, 'user_id': userId},
      );
    } catch (e) {
      throw Exception('Failed to send notification: $e');
    }
  }

  // Car Makes API
  static Future<List<CarMakeModel>> getCarMakes({String? search}) async {
    try {
      String url = '${AppLink.carsMakeDisplay}?lang=en';
      if (search?.isNotEmpty == true)
        url += '&search=${Uri.encodeComponent(search!)}';

      final response = await _makeRequest('GET', url);

      if (response['status'] == 'success') {
        List<dynamic> makesJson = response['data'] ?? [];
        return makesJson.map((json) => CarMakeModel.fromJson(json)).toList();
      } else {
        return _getMockCarMakes();
      }
    } catch (e) {
      print('Car makes API error: $e');
      return _getMockCarMakes();
    }
  }

  static List<CarMakeModel> _getMockCarMakes() {
    return [
      CarMakeModel(
        makeId: 1,
        name: {'en': 'Toyota', 'ar': 'تويوتا'},
        popularity: 95,
        status: 1,
      ),
      CarMakeModel(
        makeId: 2,
        name: {'en': 'Honda', 'ar': 'هوندا'},
        popularity: 90,
        status: 1,
      ),
    ];
  }

  // Sub Services API
  static Future<List<SubServiceModel>> getSubServices({int? serviceId}) async {
    try {
      String url = '${AppLink.subserviceDisplay}?lang=en';
      if (serviceId != null) url += '&service_id=$serviceId';

      final response = await _makeRequest('GET', url);

      if (response['status'] == 'success') {
        List<dynamic> subServicesJson = response['data'] ?? [];
        return subServicesJson
            .map((json) => SubServiceModel.fromJson(json))
            .toList();
      } else {
        return _getMockSubServices();
      }
    } catch (e) {
      print('Sub services API error: $e');
      return _getMockSubServices();
    }
  }

  static List<SubServiceModel> _getMockSubServices() {
    return [
      SubServiceModel(
        subServiceId: 1,
        serviceId: 1,
        name: {'en': 'Engine Oil Change', 'ar': 'تغيير زيت المحرك'},
        price: 50.0,
        status: 1,
        createdAt: DateTime.now().subtract(Duration(days: 100)),
        updatedAt: DateTime.now(),
      ),
      SubServiceModel(
        subServiceId: 2,
        serviceId: 1,
        name: {'en': 'Oil Filter Replacement', 'ar': 'استبدال فلتر الزيت'},
        price: 25.0,
        status: 1,
        createdAt: DateTime.now().subtract(Duration(days: 100)),
        updatedAt: DateTime.now(),
      ),
    ];
  }

  // Settings API
  static Future<Map<String, dynamic>> getSettings() async {
    try {
      final response = await _makeRequest(
        'GET',
        '${AppLink.AdminLink}/settings/view.php',
      );

      if (response['status'] == 'success') {
        return response['data'] ?? {};
      } else {
        return _getMockSettings();
      }
    } catch (e) {
      print('Settings API error: $e');
      return _getMockSettings();
    }
  }

  static Map<String, dynamic> _getMockSettings() {
    return {
      'app_name': 'Modwir Admin Panel',
      'app_version': '1.0.0',
      'currency': 'SAR',
      'tax_rate': 0.15,
      'commission_rate': 0.10,
      'default_delivery_time': 24,
      'maintenance_mode': false,
    };
  }

  static Future<void> updateSetting(String key, dynamic value) async {
    try {
      await _makeRequest(
        'POST',
        '${AppLink.AdminLink}/settings/update.php',
        body: {'key': key, 'value': value},
      );
    } catch (e) {
      throw Exception('Failed to update setting: $e');
    }
  }

  // Export API
  static Future<Object> exportData(String dataType) async {
    try {
      final response = await _makeRequest(
        'GET',
        '${AppLink.AdminLink}/export.php?type=$dataType',
      );

      if (response is String) {
        return response;
      } else {
        return 'Export data for $dataType';
      }
    } catch (e) {
      throw Exception('Failed to export data: $e');
    }
  }

  // Helper method for service assignment
  static Future<void> assignServiceToCar(int subServiceId, int makeId) async {
    try {
      await _makeRequest(
        'POST',
        '${AppLink.linkServices}/assign_to_car.php',
        body: {'sub_service_id': subServiceId, 'make_id': makeId},
      );
    } catch (e) {
      throw Exception('Failed to assign service to car: $e');
    }
  }
}
