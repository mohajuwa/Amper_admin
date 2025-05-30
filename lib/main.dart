import 'package:ecom_modwir/const/translations/app_translations.dart';
import 'package:ecom_modwir/controllers/main_controller.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';

import 'constants.dart';

import 'controllers/theme_controller.dart';

import 'controllers/language_controller.dart';

import 'controllers/dashboard_controller.dart';

import 'controllers/users_controller.dart';

import 'controllers/services_controller.dart';

import 'controllers/orders_controller.dart';

import 'screens/main/main_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Amper  Admin Panel',

      // Initialize controllers

      initialBinding: InitialBinding(),

      // Translations

      translations: AppTranslations(),

      locale: const Locale('en'),

      fallbackLocale: const Locale('en'),

      // Theme

      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.grey[100],
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        canvasColor: Colors.white,
      ),

      darkTheme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: bgColor,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
            .apply(bodyColor: Colors.white),
        canvasColor: secondaryColor,
      ),

      themeMode: ThemeMode.dark,

      home: MainScreen(),
    );
  }
}

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Core controllers

    Get.put(MainController(), permanent: true);

    Get.put(ThemeController(), permanent: true);

    Get.put(LanguageController(), permanent: true);

    // Feature controllers

    Get.lazyPut(() => DashboardController());

    Get.lazyPut(() => UsersController());

    Get.lazyPut(() => ServicesController());

    Get.lazyPut(() => OrdersController());
  }
}
