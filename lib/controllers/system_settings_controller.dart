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

      // Update local settings
      switch (key) {
        case 'tax_rate':
          settings.update((val) {
            val?.taxRate = double.tryParse(value.toString()) ?? val.taxRate;
          });
          break;
        case 'commission_rate':
          settings.update((val) {
            val?.commissionRate =
                double.tryParse(value.toString()) ?? val.commissionRate;
          });
          break;
        case 'default_delivery_time':
          settings.update((val) {
            val?.defaultDeliveryTime =
                int.tryParse(value.toString()) ?? val.defaultDeliveryTime;
          });
          break;
        case 'maintenance_mode':
          settings.update((val) {
            val?.maintenanceMode =
                value is bool ? value : val?.maintenanceMode ?? false;
          });
          break;
      }

      Get.snackbar('Success', 'Setting updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update setting: $e');
    }
  }

  Future<void> toggleMaintenanceMode() async {
    await updateSetting('maintenance_mode', !settings.value.maintenanceMode);
  }
}
