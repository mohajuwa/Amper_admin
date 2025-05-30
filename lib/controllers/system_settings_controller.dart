import 'package:get/get.dart';
import 'package:ecom_modwir/models/system_settings_model.dart';
import 'package:ecom_modwir/services/enhanced_api_service.dart';

class SystemSettingsController extends GetxController {
  var isLoading = false.obs;
  var settings = SystemSettingsModel(
    appName: 'Modwir',
    appVersion: '1.0.0',
    currency: 'SAR',
    taxRate: 0.15,
    commissionRate: 0.10,
    defaultDeliveryTime: 24,
    maintenanceMode: false,
    supportInfo: {},
  ).obs;

  @override
  void onInit() {
    super.onInit();
    loadSettings();
  }

  Future<void> loadSettings() async {
    try {
      isLoading.value = true;

      final data = await EnhancedApiService.getSettings();
      settings.value = SystemSettingsModel.fromJson(data);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load settings: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateSetting(String key, dynamic value) async {
    try {
      await EnhancedApiService.updateSetting(key, value);

      // Create a new SystemSettingsModel with updated values
      final currentSettings = settings.value;
      SystemSettingsModel newSettings;

      switch (key) {
        case 'tax_rate':
          newSettings = SystemSettingsModel(
            appName: currentSettings.appName,
            appVersion: currentSettings.appVersion,
            currency: currentSettings.currency,
            taxRate:
                double.tryParse(value.toString()) ?? currentSettings.taxRate,
            commissionRate: currentSettings.commissionRate,
            defaultDeliveryTime: currentSettings.defaultDeliveryTime,
            maintenanceMode: currentSettings.maintenanceMode,
            supportInfo: currentSettings.supportInfo,
          );
          break;
        case 'commission_rate':
          newSettings = SystemSettingsModel(
            appName: currentSettings.appName,
            appVersion: currentSettings.appVersion,
            currency: currentSettings.currency,
            taxRate: currentSettings.taxRate,
            commissionRate: double.tryParse(value.toString()) ??
                currentSettings.commissionRate,
            defaultDeliveryTime: currentSettings.defaultDeliveryTime,
            maintenanceMode: currentSettings.maintenanceMode,
            supportInfo: currentSettings.supportInfo,
          );
          break;
        case 'default_delivery_time':
          newSettings = SystemSettingsModel(
            appName: currentSettings.appName,
            appVersion: currentSettings.appVersion,
            currency: currentSettings.currency,
            taxRate: currentSettings.taxRate,
            commissionRate: currentSettings.commissionRate,
            defaultDeliveryTime: int.tryParse(value.toString()) ??
                currentSettings.defaultDeliveryTime,
            maintenanceMode: currentSettings.maintenanceMode,
            supportInfo: currentSettings.supportInfo,
          );
          break;
        case 'maintenance_mode':
          newSettings = SystemSettingsModel(
            appName: currentSettings.appName,
            appVersion: currentSettings.appVersion,
            currency: currentSettings.currency,
            taxRate: currentSettings.taxRate,
            commissionRate: currentSettings.commissionRate,
            defaultDeliveryTime: currentSettings.defaultDeliveryTime,
            maintenanceMode:
                value is bool ? value : (currentSettings.maintenanceMode),
            supportInfo: currentSettings.supportInfo,
          );
          break;
        case 'app_name':
          newSettings = SystemSettingsModel(
            appName: value.toString(),
            appVersion: currentSettings.appVersion,
            currency: currentSettings.currency,
            taxRate: currentSettings.taxRate,
            commissionRate: currentSettings.commissionRate,
            defaultDeliveryTime: currentSettings.defaultDeliveryTime,
            maintenanceMode: currentSettings.maintenanceMode,
            supportInfo: currentSettings.supportInfo,
          );
          break;
        case 'currency':
          newSettings = SystemSettingsModel(
            appName: currentSettings.appName,
            appVersion: currentSettings.appVersion,
            currency: value.toString(),
            taxRate: currentSettings.taxRate,
            commissionRate: currentSettings.commissionRate,
            defaultDeliveryTime: currentSettings.defaultDeliveryTime,
            maintenanceMode: currentSettings.maintenanceMode,
            supportInfo: currentSettings.supportInfo,
          );
          break;
        default:
          // For unknown keys, don't update the model
          Get.snackbar('Success', 'Setting updated successfully');
          return;
      }

      // Update the observable with the new model
      settings.value = newSettings;

      Get.snackbar('Success', 'Setting updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update setting: $e');
    }
  }

  Future<void> toggleMaintenanceMode() async {
    await updateSetting('maintenance_mode', !settings.value.maintenanceMode);
  }

  // Helper method to update multiple settings at once
  Future<void> updateMultipleSettings(Map<String, dynamic> settingsMap) async {
    try {
      isLoading.value = true;

      // Update each setting via API
      for (final entry in settingsMap.entries) {
        await EnhancedApiService.updateSetting(entry.key, entry.value);
      }

      // Reload all settings to ensure consistency
      await loadSettings();

      Get.snackbar('Success', 'All settings updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update settings: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Helper method to reset settings to defaults
  Future<void> resetToDefaults() async {
    final defaultSettings = {
      'tax_rate': 0.15,
      'commission_rate': 0.10,
      'default_delivery_time': 24,
      'maintenance_mode': false,
    };

    await updateMultipleSettings(defaultSettings);
  }

  // Helper method to export settings
  Map<String, dynamic> exportSettings() {
    final currentSettings = settings.value;
    return {
      'app_name': currentSettings.appName,
      'app_version': currentSettings.appVersion,
      'currency': currentSettings.currency,
      'tax_rate': currentSettings.taxRate,
      'commission_rate': currentSettings.commissionRate,
      'default_delivery_time': currentSettings.defaultDeliveryTime,
      'maintenance_mode': currentSettings.maintenanceMode,
      'support_info': currentSettings.supportInfo,
      'exported_at': DateTime.now().toIso8601String(),
    };
  }

  // Validation helpers
  bool isValidTaxRate(double rate) => rate >= 0 && rate <= 1;
  bool isValidCommissionRate(double rate) => rate >= 0 && rate <= 1;
  bool isValidDeliveryTime(int hours) =>
      hours >= 1 && hours <= 168; // 1 hour to 7 days
}
