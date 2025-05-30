import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:ecom_modwir/linkapi.dart';

import 'package:ecom_modwir/models/user_model.dart';

import 'package:ecom_modwir/models/service_model.dart';

import 'package:ecom_modwir/models/order_model.dart';

import 'package:ecom_modwir/models/payment_model.dart';

import 'package:ecom_modwir/models/dashboard_stats.dart';

import 'package:ecom_modwir/models/vehicle_model.dart';

import 'package:ecom_modwir/models/car_make_model.dart';

import 'package:ecom_modwir/models/sub_service_model.dart';

import 'package:ecom_modwir/models/notification_model.dart';

class ApiService {
  static const String baseUrl = AppLink.server;

  static Map<String, String> get headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

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
