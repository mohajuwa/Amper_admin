import 'package:get/get.dart';

import 'package:ecom_modwir/models/sub_service_model.dart';

import 'package:ecom_modwir/models/car_make_model.dart';

import 'package:ecom_modwir/services/api_service.dart';

class SubServicesByCarController extends GetxController {
  var isLoading = false.obs;

  var subServices = <SubServiceModel>[].obs;

  var carMakes = <CarMakeModel>[].obs;

  var selectedMakeId = 0.obs;

  var filteredSubServices = <SubServiceModel>[].obs;

  @override
  void onInit() {
    super.onInit();

    loadData();
  }

  Future<void> loadData() async {
    try {
      isLoading.value = true;

      await Future.wait([
        loadSubServices(),
        loadCarMakes(),
      ]);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load data');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadSubServices() async {
    // Load sub services from API

    final response = await ApiService.getSubServices();

    subServices.value = response;

    filteredSubServices.value = response;
  }

  Future<void> loadCarMakes() async {
    // Load car makes from API

    final response = await ApiService.getCarMakes();

    carMakes.value = response;
  }

  void filterByCarMake(int makeId) {
    selectedMakeId.value = makeId;

    if (makeId == 0) {
      filteredSubServices.value = subServices;
    } else {
      // Filter sub services by car make

      // This would typically involve API call with car make filter

      filteredSubServices.value = subServices.where((service) {
        // Implement filtering logic based on car make

        return true; // Placeholder
      }).toList();
    }
  }

  Future<void> assignServiceToCar(int subServiceId, int makeId) async {
    try {
      await ApiService.assignServiceToCar(subServiceId, makeId);

      Get.snackbar('Success', 'Service assigned to car successfully');

      loadData(); // Refresh data
    } catch (e) {
      Get.snackbar('Error', 'Failed to assign service to car');
    }
  }
}
