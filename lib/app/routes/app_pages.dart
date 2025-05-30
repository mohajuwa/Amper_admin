// lib/app/routes/app_pages.dart
import 'package:ecom_modwir/app/middleware/auth_middleware.dart';
import 'package:ecom_modwir/modules/auth/bindings/auth_binding.dart';
import 'package:ecom_modwir/modules/auth/screens/login_screen.dart';
import 'package:ecom_modwir/screens/dashboard/dashboard_screen.dart';
import 'package:ecom_modwir/screens/main/main_screen.dart';
import 'package:ecom_modwir/screens/orders/orders_screen.dart';
import 'package:ecom_modwir/screens/settings/settings_screen.dart';
import 'package:get/get.dart';

import 'app_routes.dart';

class AppPages {
  static const INITIAL =
      AppRoutes.DASHBOARD; // Or LOGIN if you want to force login check first

  static final routes = [
    // Public Route
    GetPage(
      name: AppRoutes.LOGIN,
      page: () => LoginScreen(),
      binding: AuthBinding(), // Bind AuthController for LoginScreen
      middlewares: [
        AuthMiddleware()
      ], // Middleware still needed to redirect if already logged in
    ),

    // Protected Routes (applied via middleware in MainScreen or similar shell)
    // A common pattern is to have a MainScreen act as a shell for authenticated routes
    GetPage(
      name: AppRoutes.DASHBOARD,
      page: () =>
          MainScreen(), // MainScreen will host the dashboard and other pages
      // Ensure MainScreen's controller and other dependencies are bound, perhaps in InitialBinding
      middlewares: [AuthMiddleware()], // Protects the main container
      // Children routes can be defined if MainScreen uses nested navigation
      children: [
        GetPage(
            name: AppRoutes.DASHBOARD_CONTENT, page: () => DashboardScreen()),
        GetPage(name: AppRoutes.ORDERS, page: () => OrdersScreen()),
        // ... other pages accessible from the side menu
      ],
    ),
    // Define other top-level protected routes if they don't use the MainScreen shell
    GetPage(
      name: AppRoutes.ORDERS,
      page: () => OrdersScreen(),
      middlewares: [AuthMiddleware()],
      // Add binding if needed
    ),
    GetPage(
      name: AppRoutes.SETTINGS,
      page: () => SettingsScreen(),
      middlewares: [AuthMiddleware()],
      // Add binding if needed
    ),
    // Add pages for all routes defined in AppRoutes
  ];
}
