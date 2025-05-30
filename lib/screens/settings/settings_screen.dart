import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../controllers/settings_controller.dart';

import '../../controllers/theme_controller.dart';

import '../../controllers/language_controller.dart';

import '../../constants.dart';

import '../dashboard/components/header.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final settingsController = Get.put(SettingsController());

    final themeController = Get.find<ThemeController>();

    final languageController = Get.find<LanguageController>();

    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            const Header(),

            const SizedBox(height: defaultPadding),

            Text(
              "settings".tr,
              style: Theme.of(context).textTheme.titleLarge,
            ),

            const SizedBox(height: defaultPadding),

            // Settings sections

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      // General Settings

                      _buildSettingsCard(context, "General Settings", [
                        _buildSettingTile(
                          "Dark Theme",
                          "Enable dark theme",
                          Obx(() => Switch(
                                value: themeController.isDarkMode.value,
                                onChanged: (_) => themeController.toggleTheme(),
                              )),
                        ),
                        _buildSettingTile(
                          "Language",
                          "Application language",
                          Obx(() => DropdownButton<String>(
                                value: languageController.currentLanguage.value,
                                items: [
                                  DropdownMenuItem(
                                      value: 'en', child: Text("English")),
                                  DropdownMenuItem(
                                      value: 'ar', child: Text("العربية")),
                                ],
                                onChanged: (value) =>
                                    languageController.changeLanguage(value!),
                              )),
                        ),
                      ]),

                      const SizedBox(height: defaultPadding),

                      // Data Management

                      _buildSettingsCard(context, "Data Management", [
                        _buildSettingTile(
                          "Export Users",
                          "Export user data to CSV",
                          ElevatedButton(
                            onPressed: () =>
                                settingsController.exportData('users'),
                            child: Text("Export"),
                          ),
                        ),
                        _buildSettingTile(
                          "Export Orders",
                          "Export order data to CSV",
                          ElevatedButton(
                            onPressed: () =>
                                settingsController.exportData('orders'),
                            child: Text("Export"),
                          ),
                        ),
                        _buildSettingTile(
                          "Export Payments",
                          "Export payment data to CSV",
                          ElevatedButton(
                            onPressed: () =>
                                settingsController.exportData('payments'),
                            child: Text("Export"),
                          ),
                        ),
                      ]),
                    ],
                  ),
                ),
                const SizedBox(width: defaultPadding),
                Expanded(
                  child: Column(
                    children: [
                      // System Settings

                      _buildSettingsCard(context, "System Settings", [
                        _buildSettingTile(
                          "Delivery Time",
                          "Default delivery time in hours",
                          SizedBox(
                            width: 100,
                            child: TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                suffixText: "hours",
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (value) =>
                                  settingsController.updateSetting(
                                      'delivery_time',
                                      int.tryParse(value) ?? 24),
                            ),
                          ),
                        ),
                        _buildSettingTile(
                          "Commission Rate",
                          "App commission percentage",
                          SizedBox(
                            width: 100,
                            child: TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                suffixText: "%",
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (value) =>
                                  settingsController.updateSetting(
                                      'commission_rate',
                                      double.tryParse(value) ?? 10.0),
                            ),
                          ),
                        ),
                      ]),

                      const SizedBox(height: defaultPadding),

                      // Notification Settings

                      _buildSettingsCard(context, "Notification Settings", [
                        _buildSettingTile(
                          "Email Notifications",
                          "Send email notifications",
                          Switch(
                            value: true,
                            onChanged: (value) => settingsController
                                .updateSetting('email_notifications', value),
                          ),
                        ),
                        _buildSettingTile(
                          "SMS Notifications",
                          "Send SMS notifications",
                          Switch(
                            value: false,
                            onChanged: (value) => settingsController
                                .updateSetting('sms_notifications', value),
                          ),
                        ),
                      ]),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsCard(
      BuildContext context, String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: defaultPadding),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSettingTile(String title, String subtitle, Widget trailing) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}
