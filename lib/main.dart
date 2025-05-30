import 'package:ecom_modwir/bindings.dart';
import 'package:ecom_modwir/const/translations/app_translations.dart';
import 'package:ecom_modwir/controllers/main_controller.dart';
import 'package:ecom_modwir/services/shared_preferences_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ecom_modwir/constants.dart';
import 'package:ecom_modwir/controllers/theme_controller.dart';
import 'package:ecom_modwir/controllers/language_controller.dart';
import 'package:ecom_modwir/screens/main/main_screen.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Init SharedPreferences
  final sharedPrefsService = await SharedPreferencesService().init();
  Get.put(sharedPrefsService, permanent: true);
  await initializeDateFormatting(); // important for intl to work correctly

  // Init critical controllers manually BEFORE runApp
  Get.put(ThemeController(), permanent: true);
  Get.put(LanguageController(), permanent: true);
  Get.put(MainController(), permanent: true);

  // Now run the app
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<LanguageController>(
      builder: (languageController) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Modwir Admin Panel',
          initialBinding: InitialBinding(),
          translations: AppTranslations(),
          locale: languageController.locale,
          fallbackLocale: const Locale('ar'),
          theme: ThemeData.light().copyWith(
            scaffoldBackgroundColor: Colors.grey[50],
            textTheme:
                GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
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
      },
    );
  }
}
