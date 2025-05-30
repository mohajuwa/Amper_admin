import 'package:get/get.dart';

import 'package:ecom_modwir/modules/order_model.dart';

import 'package:ecom_modwir/services/api_service.dart';

class OrdersController extends GetxController {
  var isLoading = false.obs;

  var orders = <OrderModel>[].obs;

  var filteredOrders = <OrderModel>[].obs;

  var selectedStatus = 'all'.obs;

  @override
  void onInit() {
    super.onInit();

    loadOrders();
  }

  Future<void> loadOrders() async {
    try {
      isLoading.value = true;

      final response = await ApiService.getOrders();

      orders.value = response;

      filteredOrders.value = response;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load orders');
    } finally {
      isLoading.value = false;
    }
  }

  void filterOrders(String status) {
    selectedStatus.value = status;

    if (status == 'all') {
      filteredOrders.value = orders;
    } else {
      filteredOrders.value = orders
          .where((order) => order.orderStatus.toString() == status)
          .toList();
    }
  }

  Future<void> updateOrderStatus(int orderId, int status) async {
    try {
      await ApiService.updateOrderStatus(orderId, status);

      await loadOrders();

      Get.snackbar('Success', 'Order status updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update order status');
    }
  }
}
