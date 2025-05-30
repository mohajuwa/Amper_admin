// lib/app/middleware/auth_middleware.dart
import 'package:ecom_modwir/modules/auth/controllers/auth_controller.dart';
import 'package:ecom_modwir/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthMiddleware extends GetMiddleware {
  // The priority enables us to define the order of middleware
  // Lower priority means it runs earlier
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    final authController = Get.find<AuthController>();

    print(
        "AuthMiddleware: Checking route: $route, isAuthenticated: ${authController.isAuthenticated.value}");

    // If the user is not authenticated and the route is not the login page,
    // redirect them to the login page.
    if (!authController.isAuthenticated.value && route != AppRoutes.LOGIN) {
      print("AuthMiddleware: Redirecting to LOGIN");
      return const RouteSettings(name: AppRoutes.LOGIN);
    }
    // If the user is authenticated and tries to access the login page,
    // redirect them to the dashboard (or home page).
    else if (authController.isAuthenticated.value && route == AppRoutes.LOGIN) {
      print("AuthMiddleware: Redirecting to DASHBOARD");
      return const RouteSettings(name: AppRoutes.DASHBOARD);
    }
    // Otherwise, allow access to the requested route.
    print("AuthMiddleware: Allowing access to $route");
    return null;
  }
}
