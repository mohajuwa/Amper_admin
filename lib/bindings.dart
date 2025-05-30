import 'package:ecom_modwir/controllers/analytics_controller.dart';
import 'package:ecom_modwir/controllers/export_controller.dart';
import 'package:ecom_modwir/controllers/reports_controller.dart';
import 'package:ecom_modwir/controllers/settings_controller.dart';
import 'package:ecom_modwir/controllers/system_settings_controller.dart';
import 'package:ecom_modwir/services/cache_service.dart';
import 'package:ecom_modwir/services/error_handler_service.dart';
import 'package:ecom_modwir/services/network_service.dart';
import 'package:get/get.dart';

import 'package:ecom_modwir/controllers/dashboard_controller.dart';
import 'package:ecom_modwir/controllers/users_controller.dart';
import 'package:ecom_modwir/controllers/services_controller.dart';
import 'package:ecom_modwir/controllers/orders_controller.dart';
import 'package:ecom_modwir/controllers/notifications_controller.dart';
import 'package:ecom_modwir/controllers/vehicles_controller.dart';
import 'package:ecom_modwir/controllers/payments_controller.dart';
import 'package:ecom_modwir/services/websocket_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Already initialized: ThemeController, LanguageController, MainController

    // Core services
    Get.put(WebSocketService(), permanent: true);
    Get.put(NetworkService(), permanent: true);
    Get.put(CacheService(), permanent: true);
    Get.put(ErrorHandlerService(), permanent: true);

    // Lazy feature controllers
    Get.lazyPut(() => DashboardController());
    Get.lazyPut(() => UsersController());
    Get.lazyPut(() => ServicesController());
    Get.lazyPut(() => OrdersController());
    Get.lazyPut(() => NotificationsController());
    Get.lazyPut(() => VehiclesController());
    Get.lazyPut(() => PaymentsController());
    Get.lazyPut(() => SettingsController());
    Get.lazyPut(() => SystemSettingsController());
    Get.lazyPut(() => ExportController());
    Get.lazyPut(() => ReportsController());
    Get.lazyPut(() => AnalyticsController());
  }
}
