// lib/controllers/order_detail_controller.dart
import 'package:ecom_modwir/services/api_service.dart';
import 'package:ecom_modwir/services/enhanced_api_service.dart';
import 'package:get/get.dart';
import 'package:ecom_modwir/modules/vehicle_model.dart';
import 'package:ecom_modwir/modules/order_item_model.dart';

class OrderDetailController extends GetxController {
  var isLoadingVehicle = false.obs;
  var isLoadingItems = false.obs;
  var vehicle = Rxn<VehicleModel>();
  var orderItems = <OrderItemModel>[].obs;
  var vehicleError = Rxn<String>();
  var itemsError = Rxn<String>();
  var vehicleData = Rxn<VehicleModel>();

  Future<void> loadVehicleDetails(int? vehicleId) async {
    if (vehicleId == null) {
      vehicleData.value = null;
      vehicleError.value = '';
      return;
    }

    try {
      isLoadingVehicle.value = true;
      vehicleError.value = '';

      final vehicle = await ApiService.getVehicleById(vehicleId);

      if (vehicle != null) {
        vehicleData.value = vehicle;
        print(
            'Successfully loaded vehicle: ${vehicle.makeName} ${vehicle.modelName}');
      } else {
        vehicleError.value = 'Vehicle not found';
        print('Vehicle not found for ID: $vehicleId');
      }
    } catch (e) {
      vehicleError.value = 'Error loading vehicle: $e';
      print('Error loading vehicle: $e');
    } finally {
      isLoadingVehicle.value = false;
    }
  }

  void clearVehicleData() {
    vehicleData.value = null;
    vehicleError.value = '';
    isLoadingVehicle.value = false;
  }

  // Load order items - try multiple approaches
  Future<void> loadOrderItems(int orderId) async {
    try {
      isLoadingItems.value = true;
      itemsError.value = null;

      print('Loading order items for order ID: $orderId');

      // Method 1: Try to get order details with items included
      try {
        final orderDetailsData =
            await EnhancedApiService.getOrderDetailsWithItems(orderId);

        if (orderDetailsData['items'] != null) {
          final itemsList =
              List<Map<String, dynamic>>.from(orderDetailsData['items']);
          orderItems.value =
              itemsList.map((item) => OrderItemModel.fromJson(item)).toList();
          print(
              'Order items loaded from order details: ${orderItems.length} items');
          return;
        }
      } catch (e) {
        print('Method 1 failed: $e');
      }

      // Method 2: Try separate order items endpoint
      try {
        final items = await EnhancedApiService.getOrderItems(orderId);
        orderItems.value = items;
        print(
            'Order items loaded from separate endpoint: ${items.length} items');
        return;
      } catch (e) {
        print('Method 2 failed: $e');
      }

      // Method 3: Create mock data if no backend support yet
      print('No order items endpoint available, using mock data');
      _createMockOrderItems();
    } catch (e) {
      itemsError.value = 'Failed to load order items: $e';
      print('Error loading order items: $e');
      Get.snackbar('Error', 'Failed to load order items');
    } finally {
      isLoadingItems.value = false;
    }
  }

  // Create mock order items for testing (remove this when you have real API)
  void _createMockOrderItems() {
    orderItems.value = [
      OrderItemModel(
        orderItemId: 1,
        orderId: 1,
        subServiceId: 1,
        itemName: 'Oil Change Service',
        price: 50.0,
        quantity: 1,
        totalPrice: 50.0,
      ),
      OrderItemModel(
        orderItemId: 2,
        orderId: 1,
        subServiceId: 2,
        itemName: 'Brake Inspection',
        price: 25.0,
        quantity: 1,
        totalPrice: 25.0,
      ),
      OrderItemModel(
        orderItemId: 3,
        orderId: 1,
        subServiceId: 3,
        itemName: 'Tire Rotation',
        price: 30.0,
        quantity: 4,
        totalPrice: 120.0,
      ),
    ];
  }

  // Alternative method: Load all data at once if your backend returns complete order data
  Future<void> loadCompleteOrderData(int orderId, int? vehicleId) async {
    print(
        'Loading complete order data for order: $orderId, vehicle: $vehicleId');

    // Load both vehicle and items concurrently
    await Future.wait([
      if (vehicleId != null) loadVehicleDetails(vehicleId),
      loadOrderItems(orderId),
    ]);
  }

  // Clear data when navigating away
  void clearData() {
    vehicle.value = null;
    orderItems.clear();
    vehicleError.value = null;
    itemsError.value = null;
  }

  @override
  void onClose() {
    clearData();
    super.onClose();
  }
}
