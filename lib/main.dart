// lib/main.dart
import 'package:ecom_modwir/app/routes/app_pages.dart';
import 'package:ecom_modwir/bindings.dart';
import 'package:ecom_modwir/const/translations/app_translations.dart';
import 'package:ecom_modwir/services/shared_preferences_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecom_modwir/controllers/theme_controller.dart';
import 'package:ecom_modwir/controllers/language_controller.dart';
import 'package:ecom_modwir/controllers/main_controller.dart';
import 'package:ecom_modwir/modules/auth/controllers/auth_controller.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize SharedPreferences Service first
    await Get.putAsync(() => SharedPreferencesService().init(),
        permanent: true);

    // Initialize date formatting
    await initializeDateFormatting();

    // Initialize core controllers
    Get.put(LanguageController(), permanent: true);
    Get.put(ThemeController(), permanent: true);
    Get.put(MainController(), permanent: true);
    Get.put(AuthController(), permanent: true);

    print('App initialization completed successfully');
  } catch (e) {
    print('Error during app initialization: $e');
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ThemeController themeController = Get.find<ThemeController>();
  final LanguageController languageController = Get.find<LanguageController>();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Modwir Admin Panel",
          initialRoute: AppPages.INITIAL,
          getPages: AppPages.routes,
          initialBinding: InitialBinding(),
          translations: AppTranslations(),
          locale: languageController.locale,
          fallbackLocale: const Locale("en"),
          theme: themeController.lightTheme,
          darkTheme: themeController.darkTheme,
          themeMode: themeController.themeMode,
          // Add error handling
          builder: (context, widget) {
            return widget ?? const SizedBox();
          },
          // Handle unknown routes
          unknownRoute: GetPage(
            name: '/notfound',
            page: () => const Scaffold(
              body: Center(
                child: Text('Page not found'),
              ),
            ),
          ),
        ));
  }
}
