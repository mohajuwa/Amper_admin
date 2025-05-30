import 'package:get/get.dart';

import 'package:ecom_modwir/services/enhanced_api_service.dart';

class AdvancedAnalyticsController extends GetxController {
  var isLoading = false.obs;

  var revenueAnalysis = <String, dynamic>{}.obs;

  var userActivity = <String, dynamic>{}.obs;

  var servicePerformance = <String, dynamic>{}.obs;

  var conversionRates = <String, dynamic>{}.obs;

  var selectedDateRange = DateRange(
    start: DateTime.now().subtract(Duration(days: 30)),
    end: DateTime.now(),
  ).obs;

  Future<void> loadRevenueAnalysis() async {
    try {
      isLoading.value = true;

      final data = await EnhancedApiService.getAdvancedAnalytics(
        type: 'revenue_analysis',
        dateFrom: _formatDate(selectedDateRange.value.start),
        dateTo: _formatDate(selectedDateRange.value.end),
      );

      revenueAnalysis.value = data;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load revenue analysis: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadUserActivity() async {
    try {
      isLoading.value = true;

      final data = await EnhancedApiService.getAdvancedAnalytics(
        type: 'user_activity',
        dateFrom: _formatDate(selectedDateRange.value.start),
        dateTo: _formatDate(selectedDateRange.value.end),
      );

      userActivity.value = data;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load user activity: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadServicePerformance() async {
    try {
      isLoading.value = true;

      final data = await EnhancedApiService.getAdvancedAnalytics(
        type: 'service_performance',
        dateFrom: _formatDate(selectedDateRange.value.start),
        dateTo: _formatDate(selectedDateRange.value.end),
      );

      servicePerformance.value = data;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load service performance: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadConversionRates() async {
    try {
      isLoading.value = true;

      final data = await EnhancedApiService.getAdvancedAnalytics(
        type: 'conversion_rates',
        dateFrom: _formatDate(selectedDateRange.value.start),
        dateTo: _formatDate(selectedDateRange.value.end),
      );

      conversionRates.value = data;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load conversion rates: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void updateDateRange(DateRange newRange) {
    selectedDateRange.value = newRange;

    loadAllAnalytics();
  }

  Future<void> loadAllAnalytics() async {
    await Future.wait([
      loadRevenueAnalysis(),
      loadUserActivity(),
      loadServicePerformance(),
      loadConversionRates(),
    ]);
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
