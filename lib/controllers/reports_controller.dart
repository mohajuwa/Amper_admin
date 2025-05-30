import 'package:ecom_modwir/controllers/advanced_analytics_controller.dart';
import 'package:ecom_modwir/services/enhanced_api_service.dart';
import 'package:get/get.dart';

class ReportsController extends GetxController {
  var isLoading = false.obs;

  var selectedReportType = 'financial_summary'.obs;

  var selectedDateRange = DateRange(
    start: DateTime.now().subtract(Duration(days: 30)),
    end: DateTime.now(),
  ).obs;

  var selectedFormat = 'json'.obs;

  var reportData = <String, dynamic>{}.obs;

  var availableReports = <String, String>{
    'financial_summary': 'Financial Summary',
    'customer_analysis': 'Customer Analysis',
    'service_performance': 'Service Performance',
    'operational_metrics': 'Operational Metrics',
    'geographic_analysis': 'Geographic Analysis',
    'cohort_analysis': 'Cohort Analysis',
    'predictive_analytics': 'Predictive Analytics',
  }.obs;

  Future<void> generateReport({
    String? reportType,
    DateRange? dateRange,
    String? format,
  }) async {
    try {
      isLoading.value = true;

      final type = reportType ?? selectedReportType.value;

      final range = dateRange ?? selectedDateRange.value;

      final outputFormat = format ?? selectedFormat.value;

      final response = await EnhancedApiService.getAdvancedAnalytics(
        type: type,
        dateFrom: _formatDate(range.start),
        dateTo: _formatDate(range.end),
      );

      reportData.value = response;

      if (outputFormat != 'json') {
        await _downloadReport(type, range, outputFormat);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to generate report: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _downloadReport(
      String type, DateRange range, String format) async {
    try {
      final url =
          '${EnhancedApiService.baseUrl}/admin/reports/advanced_reports.php';

      final params = {
        'type': type,
        'date_from': _formatDate(range.start),
        'date_to': _formatDate(range.end),
        'format': format,
        'api_key': 'admin_panel_key_2024',
      };

      // For mobile, you would use url_launcher or similar

      // For web, you can create a download link

      final downloadUrl = Uri.parse(url).replace(queryParameters: params);

      Get.snackbar(
        'Download Ready',
        'Report will be downloaded shortly',
        duration: Duration(seconds: 3),
      );

      // Implementation depends on platform

      // await launchUrl(downloadUrl);
    } catch (e) {
      Get.snackbar('Error', 'Failed to download report: $e');
    }
  }

  void updateReportType(String type) {
    selectedReportType.value = type;
  }

  void updateDateRange(DateRange range) {
    selectedDateRange.value = range;
  }

  void updateFormat(String format) {
    selectedFormat.value = format;
  }

  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }
}
