import 'package:get/get.dart';

import '../services/enhanced_api_service.dart';

class DeveloperToolsController extends GetxController {
  var selectedTool = ''.obs;

  var isLoading = false.obs;

  var systemHealth = <String, dynamic>{}.obs;

  var performanceMetrics = <String, dynamic>{}.obs;

  var errorLogs = <Map<String, dynamic>>[].obs;

  var cacheStatus = <String, dynamic>{}.obs;

  var databaseStatus = <String, dynamic>{}.obs;

  void showSystemHealth() async {
    selectedTool.value = 'system_health';

    await loadSystemHealth();
  }

  void showAPIDebugger() {
    selectedTool.value = 'api_debugger';
  }

  void showPerformanceMonitor() async {
    selectedTool.value = 'performance_monitor';

    await loadPerformanceMetrics();
  }

  void showErrorLogs() async {
    selectedTool.value = 'error_logs';

    await loadErrorLogs();
  }

  void showCacheManager() async {
    selectedTool.value = 'cache_manager';

    await loadCacheStatus();
  }

  void showDatabaseStatus() async {
    selectedTool.value = 'database_status';

    await loadDatabaseStatus();
  }

  Future<void> loadSystemHealth() async {
    try {
      isLoading.value = true;

      final response =
          await EnhancedApiService.getSystemMonitorData('health_check');

      systemHealth.value = response;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load system health: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadPerformanceMetrics() async {
    try {
      isLoading.value = true;

      final response =
          await EnhancedApiService.getSystemMonitorData('performance_metrics');

      performanceMetrics.value = response;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load performance metrics: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadErrorLogs() async {
    try {
      isLoading.value = true;

      final response =
          await EnhancedApiService.getSystemMonitorData('error_logs');

      errorLogs.value = List<Map<String, dynamic>>.from(response['data'] ?? []);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load error logs: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadCacheStatus() async {
    try {
      isLoading.value = true;

      final response =
          await EnhancedApiService.getSystemMonitorData('cache_status');

      cacheStatus.value = response;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load cache status: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadDatabaseStatus() async {
    try {
      isLoading.value = true;

      final response =
          await EnhancedApiService.getSystemMonitorData('database_status');

      databaseStatus.value = response;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load database status: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> clearCache({bool all = false}) async {
    try {
      await EnhancedApiService.clearSystemCache(all: all);

      Get.snackbar(
          'Success', all ? 'All cache cleared' : 'Expired cache cleared');

      await loadCacheStatus();
    } catch (e) {
      Get.snackbar('Error', 'Failed to clear cache: $e');
    }
  }

  Future<void> toggleMaintenanceMode() async {
    try {
      await EnhancedApiService.toggleMaintenanceMode();

      Get.snackbar('Success', 'Maintenance mode toggled');

      await loadSystemHealth();
    } catch (e) {
      Get.snackbar('Error', 'Failed to toggle maintenance mode: $e');
    }
  }
}
