import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ecom_modwir/constants.dart';
import 'package:ecom_modwir/services/shared_preferences_service.dart';

class ThemeController extends GetxController {
  final _prefs = SharedPreferencesService.to;

  var isDarkMode = true.obs;

  @override
  void onInit() {
    super.onInit();
    // Load saved theme preference
    isDarkMode.value = _prefs.isDarkMode;
  }

  ThemeMode get themeMode =>
      isDarkMode.value ? ThemeMode.dark : ThemeMode.light;

  ThemeData get lightTheme => ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.grey[50],
        textTheme: GoogleFonts.poppinsTextTheme().apply(
          bodyColor: Colors.black87,
          displayColor: Colors.black87,
        ),
        canvasColor: Colors.white,
        cardColor: Colors.white,
        primaryColor: primaryColor,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 0,
          titleTextStyle: GoogleFonts.poppins(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        drawerTheme: DrawerThemeData(
          backgroundColor: Colors.white,
          scrimColor: Colors.black26,
        ),
        dataTableTheme: DataTableThemeData(
          headingRowColor: MaterialStateProperty.all(Colors.grey[100]),
          dataRowColor: MaterialStateProperty.all(Colors.white),
          dividerThickness: 1,
          headingTextStyle: GoogleFonts.poppins(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
          dataTextStyle: GoogleFonts.poppins(
            color: Colors.black87,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: primaryColor,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        listTileTheme: ListTileThemeData(
          textColor: Colors.black87,
          iconColor: Colors.black54,
        ),
        iconTheme: IconThemeData(
          color: Colors.black54,
        ),
        dividerColor: Colors.grey[300],
      );

  ThemeData get darkTheme => ThemeData.dark().copyWith(
        scaffoldBackgroundColor: bgColor,
        textTheme: GoogleFonts.poppinsTextTheme().apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
        canvasColor: secondaryColor,
        cardColor: secondaryColor,
        primaryColor: primaryColor,
        appBarTheme: AppBarTheme(
          backgroundColor: secondaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          titleTextStyle: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        drawerTheme: DrawerThemeData(
          backgroundColor: secondaryColor,
          scrimColor: Colors.black54,
        ),
        dataTableTheme: DataTableThemeData(
          headingRowColor: MaterialStateProperty.all(secondaryColor),
          dataRowColor: MaterialStateProperty.all(bgColor),
          dividerThickness: 1,
          headingTextStyle: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
          dataTextStyle: GoogleFonts.poppins(
            color: Colors.white,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: primaryColor,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          fillColor: bgColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        listTileTheme: ListTileThemeData(
          textColor: Colors.white,
          iconColor: Colors.white70,
        ),
        iconTheme: IconThemeData(
          color: Colors.white70,
        ),
        dividerColor: Colors.white24,
      );

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    _prefs.setThemeMode(isDarkMode.value);
    Get.changeThemeMode(themeMode);
  }

  void setLightTheme() {
    isDarkMode.value = false;
    _prefs.setThemeMode(false);
    Get.changeThemeMode(ThemeMode.light);
  }

  void setDarkTheme() {
    isDarkMode.value = true;
    _prefs.setThemeMode(true);
    Get.changeThemeMode(ThemeMode.dark);
  }
}
