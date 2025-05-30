import 'package:ecom_modwir/screens/admin/admin_users_screen.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../controllers/main_controller.dart';

import '../../responsive.dart';

import '../dashboard/dashboard_screen.dart';

import '../customers/customers_screen.dart';

import '../services/services_screen.dart';

import '../sub_services/sub_services_screen.dart';

import '../orders/orders_screen.dart';

import '../payments/payments_screen.dart';

import 'components/side_menu.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mainController = Get.find<MainController>();

    return Scaffold(
      key: mainController.scaffoldKey,
      drawer: const SideMenu(),
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
              child: Obx(() =>
                  _getSelectedScreen(mainController.selectedMenuIndex.value)),
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
        return SubServicesScreen(); // Sub Services By Car (can be separate screen)

      case 6:
        return OrdersScreen();

      case 7:
        return PaymentsScreen();

      default:
        return DashboardScreen();
    }
  }
}
