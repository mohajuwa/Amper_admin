import 'package:get/get.dart';
import '../models/service_model.dart';
import '../services/api_service.dart';

class ServicesController extends GetxController {
  var isLoading = false.obs;
  var services = <ServiceModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadServices();
  }

  Future<void> loadServices() async {
    try {
      isLoading.value = true;
      final response = await ApiService.getServices();
      services.value = response;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load services');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteService(int serviceId) async {
    try {
      await ApiService.deleteService(serviceId);
      services.removeWhere((service) => service.serviceId == serviceId);
      Get.snackbar('Success', 'Service deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete service');
    }
  }
}
