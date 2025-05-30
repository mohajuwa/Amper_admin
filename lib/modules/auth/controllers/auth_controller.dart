// lib/modules/auth/controllers/auth_controller.dart
import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ecom_modwir/services/shared_preferences_service.dart';
import 'package:ecom_modwir/app/routes/app_routes.dart';
import 'package:ecom_modwir/modules/admin_model.dart';
import 'package:ecom_modwir/utils/app_utils.dart';
import 'package:ecom_modwir/linkapi.dart';

class AuthController extends GetxController {
  final SharedPreferencesService _prefsService =
      Get.find<SharedPreferencesService>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  var isLoading = false.obs;
  var isAuthenticated = false.obs;
  var authToken = RxnString();
  var currentAdmin = Rxn<AdminModel>();

  @override
  void onInit() {
    super.onInit();
    _loadAuthData();
  }

  void _loadAuthData() {
    authToken.value = _prefsService.getToken();
    final storedUserData = _prefsService.getUserData();
    if (storedUserData != null) {
      try {
        currentAdmin.value = AdminModel.fromJson(storedUserData);
      } catch (e) {
        print('Error parsing stored user data: $e');
      }
    }
    isAuthenticated.value = authToken.value != null;
    print(
        "Auth state loaded: isAuthenticated = ${isAuthenticated.value}, token = ${authToken.value != null ? 'exists' : 'null'}");
  }

  Future<void> login() async {
    if (!loginFormKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;
    try {
      final response = await _makeLoginRequest(
        emailController.text.trim(),
        passwordController.text,
      );

      if (response['status'] == 'success' && response['data'] != null) {
        final token = response['data']['token'] as String?;
        final adminData = response['data']['admin'] as Map<String, dynamic>?;

        if (token != null) {
          await _prefsService.saveToken(token);
          authToken.value = token;
          isAuthenticated.value = true;

          if (adminData != null) {
            currentAdmin.value = AdminModel.fromJson(adminData);
            await _prefsService.saveUserData(adminData);
          }

          AppUtils.showSuccess('Login successful');
          Get.offAllNamed(AppRoutes.DASHBOARD);
        } else {
          throw Exception('Login failed: No token received');
        }
      } else {
        throw Exception(response['message'] ?? 'Login failed');
      }
    } catch (e) {
      print("Login Error: $e");
      AppUtils.showError('Login failed: ${e.toString()}');
      isAuthenticated.value = false;
      authToken.value = null;
      currentAdmin.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<Map<String, dynamic>> _makeLoginRequest(
      String email, String password) async {
    try {
      final uri = Uri.parse('${AppLink.AdminLink}/auth/login.php');

      final response = await http
          .post(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({
              'email': email,
              'password': password,
            }),
          )
          .timeout(const Duration(seconds: 30));

      print('Login Response Status: ${response.statusCode}');
      print('Login Response Body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          final data = jsonDecode(response.body);
          return data;
        } catch (e) {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception(
            'HTTP ${response.statusCode}: ${response.reasonPhrase}');
      }
    } catch (e) {
      if (e.toString().contains('SocketException') ||
          e.toString().contains('TimeoutException')) {
        throw Exception('Network error: Please check your connection');
      }
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      // Optional: Call logout endpoint
      await _makeLogoutRequest();
    } catch (e) {
      print("Logout API Error: $e");
      // Continue with local logout even if API fails
    }

    await _prefsService.clearAuthData();
    authToken.value = null;
    currentAdmin.value = null;
    isAuthenticated.value = false;
    emailController.clear();
    passwordController.clear();

    AppUtils.showInfo('Logged out successfully');
    Get.offAllNamed(AppRoutes.LOGIN);
  }

  Future<void> _makeLogoutRequest() async {
    if (authToken.value == null) return;

    try {
      final uri = Uri.parse('${AppLink.AdminLink}/auth/logout.php');

      await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${authToken.value}',
        },
      ).timeout(const Duration(seconds: 10));
    } catch (e) {
      print('Logout request failed: $e');
      // Don't throw error - logout should proceed anyway
    }
  }

  // Check if user is authenticated
  bool get authenticated => isAuthenticated.value && authToken.value != null;

  // Get current user name
  String get currentUserName => currentAdmin.value?.fullName ?? 'Admin User';

  // Get current user email
  String get currentUserEmail => currentAdmin.value?.email ?? '';

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
