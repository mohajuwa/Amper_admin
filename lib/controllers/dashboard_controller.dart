import 'package:get/get.dart';
import 'package:ecom_modwir/modules/dashboard_stats.dart';
import 'package:ecom_modwir/services/api_service.dart';

class DashboardController extends GetxController {
  var isLoading = false.obs;
  var dashboardStats = DashboardStats().obs;

  @override
  void onInit() {
    super.onInit();
    loadDashboardData();
  }

  Future<void> loadDashboardData() async {
    try {
      isLoading.value = true;
      // Simulate API call
      await Future.delayed(Duration(seconds: 1));

      dashboardStats.value = DashboardStats(
        totalUsers: 1250,
        totalOrders: 340,
        totalRevenue: 25000.0,
        pendingOrders: 15,
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to load dashboard data');
    } finally {
      isLoading.value = false;
    }
  }
}
