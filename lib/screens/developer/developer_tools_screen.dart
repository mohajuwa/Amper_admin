import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecom_modwir/controllers/developer_tools_controller.dart';
import 'package:ecom_modwir/constants.dart';
import 'package:ecom_modwir/screens/dashboard/components/header.dart';

class DeveloperToolsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final devController = Get.put(DeveloperToolsController());

    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            const Header(),
            const SizedBox(height: defaultPadding),

            Text(
              'Developer Tools',
              style: Theme.of(context).textTheme.titleLarge,
            ),

            const SizedBox(height: defaultPadding),

            // Tools Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              crossAxisSpacing: defaultPadding,
              mainAxisSpacing: defaultPadding,
              childAspectRatio: 1.2,
              children: [
                _buildToolCard(
                  'System Health',
                  Icons.monitor_heart,
                  Colors.green,
                  () => devController.showSystemHealth(),
                ),
                _buildToolCard(
                  'API Debugger',
                  Icons.bug_report,
                  Colors.orange,
                  () => devController.showAPIDebugger(),
                ),
                _buildToolCard(
                  'Performance Monitor',
                  Icons.speed,
                  Colors.blue,
                  () => devController.showPerformanceMonitor(),
                ),
                _buildToolCard(
                  'Error Logs',
                  Icons.error_outline,
                  Colors.red,
                  () => devController.showErrorLogs(),
                ),
                _buildToolCard(
                  'Cache Manager',
                  Icons.storage,
                  Colors.purple,
                  () => devController.showCacheManager(),
                ),
                _buildToolCard(
                  'Database Status',
                  Icons.data_object_outlined,
                  Colors.teal,
                  () => devController.showDatabaseStatus(),
                ),
              ],
            ),

            const SizedBox(height: defaultPadding),

            // Content Area
            Obx(() => devController.selectedTool.value.isNotEmpty
                ? _buildToolContent(
                    devController.selectedTool.value, devController)
                : const DeveloperToolsPlaceholder()),
          ],
        ),
      ),
    );
  }

  Widget _buildToolCard(
      String title, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(defaultPadding),
        decoration: BoxDecoration(
          color: secondaryColor,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: color),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolContent(String tool, DeveloperToolsController controller) {
    switch (tool) {
      case 'system_health':
        return SystemHealthWidget(controller: controller);
      case 'api_debugger':
        return APIDebuggerWidget(controller: controller);
      case 'performance_monitor':
        return PerformanceMonitorWidget(controller: controller);
      case 'error_logs':
        return ErrorLogsWidget(controller: controller);
      case 'cache_manager':
        return CacheManagerWidget(controller: controller);
      case 'database_status':
        return DatabaseStatusWidget(controller: controller);
      default:
        return const DeveloperToolsPlaceholder();
    }
  }
}

class DeveloperToolsPlaceholder extends StatelessWidget {
  const DeveloperToolsPlaceholder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(defaultPadding * 2),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.developer_mode, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'Select a development tool from above',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
