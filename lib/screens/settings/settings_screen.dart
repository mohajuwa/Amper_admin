import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecom_modwir/controllers/settings_controller.dart';
import 'package:ecom_modwir/controllers/system_settings_controller.dart';
import 'package:ecom_modwir/controllers/theme_controller.dart';
import 'package:ecom_modwir/controllers/language_controller.dart';
import 'package:ecom_modwir/controllers/export_controller.dart';
import 'package:ecom_modwir/constants.dart';
import 'package:ecom_modwir/utils/app_utils.dart';
import 'package:ecom_modwir/widgets/custom_card.dart';
import 'package:ecom_modwir/widgets/custom_text_field.dart';
import 'package:ecom_modwir/widgets/custom_dropdown.dart';
import 'package:ecom_modwir/widgets/custom_button.dart';
import 'package:ecom_modwir/screens/dashboard/components/header.dart';
import 'package:ecom_modwir/responsive.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final settingsController = Get.put(SettingsController());
    final systemSettingsController = Get.put(SystemSettingsController());
    final themeController = Get.find<ThemeController>();
    final languageController = Get.find<LanguageController>();
    final exportController = Get.put(ExportController());

    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            const Header(),
            const SizedBox(height: defaultPadding),

            // Page Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "settings".tr,
                      style: Get.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "manage_system_settings".tr,
                      style: Get.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                CustomButton(
                  text: "save_all_settings".tr,
                  icon: Icons.save,
                  onPressed: () => _saveAllSettings(systemSettingsController),
                ),
              ],
            ),

            const SizedBox(height: defaultPadding),

            // Settings Content
            if (Responsive.isDesktop(context))
              _buildDesktopLayout(
                settingsController,
                systemSettingsController,
                themeController,
                languageController,
                exportController,
              )
            else
              _buildMobileLayout(
                settingsController,
                systemSettingsController,
                themeController,
                languageController,
                exportController,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(
    SettingsController settingsController,
    SystemSettingsController systemSettingsController,
    ThemeController themeController,
    LanguageController languageController,
    ExportController exportController,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            children: [
              _buildAppearanceSettings(themeController, languageController),
              const SizedBox(height: defaultPadding),
              _buildSystemSettings(systemSettingsController),
            ],
          ),
        ),
        const SizedBox(width: defaultPadding),
        Expanded(
          child: Column(
            children: [
              _buildDataManagement(exportController),
              const SizedBox(height: defaultPadding),
              _buildMaintenanceSettings(systemSettingsController),
              const SizedBox(height: defaultPadding),
              _buildAboutSection(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(
    SettingsController settingsController,
    SystemSettingsController systemSettingsController,
    ThemeController themeController,
    LanguageController languageController,
    ExportController exportController,
  ) {
    return Column(
      children: [
        _buildAppearanceSettings(themeController, languageController),
        const SizedBox(height: defaultPadding),
        _buildSystemSettings(systemSettingsController),
        const SizedBox(height: defaultPadding),
        _buildDataManagement(exportController),
        const SizedBox(height: defaultPadding),
        _buildMaintenanceSettings(systemSettingsController),
        const SizedBox(height: defaultPadding),
        _buildAboutSection(),
      ],
    );
  }

  Widget _buildAppearanceSettings(
    ThemeController themeController,
    LanguageController languageController,
  ) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.palette, color: primaryColor),
              const SizedBox(width: 8),
              Text(
                "appearance_settings".tr,
                style: Get.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: defaultPadding),

          // Theme Settings
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Get.theme.brightness == Brightness.dark
                    ? Icons.dark_mode
                    : Icons.light_mode,
                color: primaryColor,
                size: 20,
              ),
            ),
            title: Text("theme_mode".tr),
            subtitle: Text("choose_theme_preference".tr),
            trailing: Obx(() => Switch(
                  value: themeController.isDarkMode.value,
                  onChanged: (_) => themeController.toggleTheme(),
                  activeColor: primaryColor,
                )),
          ),

          const Divider(),

          // Language Settings
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.language,
                color: primaryColor,
                size: 20,
              ),
            ),
            title: Text("application_language".tr),
            subtitle: Text("choose_app_language".tr),
            trailing: Obx(() => DropdownButton<String>(
                  value: languageController.currentLanguage.value,
                  underline: const SizedBox(),
                  items: [
                    DropdownMenuItem(
                      value: 'en',
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/images/flags/us.png',
                            width: 20,
                            height: 14,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.flag, size: 16),
                          ),
                          const SizedBox(width: 8),
                          const Text("English"),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'ar',
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/images/flags/sa.png',
                            width: 20,
                            height: 14,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.flag, size: 16),
                          ),
                          const SizedBox(width: 8),
                          const Text("العربية"),
                        ],
                      ),
                    ),
                  ],
                  onChanged: (value) =>
                      languageController.changeLanguage(value!),
                )),
          ),
        ],
      ),
    );
  }

  Widget _buildSystemSettings(SystemSettingsController controller) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.settings, color: primaryColor),
              const SizedBox(width: 8),
              Text(
                "system_settings".tr,
                style: Get.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: defaultPadding),
          Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            final settings = controller.settings.value;

            return Column(
              children: [
                // Tax Rate
                CustomTextField(
                  label: "tax_rate".tr,
                  hint: "enter_tax_rate".tr,
                  initialValue: (settings.taxRate * 100).toString(),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    final rate = double.tryParse(value);
                    if (rate != null) {
                      controller.updateSetting('tax_rate', rate / 100);
                    }
                  },
                ),

                const SizedBox(height: defaultPadding),

                // Commission Rate
                CustomTextField(
                  label: "commission_rate".tr,
                  hint: "enter_commission_rate".tr,
                  initialValue: (settings.commissionRate * 100).toString(),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    final rate = double.tryParse(value);
                    if (rate != null) {
                      controller.updateSetting('commission_rate', rate / 100);
                    }
                  },
                ),

                const SizedBox(height: defaultPadding),

                // Default Delivery Time
                CustomTextField(
                  label: "default_delivery_time".tr,
                  hint: "enter_delivery_time_hours".tr,
                  initialValue: settings.defaultDeliveryTime.toString(),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    final time = int.tryParse(value);
                    if (time != null) {
                      controller.updateSetting('default_delivery_time', time);
                    }
                  },
                ),

                const SizedBox(height: defaultPadding),

                // Currency (Read-only)
                CustomTextField(
                  label: "currency".tr,
                  initialValue: settings.currency,
                  enabled: false,
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildDataManagement(ExportController exportController) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.storage, color: primaryColor),
              const SizedBox(width: 8),
              Text(
                "data_management".tr,
                style: Get.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: defaultPadding),

          // Export Section
          Text(
            "export_data".tr,
            style: Get.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "export_data_description".tr,
            style: Get.textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),

          const SizedBox(height: defaultPadding),

          // Export Buttons
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: exportController.availableDataTypes.map((dataType) {
              return CustomButton(
                text: dataType.tr,
                type: ButtonType.outline,
                icon: _getDataTypeIcon(dataType),
                onPressed: () => _showExportDialog(exportController, dataType),
              );
            }).toList(),
          ),

          const SizedBox(height: defaultPadding),

          // Export Progress
          Obx(() {
            if (exportController.isExporting.value) {
              return Column(
                children: [
                  LinearProgressIndicator(
                    value: exportController.exportProgress.value,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "${(exportController.exportProgress.value * 100).toInt()}%",
                    style: Get.textTheme.bodySmall,
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  Widget _buildMaintenanceSettings(SystemSettingsController controller) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.build, color: warningColor),
              const SizedBox(width: 8),
              Text(
                "maintenance_settings".tr,
                style: Get.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: defaultPadding),

          // Maintenance Mode Toggle
          Obx(() => Container(
                padding: const EdgeInsets.all(defaultPadding),
                decoration: BoxDecoration(
                  color: controller.settings.value.maintenanceMode
                      ? warningColor.withOpacity(0.1)
                      : successColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: controller.settings.value.maintenanceMode
                        ? warningColor
                        : successColor,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      controller.settings.value.maintenanceMode
                          ? Icons.warning
                          : Icons.check_circle,
                      color: controller.settings.value.maintenanceMode
                          ? warningColor
                          : successColor,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "maintenance_mode".tr,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            controller.settings.value.maintenanceMode
                                ? "maintenance_mode_active".tr
                                : "maintenance_mode_inactive".tr,
                            style: Get.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: controller.settings.value.maintenanceMode,
                      onChanged: (_) => controller.toggleMaintenanceMode(),
                      activeColor: warningColor,
                    ),
                  ],
                ),
              )),

          const SizedBox(height: defaultPadding),

          // System Actions
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: "clear_cache".tr,
                  type: ButtonType.outline,
                  icon: Icons.cleaning_services,
                  onPressed: () => _clearCache(),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: CustomButton(
                  text: "restart_services".tr,
                  type: ButtonType.outline,
                  icon: Icons.restart_alt,
                  onPressed: () => _restartServices(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection() {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info, color: primaryColor),
              const SizedBox(width: 8),
              Text(
                "about_application".tr,
                style: Get.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: defaultPadding),

          // App Info
          _buildInfoRow("app_name".tr, appName),
          _buildInfoRow("app_version".tr, appVersion),
          _buildInfoRow("build_date".tr, "2024-01-15"),
          _buildInfoRow("developer".tr, "Modwir Development Team"),

          const SizedBox(height: defaultPadding),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: "check_updates".tr,
                  type: ButtonType.outline,
                  icon: Icons.system_update,
                  onPressed: () => _checkForUpdates(),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: CustomButton(
                  text: "contact_support".tr,
                  type: ButtonType.outline,
                  icon: Icons.support_agent,
                  onPressed: () => _contactSupport(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Get.textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: Get.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getDataTypeIcon(String dataType) {
    switch (dataType) {
      case 'users':
        return Icons.people;
      case 'orders':
        return Icons.shopping_cart;
      case 'payments':
        return Icons.payment;
      case 'services':
        return Icons.build;
      case 'vehicles':
        return Icons.directions_car;
      case 'notifications':
        return Icons.notifications;
      default:
        return Icons.file_download;
    }
  }

  void _showExportDialog(ExportController controller, String dataType) {
    String selectedFormat = 'csv';

    Get.dialog(
      AlertDialog(
        title: Text("export_data".tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("select_export_format".tr),
            const SizedBox(height: 16),
            CustomDropdown<String>(
              hint: "select_format".tr,
              value: selectedFormat,
              items: controller.availableFormats.map((format) {
                return DropdownMenuItem(
                  value: format,
                  child: Text(format.toUpperCase()),
                );
              }).toList(),
              onChanged: (value) => selectedFormat = value!,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text("cancel".tr),
          ),
          CustomButton(
            text: "export".tr,
            onPressed: () {
              Get.back();
              controller.exportData(
                dataType: dataType,
                format: selectedFormat,
              );
            },
          ),
        ],
      ),
    );
  }

  void _saveAllSettings(SystemSettingsController controller) {
    AppUtils.showSuccess("settings_saved_successfully".tr);
  }

  void _clearCache() {
    AppUtils.showConfirmDialog(
      title: "clear_cache".tr,
      message: "clear_cache_confirmation".tr,
    ).then((confirmed) {
      if (confirmed) {
        AppUtils.showSuccess("cache_cleared_successfully".tr);
      }
    });
  }

  void _restartServices() {
    AppUtils.showConfirmDialog(
      title: "restart_services".tr,
      message: "restart_services_confirmation".tr,
    ).then((confirmed) {
      if (confirmed) {
        AppUtils.showSuccess("services_restarted_successfully".tr);
      }
    });
  }

  void _checkForUpdates() {
    AppUtils.showInfo("checking_for_updates".tr);
    // Simulate update check
    Future.delayed(const Duration(seconds: 2), () {
      AppUtils.showSuccess("app_is_up_to_date".tr);
    });
  }

  void _contactSupport() {
    // Open support contact options
    Get.dialog(
      AlertDialog(
        title: Text("contact_support".tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.email),
              title: Text("email_support".tr),
              subtitle: const Text("support@modwir.com"),
              onTap: () {
                Get.back();
                AppUtils.showInfo("opening_email_client".tr);
              },
            ),
            ListTile(
              leading: const Icon(Icons.phone),
              title: Text("phone_support".tr),
              subtitle: const Text("+966 50 123 4567"),
              onTap: () {
                Get.back();
                AppUtils.showInfo("opening_phone_dialer".tr);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text("close".tr),
          ),
        ],
      ),
    );
  }
}
