// Loading Screen Widget
import 'package:ecom_modwir/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.business,
                size: 60,
                color: primaryColor,
              ),
            ),

            const SizedBox(height: defaultPadding * 2),

            // Loading indicator
            SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(
                strokeWidth: 4,
                valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
              ),
            ),

            const SizedBox(height: defaultPadding),

            // Loading text
            Text(
              'loading'.tr,
              style: Get.textTheme.titleMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),

            const SizedBox(height: defaultPadding),

            // App name
            Text(
              appName,
              style: Get.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Error Screen Widget
class ErrorScreen extends StatelessWidget {
  final String? message;
  final VoidCallback? onRetry;

  const ErrorScreen({
    Key? key,
    this.message,
    this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(defaultPadding * 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Error icon
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: errorColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.error_outline,
                  size: 60,
                  color: errorColor,
                ),
              ),

              const SizedBox(height: defaultPadding * 2),

              // Error title
              Text(
                'error_occurred'.tr,
                style: Get.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: errorColor,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: defaultPadding),

              // Error message
              Text(
                message ?? 'something_went_wrong'.tr,
                style: Get.textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: defaultPadding * 2),

              // Retry button
              if (onRetry != null)
                ElevatedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh),
                  label: Text('retry'.tr),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: defaultPadding * 2,
                      vertical: defaultPadding,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// No Data Screen Widget
class NoDataScreen extends StatelessWidget {
  final String? title;
  final String? message;
  final IconData? icon;
  final VoidCallback? onRefresh;

  const NoDataScreen({
    Key? key,
    this.title,
    this.message,
    this.icon,
    this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding * 2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // No data icon
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                icon ?? Icons.inbox_outlined,
                size: 60,
                color: Colors.grey[400],
              ),
            ),

            const SizedBox(height: defaultPadding * 2),

            // No data title
            Text(
              title ?? 'no_data_available'.tr,
              style: Get.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: defaultPadding),

            // No data message
            if (message != null)
              Text(
                message!,
                style: Get.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[500],
                ),
                textAlign: TextAlign.center,
              ),

            const SizedBox(height: defaultPadding * 2),

            // Refresh button
            if (onRefresh != null)
              OutlinedButton.icon(
                onPressed: onRefresh,
                icon: const Icon(Icons.refresh),
                label: Text('refresh'.tr),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: defaultPadding * 2,
                    vertical: defaultPadding,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
