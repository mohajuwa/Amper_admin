// lib/modules/auth/controllers/auth_controller.dart
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:ecom_modwir/services/api_service.dart'; // Assuming ApiService exists and is refactored
import 'package:ecom_modwir/services/shared_preferences_service.dart';
import 'package:ecom_modwir/app/routes/app_routes.dart'; // Will create this
import 'package:ecom_modwir/modules/admin_model.dart'; // Assuming AdminModel exists
import 'package:ecom_modwir/utils/app_utils.dart'; // For showSnackbar

class AuthController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  final SharedPreferencesService _prefsService =
      Get.find<SharedPreferencesService>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  var isLoading = false.obs;
  var isAuthenticated = false.obs;
  var authToken = RxnString();
  var currentAdmin = Rxn<AdminModel>(); // Assuming AdminModel exists

  @override
  void onInit() {
    super.onInit();
    _loadAuthData();
  }

  void _loadAuthData() {
    authToken.value = _prefsService.getToken();
    // Potentially load user data if stored
    // final storedUserData = _prefsService.getUserData();
    // if (storedUserData != null) {
    //   currentAdmin.value = AdminModel.fromJson(storedUserData);
    // }
    isAuthenticated.value = authToken.value != null;
    print(
        "Auth state loaded: isAuthenticated = ${isAuthenticated.value}, token = ${authToken.value}");
  }

  Future<void> login() async {
    if (!loginFormKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;
    try {
      final response = await _apiService.post(
        '/admin/auth/login.php', // Verify this endpoint from PHP structure
        {
          'email': emailController.text,
          'password': passwordController.text,
        },
      );

      if (response['status'] == 'success' && response['data'] != null) {
        // Assuming API returns token and admin data
        final token = response['data']['token']
            as String?; // Adjust key based on actual API response
        final adminData =
            response['data']['admin'] as Map<String, dynamic>?; // Adjust key

        if (token != null) {
          await _prefsService.saveToken(token);
          authToken.value = token;
          isAuthenticated.value = true;

          if (adminData != null) {
            currentAdmin.value = AdminModel.fromJson(adminData);
            // Optionally save admin data to prefs
            // await _prefsService.saveUserData(adminData);
          }
          AppUtils.showSuccess('login_successful'.tr);

          Get.offAllNamed(AppRoutes.DASHBOARD); // Navigate to dashboard
        } else {
          throw Exception('login_failed_no_token'.tr);
        }
      } else {
        throw Exception(response['message'] ?? 'login_failed'.tr);
      }
    } catch (e) {
      print("Login Error: $e");
      AppUtils.showError(e.toString());

      isAuthenticated.value = false;
      authToken.value = null;
      currentAdmin.value = null;
    } finally {
      isLoading.value = false;
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

  Future<void> logout() async {
    // Optional: Call a logout endpoint on the backend if it exists
    // try {
    //   await _apiService.post('/admin/auth/logout.php', {});
    // } catch (e) {
    //   print("Logout API Error: $e");
    //   // Decide if logout should proceed even if API call fails
    // }

    await _prefsService.clearAuthData();
    authToken.value = null;
    currentAdmin.value = null;
    isAuthenticated.value = false;
    emailController.clear();
    passwordController.clear();
    AppUtils.showInfo('logged_out_successfully'.tr);

    Get.offAllNamed(AppRoutes.LOGIN); // Redirect to login screen
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
