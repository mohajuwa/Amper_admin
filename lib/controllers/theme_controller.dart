// lib/controllers/theme_controller.dart

import 'package:get/get.dart';

import 'package:flutter/material.dart';

class ThemeController extends GetxController {
  var isDarkMode = true.obs;

  ThemeData get currentTheme => isDarkMode.value
      ? ThemeData.dark().copyWith(
          scaffoldBackgroundColor: const Color(0xFF212332),
          canvasColor: const Color(0xFF2A2D3E),
        )
      : ThemeData.light().copyWith(
          scaffoldBackgroundColor: Colors.grey[100],
          canvasColor: Colors.white,
        );

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;

    Get.changeTheme(currentTheme);
  }
}
