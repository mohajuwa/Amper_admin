// lib/controllers/language_controller.dart

import 'package:get/get.dart';

import 'package:flutter/material.dart';

class LanguageController extends GetxController {
  var currentLanguage = 'en'.obs;

  var isRTL = false.obs;

  void changeLanguage(String langCode) {
    currentLanguage.value = langCode;

    isRTL.value = langCode == 'ar';

    Get.updateLocale(Locale(langCode));
  }

  Locale get locale => Locale(currentLanguage.value);
}
