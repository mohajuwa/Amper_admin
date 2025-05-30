import 'package:ecom_modwir/utils/app_utils.dart';
import 'package:get/get.dart';

import '../services/api_service.dart';

class SettingsController extends GetxController {
  var isLoading = false.obs;

  var settings = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();

    loadSettings();
  }

  Future<void> loadSettings() async {
    try {
      isLoading.value = true;

      final response = await ApiService.getSettings();

      settings.value = response;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load settings');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateSetting(String key, dynamic value) async {
    try {
      await ApiService.updateSetting(key, value);

      settings[key] = value;

      Get.snackbar('Success', 'Setting updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update setting');
    }
  }

  Future<void> exportData(String dataType) async {
    try {
      AppUtils.showLoading();

      final data = await ApiService.exportData(dataType);

      AppUtils.hideLoading();

      // Handle file download or display

      Get.snackbar('Success', 'Data exported successfully');
    } catch (e) {
      AppUtils.hideLoading();

      Get.snackbar('Error', 'Failed to export data');
    }
  }
}
