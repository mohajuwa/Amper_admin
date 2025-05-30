import 'package:ecom_modwir/controllers/main_controller.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';

import '../../../controllers/theme_controller.dart';

import '../../../controllers/language_controller.dart';

import '../../../constants.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mainController = Get.find<MainController>();

    final themeController = Get.find<ThemeController>();

    final languageController = Get.find<LanguageController>();

    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Image.asset("assets/images/logo.png"),
          ),

          // Dashboard

          Obx(() => DrawerListTile(
                title: "dashboard".tr,
                svgSrc: "assets/icons/menu_dashboard.svg",
                isSelected: mainController.selectedMenuIndex.value == 0,
                press: () => mainController.selectMenu(0),
              )),

          // Admin Users

          Obx(() => DrawerListTile(
                title: "admin_users".tr,
                svgSrc: "assets/icons/menu_profile.svg",
                isSelected: mainController.selectedMenuIndex.value == 1,
                press: () => mainController.selectMenu(1),
              )),

          // Customers

          Obx(() => DrawerListTile(
                title: "customers".tr,
                svgSrc: "assets/icons/menu_tran.svg",
                isSelected: mainController.selectedMenuIndex.value == 2,
                press: () => mainController.selectMenu(2),
              )),

          // Services

          Obx(() => DrawerListTile(
                title: "services".tr,
                svgSrc: "assets/icons/menu_store.svg",
                isSelected: mainController.selectedMenuIndex.value == 3,
                press: () => mainController.selectMenu(3),
              )),

          // Sub Services

          Obx(() => DrawerListTile(
                title: "sub_services".tr,
                svgSrc: "assets/icons/menu_task.svg",
                isSelected: mainController.selectedMenuIndex.value == 4,
                press: () => mainController.selectMenu(4),
              )),

          // Sub Services By Car

          Obx(() => DrawerListTile(
                title: "sub_services_by_car".tr,
                svgSrc: "assets/icons/menu_doc.svg",
                isSelected: mainController.selectedMenuIndex.value == 5,
                press: () => mainController.selectMenu(5),
              )),

          // Orders

          Obx(() => DrawerListTile(
                title: "orders".tr,
                svgSrc: "assets/icons/menu_notification.svg",
                isSelected: mainController.selectedMenuIndex.value == 6,
                press: () => mainController.selectMenu(6),
              )),

          // Payments

          Obx(() => DrawerListTile(
                title: "payments".tr,
                svgSrc: "assets/icons/Documents.svg",
                isSelected: mainController.selectedMenuIndex.value == 7,
                press: () => mainController.selectMenu(7),
              )),

          const Divider(color: Colors.white24),

          // Change Theme

          DrawerListTile(
            title: "change_theme".tr,
            svgSrc: "assets/icons/menu_setting.svg",
            press: () => themeController.toggleTheme(),
          ),

          // Change Language

          DrawerListTile(
            title: "change_language".tr,
            svgSrc: "assets/icons/menu_setting.svg",
            press: () => _showLanguageDialog(),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog() {
    final languageController = Get.find<LanguageController>();

    Get.dialog(
      AlertDialog(
        title: Text("change_language".tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('English'),
              leading: Radio<String>(
                value: 'en',
                groupValue: languageController.currentLanguage.value,
                onChanged: (value) {
                  languageController.changeLanguage(value!);

                  Get.back();
                },
              ),
            ),
            ListTile(
              title: const Text('العربية'),
              leading: Radio<String>(
                value: 'ar',
                groupValue: languageController.currentLanguage.value,
                onChanged: (value) {
                  languageController.changeLanguage(value!);

                  Get.back();
                },
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text("cancel".tr),
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    required this.title,
    required this.svgSrc,
    required this.press,
    this.isSelected = false,
  }) : super(key: key);

  final String title, svgSrc;

  final VoidCallback press;

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: isSelected ? primaryColor.withOpacity(0.1) : null,
      ),
      child: ListTile(
        onTap: press,
        horizontalTitleGap: 0.0,
        leading: SvgPicture.asset(
          svgSrc,
          colorFilter: ColorFilter.mode(
              isSelected ? primaryColor : Colors.white54, BlendMode.srcIn),
          height: 16,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? primaryColor : Colors.white54,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
