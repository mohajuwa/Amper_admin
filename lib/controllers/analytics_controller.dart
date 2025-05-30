import 'package:get/get.dart';

import 'package:ecom_modwir/models/analytics_model.dart';

import 'package:ecom_modwir/services/enhanced_api_service.dart';

class AnalyticsController extends GetxController {
  var isLoading = false.obs;

  var analytics = AnalyticsModel(
    revenueData: {},
    userMetrics: {},
    orderMetrics: {},
    serviceMetrics: {},
  ).obs;

  var selectedDateRange = DateRange(
    start: DateTime.now().subtract(Duration(days: 30)),
    end: DateTime.now(),
  ).obs;

  @override
  void onInit() {
    super.onInit();

    loadAnalytics();
  }

  Future<void> loadAnalytics() async {
    try {
      isLoading.value = true;

      final data = await EnhancedApiService.getAdvancedAnalytics(
        type: 'comprehensive',
        dateFrom: _formatDate(selectedDateRange.value.start),
        dateTo: _formatDate(selectedDateRange.value.end),
      );

      analytics.value = AnalyticsModel.fromJson(data);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load analytics: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void updateDateRange(DateRange newRange) {
    selectedDateRange.value = newRange;

    loadAnalytics();
  }

  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }
}

class DateRange {
  final DateTime start;

  final DateTime end;

  DateRange({required this.start, required this.end});
}
