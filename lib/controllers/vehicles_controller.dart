// lib/controllers/vehicles_controller.dart
import 'package:get/get.dart';
import 'package:ecom_modwir/modules/vehicle_model.dart';
import 'package:ecom_modwir/services/api_service.dart';

class VehiclesController extends GetxController {
  var isLoading = false.obs;
  var vehicles = <VehicleModel>[].obs;
  var filteredVehicles = <VehicleModel>[].obs;
  var searchQuery = ''.obs;
  var selectedMakeId = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadVehicles();
  }

  Future<void> loadVehicles() async {
    try {
      isLoading.value = true;
      final response = await ApiService.getVehicles();
      vehicles.value = response;
      filteredVehicles.value = response;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load vehicles: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void searchVehicles(String query) {
    searchQuery.value = query;
    _applyFilters();
  }

  void filterByMake(int makeId) {
    selectedMakeId.value = makeId;
    _applyFilters();
  }

  void _applyFilters() {
    var filtered = vehicles.toList();

    if (searchQuery.value.isNotEmpty) {
      filtered = filtered
          .where((vehicle) =>
              (vehicle.makeName
                      ?.toLowerCase()
                      .contains(searchQuery.value.toLowerCase()) ??
                  false) ||
              (vehicle.modelName
                      ?.toLowerCase()
                      .contains(searchQuery.value.toLowerCase()) ??
                  false))
          .toList();
    }

    if (selectedMakeId.value > 0) {
      filtered = filtered
          .where((vehicle) => vehicle.carMakeId == selectedMakeId.value)
          .toList();
    }

    filteredVehicles.value = filtered;
  }

  Future<void> deleteVehicle(int vehicleId) async {
    try {
      await ApiService.deleteVehicle(vehicleId);
      vehicles.removeWhere((vehicle) => vehicle.vehicleId == vehicleId);
      _applyFilters();
      Get.snackbar('Success', 'Vehicle deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete vehicle');
    }
  }
}
