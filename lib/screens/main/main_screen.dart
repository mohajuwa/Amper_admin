import 'package:ecom_modwir/screens/admin/admin_users_screen.dart';
import 'package:ecom_modwir/screens/vehicles/vehicles_screen.dart';
import 'package:ecom_modwir/screens/notifications/notifications_screen.dart';
import 'package:ecom_modwir/screens/settings/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecom_modwir/controllers/main_controller.dart';
import 'package:ecom_modwir/responsive.dart';
import 'package:ecom_modwir/screens/dashboard/dashboard_screen.dart';
import 'package:ecom_modwir/screens/customers/customers_screen.dart';
import 'package:ecom_modwir/screens/services/services_screen.dart';
import 'package:ecom_modwir/screens/sub_services/sub_services_screen.dart';
import 'package:ecom_modwir/screens/sub_services_by_car/sub_services_by_car_screen.dart';
import 'package:ecom_modwir/screens/orders/orders_screen.dart';
import 'package:ecom_modwir/screens/payments/enhanced_payments_screen.dart';
import 'package:ecom_modwir/screens/main/components/side_menu.dart';
import 'package:ecom_modwir/constants.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mainController = Get.find<MainController>();

    return Scaffold(
      key: mainController.scaffoldKey,
      drawer: const SideMenu(),
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Desktop sidebar
            if (Responsive.isDesktop(context))
              const Expanded(child: SideMenu()),

            // Main content
            Expanded(
              flex: 5,
              child: Container(
                color: Get.theme.scaffoldBackgroundColor,
                child: Obx(() => AnimatedSwitcher(
                      duration: mediumDuration,
                      transitionBuilder: (child, animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0.1, 0),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          ),
                        );
                      },
                      child: _getSelectedScreen(
                          mainController.selectedMenuIndex.value),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getSelectedScreen(int index) {
    switch (index) {
      case 0:
        return DashboardScreen();
      case 1:
        return AdminUsersScreen();
      case 2:
        return CustomersScreen();
      case 3:
        return ServicesScreen();
      case 4:
        return SubServicesScreen();
      case 5:
        return SubServicesByCarScreen();
      case 6:
        return VehiclesScreen();
      case 7:
        return OrdersScreen();
      case 8:
        return EnhancedPaymentsScreen();
      case 9:
        return NotificationsScreen();
      case 10:
        return SettingsScreen();
      default:
        return DashboardScreen();
    }
  }
}
