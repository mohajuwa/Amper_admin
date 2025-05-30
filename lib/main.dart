// main.dart (Refactored)

import "package:ecom_modwir/app/routes/app_pages.dart";
import "package:ecom_modwir/bindings.dart";
import "package:ecom_modwir/const/translations/app_translations.dart";
import "package:ecom_modwir/services/shared_preferences_service.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:ecom_modwir/controllers/theme_controller.dart";
import "package:ecom_modwir/controllers/language_controller.dart";
import "package:intl/date_symbol_data_local.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Init SharedPreferences Service first as others might depend on it
  await Get.putAsync(() => SharedPreferencesService().init(), permanent: true);
  await initializeDateFormatting(); // important for intl to work correctly

  // Run the app with GetMaterialApp
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // Access controllers that are put permanently in InitialBinding or main
  final ThemeController themeController =
      Get.put(ThemeController(), permanent: true);
  final LanguageController languageController =
      Get.put(LanguageController(), permanent: true);

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Use Obx for reactive updates to locale
    return Obx(() => GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Modwir Admin Panel", // Consider translating this if needed
          initialRoute: AppPages.INITIAL,
          getPages: AppPages.routes,
          initialBinding: InitialBinding(), // Centralized bindings
          translations: AppTranslations(), // Use the refactored translations
          locale: languageController.locale, // Reactive locale
          fallbackLocale: const Locale("ar"), // Default fallback
          theme: themeController.lightTheme, // Use theme from controller
          darkTheme: themeController.darkTheme, // Use theme from controller
          themeMode: themeController.themeMode, // Reactive theme mode
        ));
  }
}
