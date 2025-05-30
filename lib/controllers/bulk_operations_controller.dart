import 'package:get/get.dart';

import '../services/enhanced_api_service.dart';

class BulkOperationsController extends GetxController {
  var isLoading = false.obs;

  var selectedItems = <int>[].obs;

  var operationType = ''.obs;

  Future<void> bulkUpdateUsers(List<int> userIds, String status) async {
    try {
      isLoading.value = true;

      final result = await EnhancedApiService.bulkOperation(
        action: 'bulk_update_users',
        data: {
          'user_ids': userIds.join(','),
          'status': status,
        },
      );

      Get.snackbar('Success', result['message']);

      selectedItems.clear();
    } catch (e) {
      Get.snackbar('Error', 'Bulk update failed: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> bulkUpdateOrders(List<int> orderIds, int status,
      {String? notes}) async {
    try {
      isLoading.value = true;

      final data = {
        'order_ids': orderIds.join(','),
        'order_status': status.toString(),
      };

      if (notes?.isNotEmpty == true) {
        data['notes'] = notes!;
      }

      final result = await EnhancedApiService.bulkOperation(
        action: 'bulk_update_orders',
        data: data,
      );

      Get.snackbar('Success', result['message']);

      selectedItems.clear();
    } catch (e) {
      Get.snackbar('Error', 'Bulk update failed: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> bulkUpdateServices(List<int> serviceIds, int status) async {
    try {
      isLoading.value = true;

      final result = await EnhancedApiService.bulkOperation(
        action: 'bulk_update_services',
        data: {
          'service_ids': serviceIds.join(','),
          'status': status.toString(),
        },
      );

      Get.snackbar('Success', result['message']);

      selectedItems.clear();
    } catch (e) {
      Get.snackbar('Error', 'Bulk update failed: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void toggleSelection(int id) {
    if (selectedItems.contains(id)) {
      selectedItems.remove(id);
    } else {
      selectedItems.add(id);
    }
  }

  void selectAll(List<int> allIds) {
    selectedItems.value = List.from(allIds);
  }

  void clearSelection() {
    selectedItems.clear();
  }
}
