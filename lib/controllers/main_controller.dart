import 'package:get/get.dart';

import 'package:flutter/material.dart';

class MainController extends GetxController {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  var selectedMenuIndex = 0.obs;

  var isDrawerOpen = false.obs;

  void controlMenu() {
    if (!scaffoldKey.currentState!.isDrawerOpen) {
      scaffoldKey.currentState!.openDrawer();

      isDrawerOpen.value = true;
    }
  }

  void selectMenu(int index) {
    selectedMenuIndex.value = index;

    Get.back(); // Close drawer on mobile
  }

  void closeDrawer() {
    isDrawerOpen.value = false;
  }
}
