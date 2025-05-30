import 'package:ecom_modwir/controllers/main_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ecom_modwir/controllers/theme_controller.dart';
import 'package:ecom_modwir/controllers/language_controller.dart';
import 'package:ecom_modwir/constants.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mainController = Get.find<MainController>();
    final themeController = Get.find<ThemeController>();
    final languageController = Get.find<LanguageController>();

    return Container(
      decoration: BoxDecoration(
        color: Get.theme.drawerTheme.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: Drawer(
        backgroundColor: Colors.transparent,
        child: Column(
          children: [
            // Header with Logo and App Info
            _buildDrawerHeader(),

            // Navigation Items
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
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

                  // Vehicles
                  Obx(() => DrawerListTile(
                        title: "vehicles".tr,
                        svgSrc: "assets/icons/menu_notification.svg",
                        isSelected: mainController.selectedMenuIndex.value == 6,
                        press: () => mainController.selectMenu(6),
                      )),

                  // Orders
                  Obx(() => DrawerListTile(
                        title: "orders".tr,
                        svgSrc: "assets/icons/Documents.svg",
                        isSelected: mainController.selectedMenuIndex.value == 7,
                        press: () => mainController.selectMenu(7),
                      )),

                  // Payments
                  Obx(() => DrawerListTile(
                        title: "payments".tr,
                        svgSrc: "assets/icons/menu_setting.svg",
                        isSelected: mainController.selectedMenuIndex.value == 8,
                        press: () => mainController.selectMenu(8),
                      )),

                  // Notifications
                  Obx(() => DrawerListTile(
                        title: "notifications".tr,
                        svgSrc: "assets/icons/menu_notification.svg",
                        isSelected: mainController.selectedMenuIndex.value == 9,
                        press: () => mainController.selectMenu(9),
                      )),

                  const SizedBox(height: defaultPadding),

                  // Settings Section
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: defaultPadding),
                    child: Divider(
                      color: Get.theme.dividerColor,
                    ),
                  ),

                  const SizedBox(height: defaultPadding),

                  // Settings
                  Obx(() => DrawerListTile(
                        title: "settings".tr,
                        svgSrc: "assets/icons/menu_setting.svg",
                        isSelected:
                            mainController.selectedMenuIndex.value == 10,
                        press: () => mainController.selectMenu(10),
                      )),
                ],
              ),
            ),

            // Bottom Section with Theme and Language Controls
            _buildBottomSection(themeController, languageController),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(
          defaultPadding, 40, defaultPadding, defaultPadding),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primaryColor,
            primaryColor.withOpacity(0.8),
          ],
        ),
      ),
      child: Column(
        children: [
          // Logo
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                "assets/images/logo.png",
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.business,
                  color: primaryColor,
                  size: 30,
                ),
              ),
            ),
          ),

          const SizedBox(height: defaultPadding),

          // App Name
          Text(
            appName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          // Version
          Text(
            'v$appVersion',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSection(
      ThemeController themeController, LanguageController languageController) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Get.theme.dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Theme Toggle
          ListTile(
            dense: true,
            leading: Icon(
              Get.theme.brightness == Brightness.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
              color: Get.theme.iconTheme.color,
            ),
            title: Text(
              "change_theme".tr,
              style: TextStyle(
                color: Get.theme.textTheme.bodyMedium?.color,
              ),
            ),
            trailing: Obx(() => Switch(
                  value: themeController.isDarkMode.value,
                  onChanged: (_) => themeController.toggleTheme(),
                  activeColor: primaryColor,
                )),
            onTap: () => themeController.toggleTheme(),
          ),

          // Language Selection
          ListTile(
            dense: true,
            leading: Icon(
              Icons.language,
              color: Get.theme.iconTheme.color,
            ),
            title: Text(
              "change_language".tr,
              style: TextStyle(
                color: Get.theme.textTheme.bodyMedium?.color,
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Get.theme.iconTheme.color,
            ),
            onTap: () => _showLanguageDialog(languageController),
          ),

          const SizedBox(height: 8),

          // Logout Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _showLogoutDialog(),
              icon: const Icon(Icons.logout, size: 18),
              label: Text("logout".tr),
              style: ElevatedButton.styleFrom(
                backgroundColor: errorColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(LanguageController languageController) {
    Get.dialog(
      AlertDialog(
        title: Text("change_language".tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(() => RadioListTile<String>(
                  title: Row(
                    children: [
                      Image.asset(
                        'assets/images/flags/us.png',
                        width: 24,
                        height: 16,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.flag, size: 16),
                      ),
                      const SizedBox(width: 12),
                      const Text('English'),
                    ],
                  ),
                  value: 'en',
                  groupValue: languageController.currentLanguage.value,
                  onChanged: (value) {
                    languageController.changeLanguage(value!);
                    Get.back();
                  },
                  activeColor: primaryColor,
                )),
            Obx(() => RadioListTile<String>(
                  title: Row(
                    children: [
                      Image.asset(
                        'assets/images/flags/sa.png',
                        width: 24,
                        height: 16,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.flag, size: 16),
                      ),
                      const SizedBox(width: 12),
                      const Text('العربية'),
                    ],
                  ),
                  value: 'ar',
                  groupValue: languageController.currentLanguage.value,
                  onChanged: (value) {
                    languageController.changeLanguage(value!);
                    Get.back();
                  },
                  activeColor: primaryColor,
                )),
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

  void _showLogoutDialog() {
    Get.dialog(
      AlertDialog(
        title: Text("logout".tr),
        content: Text("are_you_sure_logout".tr),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text("cancel".tr),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              // Implement logout functionality
              Get.snackbar(
                "success".tr,
                "logged_out_successfully".tr,
                backgroundColor: successColor,
                colorText: Colors.white,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: errorColor,
            ),
            child: Text("logout".tr),
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
        color: isSelected ? primaryColor.withOpacity(0.1) : Colors.transparent,
        border: isSelected
            ? Border.all(color: primaryColor.withOpacity(0.3))
            : null,
      ),
      child: ListTile(
        onTap: press,
        dense: true,
        leading: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color:
                isSelected ? primaryColor.withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
          child: SvgPicture.asset(
            svgSrc,
            colorFilter: ColorFilter.mode(
              isSelected
                  ? primaryColor
                  : Get.theme.iconTheme.color ?? Colors.grey,
              BlendMode.srcIn,
            ),
            width: 18,
            height: 18,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected
                ? primaryColor
                : Get.theme.textTheme.bodyMedium?.color,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        trailing: isSelected
            ? Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              )
            : null,
      ),
    );
  }
}
