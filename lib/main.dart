import 'package:ecom_modwir/const/translations/app_translations.dart';
import 'package:ecom_modwir/controllers/main_controller.dart';
import 'package:ecom_modwir/services/shared_preferences_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ecom_modwir/constants.dart';
import 'package:ecom_modwir/controllers/theme_controller.dart';
import 'package:ecom_modwir/controllers/language_controller.dart';
import 'package:ecom_modwir/controllers/dashboard_controller.dart';
import 'package:ecom_modwir/controllers/users_controller.dart';
import 'package:ecom_modwir/controllers/services_controller.dart';
import 'package:ecom_modwir/controllers/orders_controller.dart';
import 'package:ecom_modwir/controllers/notifications_controller.dart';
import 'package:ecom_modwir/controllers/vehicles_controller.dart';
import 'package:ecom_modwir/controllers/payments_controller.dart';
import 'package:ecom_modwir/services/websocket_service.dart';
import 'package:ecom_modwir/screens/main/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences
  await Get.putAsync(() => SharedPreferencesService().init());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Modwir Admin Panel',

      // Initialize controllers
      initialBinding: InitialBinding(),

      // Translations
      translations: AppTranslations(),
      locale: Get.find<LanguageController>().locale,
      fallbackLocale: const Locale('en'),

      // Theme management
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.grey[50],
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        canvasColor: Colors.white,
        cardColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 0,
        ),
        dataTableTheme: DataTableThemeData(
          headingRowColor: MaterialStateProperty.all(Colors.grey[100]),
          dataRowColor: MaterialStateProperty.all(Colors.white),
        ),
      ),

      darkTheme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: bgColor,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
            .apply(bodyColor: Colors.white),
        canvasColor: secondaryColor,
        cardColor: secondaryColor,
        appBarTheme: AppBarTheme(
          backgroundColor: secondaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        dataTableTheme: DataTableThemeData(
          headingRowColor: MaterialStateProperty.all(secondaryColor),
          dataRowColor: MaterialStateProperty.all(bgColor),
        ),
      ),

      themeMode: Get.find<ThemeController>().themeMode,

      home: MainScreen(),
    );
  }
}

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Initialize SharedPreferences service first
    Get.put(SharedPreferencesService(), permanent: true);

    // Core controllers with persistence
    Get.put(ThemeController(), permanent: true);
    Get.put(LanguageController(), permanent: true);
    Get.put(MainController(), permanent: true);

    // WebSocket service
    Get.put(WebSocketService(), permanent: true);

    // Feature controllers
    Get.lazyPut(() => DashboardController());
    Get.lazyPut(() => UsersController());
    Get.lazyPut(() => ServicesController());
    Get.lazyPut(() => OrdersController());
    Get.lazyPut(() => NotificationsController());
    Get.lazyPut(() => VehiclesController());
    Get.lazyPut(() => PaymentsController());
  }
}
