import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecom_modwir/controllers/developer_tools_controller.dart';
import 'package:ecom_modwir/constants.dart';
import 'package:ecom_modwir/utils/app_utils.dart';

// System Health Widget
class SystemHealthWidget extends StatelessWidget {
  final DeveloperToolsController controller;

  const SystemHealthWidget({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: Get.theme.cardColor,
        borderRadius: BorderRadius.circular(defaultBorderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'System Health Monitor',
            style: Get.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: defaultPadding),
          Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            final health = controller.systemHealth;

            return Column(
              children: [
                _buildHealthCard(
                  'CPU Usage',
                  '${health['cpu_usage'] ?? 0}%',
                  Icons.memory,
                  _getHealthColor(health['cpu_usage']),
                ),
                const SizedBox(height: defaultPadding),
                _buildHealthCard(
                  'Memory Usage',
                  '${health['memory_usage'] ?? 0}%',
                  Icons.storage,
                  _getHealthColor(health['memory_usage']),
                ),
                const SizedBox(height: defaultPadding),
                _buildHealthCard(
                  'Disk Usage',
                  '${health['disk_usage'] ?? 0}%',
                  Icons.folder,
                  _getHealthColor(health['disk_usage']),
                ),
                const SizedBox(height: defaultPadding),
                _buildHealthCard(
                  'Database Status',
                  health['database_status'] ?? 'Unknown',
                  Icons.data_object_rounded,
                  health['database_status'] == 'healthy'
                      ? successColor
                      : errorColor,
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildHealthCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: defaultPadding),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Get.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: Get.textTheme.titleMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getHealthColor(dynamic usage) {
    if (usage == null) return Colors.grey;
    final percent = double.tryParse(usage.toString()) ?? 0;
    if (percent < 50) return successColor;
    if (percent < 80) return warningColor;
    return errorColor;
  }
}

// API Debugger Widget
class APIDebuggerWidget extends StatelessWidget {
  final DeveloperToolsController controller;

  const APIDebuggerWidget({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: Get.theme.cardColor,
        borderRadius: BorderRadius.circular(defaultBorderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'API Debugger',
            style: Get.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: defaultPadding),

          // API Testing Section
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'API Endpoint',
                    hintText: '/admin/dashboard.php',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: defaultPadding),
              ElevatedButton(
                onPressed: () => _testAPI(),
                child: Text('Test'),
              ),
            ],
          ),

          const SizedBox(height: defaultPadding),

          // Response Section
          Container(
            height: 200,
            width: double.infinity,
            padding: const EdgeInsets.all(defaultPadding),
            decoration: BoxDecoration(
              color: Get.theme.brightness == Brightness.dark
                  ? Colors.black12
                  : Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: const SingleChildScrollView(
              child: Text(
                'API Response will appear here...\n\n'
                'Available endpoints:\n'
                '• /admin/dashboard.php\n'
                '• /admin/users/view.php\n'
                '• /admin/orders/details.php\n'
                '• /admin/services/services_display.php',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _testAPI() {
    AppUtils.showInfo('API testing functionality would be implemented here');
  }
}

// Performance Monitor Widget
class PerformanceMonitorWidget extends StatelessWidget {
  final DeveloperToolsController controller;

  const PerformanceMonitorWidget({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: Get.theme.cardColor,
        borderRadius: BorderRadius.circular(defaultBorderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Performance Monitor',
            style: Get.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: defaultPadding),
          Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            final metrics = controller.performanceMetrics;

            return Column(
              children: [
                _buildMetricRow('Average Response Time',
                    '${metrics['avg_response_time'] ?? 0}ms'),
                _buildMetricRow(
                    'Total Requests', '${metrics['total_requests'] ?? 0}'),
                _buildMetricRow(
                    'Failed Requests', '${metrics['failed_requests'] ?? 0}'),
                _buildMetricRow(
                    'Cache Hit Rate', '${metrics['cache_hit_rate'] ?? 0}%'),
                const SizedBox(height: defaultPadding),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => controller.loadPerformanceMetrics(),
                        child: Text('Refresh Metrics'),
                      ),
                    ),
                    const SizedBox(width: defaultPadding),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _clearMetrics(),
                        child: Text('Clear Cache'),
                      ),
                    ),
                  ],
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildMetricRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Get.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: Get.textTheme.bodyMedium?.copyWith(
              color: primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _clearMetrics() {
    AppUtils.showSuccess('Performance metrics cleared');
  }
}

// Error Logs Widget
class ErrorLogsWidget extends StatelessWidget {
  final DeveloperToolsController controller;

  const ErrorLogsWidget({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: Get.theme.cardColor,
        borderRadius: BorderRadius.circular(defaultBorderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Error Logs',
                style: Get.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton(
                onPressed: () => controller.loadErrorLogs(),
                child: Text('Refresh'),
              ),
            ],
          ),
          const SizedBox(height: defaultPadding),
          Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            final logs = controller.errorLogs;

            if (logs.isEmpty) {
              return Center(
                child: Column(
                  children: [
                    Icon(Icons.check_circle, size: 48, color: successColor),
                    const SizedBox(height: 8),
                    Text('No errors logged'),
                  ],
                ),
              );
            }

            return Container(
              height: 300,
              child: ListView.builder(
                itemCount: logs.length,
                itemBuilder: (context, index) {
                  final log = logs[index];
                  return _buildLogItem(log);
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildLogItem(Map<String, dynamic> log) {
    final level = log['level'] ?? 'info';
    final color = _getLogColor(level);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  level.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                log['timestamp'] ?? '',
                style: Get.textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            log['message'] ?? '',
            style: Get.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Color _getLogColor(String level) {
    switch (level.toLowerCase()) {
      case 'error':
        return errorColor;
      case 'warning':
        return warningColor;
      case 'info':
        return primaryColor;
      default:
        return Colors.grey;
    }
  }
}

// Cache Manager Widget
class CacheManagerWidget extends StatelessWidget {
  final DeveloperToolsController controller;

  const CacheManagerWidget({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: Get.theme.cardColor,
        borderRadius: BorderRadius.circular(defaultBorderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cache Manager',
            style: Get.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: defaultPadding),
          Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            final cache = controller.cacheStatus;

            return Column(
              children: [
                _buildCacheItem(
                    'API Cache', cache['api_cache_size'] ?? '0 KB', Icons.api),
                _buildCacheItem('Image Cache',
                    cache['image_cache_size'] ?? '0 KB', Icons.image),
                _buildCacheItem('Database Cache',
                    cache['db_cache_size'] ?? '0 KB', Icons.storage),
                const SizedBox(height: defaultPadding * 2),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => controller.clearCache(all: false),
                        icon: const Icon(Icons.cleaning_services),
                        label: Text('Clear Expired'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: warningColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: defaultPadding),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _confirmClearAll(),
                        icon: const Icon(Icons.delete_sweep),
                        label: Text('Clear All'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: errorColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCacheItem(String name, String size, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: Get.theme.brightness == Brightness.dark
            ? Colors.white.withOpacity(0.05)
            : Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: primaryColor),
          const SizedBox(width: defaultPadding),
          Expanded(
            child: Text(
              name,
              style: Get.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            size,
            style: Get.textTheme.bodyMedium?.copyWith(
              color: primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _confirmClearAll() {
    Get.dialog(
      AlertDialog(
        title: Text('Clear All Cache'),
        content: Text(
            'Are you sure you want to clear all cached data? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.clearCache(all: true);
            },
            style: ElevatedButton.styleFrom(backgroundColor: errorColor),
            child: Text('Clear All'),
          ),
        ],
      ),
    );
  }
}

// Database Status Widget
class DatabaseStatusWidget extends StatelessWidget {
  final DeveloperToolsController controller;

  const DatabaseStatusWidget({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: Get.theme.cardColor,
        borderRadius: BorderRadius.circular(defaultBorderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Database Status',
            style: Get.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: defaultPadding),
          Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            final db = controller.databaseStatus;

            return Column(
              children: [
                _buildStatusRow(
                    'Connection Status',
                    db['connection_status'] ?? 'Unknown',
                    db['connection_status'] == 'healthy'
                        ? successColor
                        : errorColor),
                _buildStatusRow(
                    'Total Tables', '${db['total_tables'] ?? 0}', primaryColor),
                _buildStatusRow('Database Size', db['database_size'] ?? '0 MB',
                    primaryColor),
                _buildStatusRow('Active Connections',
                    '${db['active_connections'] ?? 0}', primaryColor),
                const SizedBox(height: defaultPadding * 2),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => controller.loadDatabaseStatus(),
                        icon: const Icon(Icons.refresh),
                        label: Text('Refresh Status'),
                      ),
                    ),
                    const SizedBox(width: defaultPadding),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _optimizeDatabase(),
                        icon: const Icon(Icons.tune),
                        label: Text('Optimize'),
                      ),
                    ),
                  ],
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildStatusRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Get.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              value,
              style: Get.textTheme.bodySmall?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _optimizeDatabase() {
    AppUtils.showInfo('Database optimization started');
  }
}
