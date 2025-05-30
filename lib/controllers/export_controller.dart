import 'dart:io';

import 'package:get/get.dart';

import 'package:path_provider/path_provider.dart';

import 'package:ecom_modwir/services/enhanced_api_service.dart';

import 'package:ecom_modwir/utils/app_utils.dart';

class ExportController extends GetxController {
  var isExporting = false.obs;

  var exportProgress = 0.0.obs;

  Future<void> exportData({
    required String dataType,
    String format = 'csv',
    Map<String, dynamic>? filters,
  }) async {
    try {
      isExporting.value = true;

      exportProgress.value = 0.0;

      AppUtils.showLoading(message: 'Preparing export...');

      // Simulate progress

      for (int i = 0; i <= 100; i += 10) {
        await Future.delayed(Duration(milliseconds: 100));

        exportProgress.value = i / 100;
      }

      final data = await EnhancedApiService.exportData(
        dataType,
        format: format,
        filters: filters,
      );

      AppUtils.hideLoading();

      // Save file locally

      await _saveExportedFile(data, dataType, format);

      AppUtils.showSuccess('Data exported successfully');
    } catch (e) {
      AppUtils.hideLoading();

      AppUtils.showError('Export failed: $e');
    } finally {
      isExporting.value = false;

      exportProgress.value = 0.0;
    }
  }

  Future<void> _saveExportedFile(
      String data, String dataType, String format) async {
    try {
      final directory = await getApplicationDocumentsDirectory();

      final timestamp = DateTime.now().millisecondsSinceEpoch;

      final fileName = '${dataType}_export_$timestamp.$format';

      final file = File('${directory.path}/$fileName');

      await file.writeAsString(data);
    } catch (e) {
      print('Error saving file: $e');
    }
  }

  List<String> get availableDataTypes => [
        'users',
        'orders',
        'payments',
        'services',
        'vehicles',
        'notifications',
      ];

  List<String> get availableFormats => [
        'csv',
        'json',
        'xlsx',
        'pdf',
      ];
}
