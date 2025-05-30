import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ecom_modwir/constants.dart';
import 'package:ecom_modwir/controllers/language_controller.dart';

class AppUtils {
  static final _languageController = Get.find<LanguageController>();

  // Show success snackbar
  static void showSuccess(String message) {
    Get.snackbar(
      'success'.tr,
      message,
      backgroundColor: successColor,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.check_circle, color: Colors.white),
      margin: const EdgeInsets.all(defaultPadding),
      borderRadius: defaultBorderRadius,
    );
  }

  // Show error snackbar
  static void showError(String message) {
    Get.snackbar(
      'error'.tr,
      message,
      backgroundColor: errorColor,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 4),
      icon: const Icon(Icons.error, color: Colors.white),
      margin: const EdgeInsets.all(defaultPadding),
      borderRadius: defaultBorderRadius,
    );
  }

  // Show warning snackbar
  static void showWarning(String message) {
    Get.snackbar(
      'warning'.tr,
      message,
      backgroundColor: warningColor,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.warning, color: Colors.white),
      margin: const EdgeInsets.all(defaultPadding),
      borderRadius: defaultBorderRadius,
    );
  }

  // Show info snackbar
  static void showInfo(String message) {
    Get.snackbar(
      'info'.tr,
      message,
      backgroundColor: primaryColor,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.info, color: Colors.white),
      margin: const EdgeInsets.all(defaultPadding),
      borderRadius: defaultBorderRadius,
    );
  }

  // Show loading dialog
  static void showLoading({String? message}) {
    Get.dialog(
      Center(
        child: Container(
          padding: const EdgeInsets.all(defaultPadding * 2),
          decoration: BoxDecoration(
            color: Get.theme.cardColor,
            borderRadius: BorderRadius.circular(defaultBorderRadius),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              if (message != null) ...[
                const SizedBox(height: defaultPadding),
                Text(message),
              ],
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  // Hide loading dialog
  static void hideLoading() {
    if (Get.isDialogOpen == true) {
      Get.back();
    }
  }

  // Format currency in SAR
  static String formatCurrency(double amount, {bool showSymbol = true}) {
    final formatter = NumberFormat('#,##0.00');
    final formattedAmount = formatter.format(amount);

    if (_languageController.currentLanguage.value == 'ar') {
      return showSymbol ? '$formattedAmount ر.س' : formattedAmount;
    } else {
      return showSymbol ? 'SAR $formattedAmount' : formattedAmount;
    }
  }

  // Format large numbers (K, M, B)
  static String formatCompactNumber(double number) {
    if (number >= 1000000000) {
      return '${(number / 1000000000).toStringAsFixed(1)}B';
    } else if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    } else {
      return number.toStringAsFixed(0);
    }
  }

  // Format date
  static String formatDate(DateTime date) {
    if (_languageController.currentLanguage.value == 'ar') {
      return DateFormat('dd/MM/yyyy', 'ar').format(date);
    } else {
      return DateFormat('MMM dd, yyyy').format(date);
    }
  }

  // Format date time
  static String formatDateTime(DateTime dateTime) {
    if (_languageController.currentLanguage.value == 'ar') {
      return DateFormat('dd/MM/yyyy HH:mm', 'ar').format(dateTime);
    } else {
      return DateFormat('MMM dd, yyyy HH:mm').format(dateTime);
    }
  }

  // Format time only
  static String formatTime(DateTime time) {
    return DateFormat('HH:mm').format(time);
  }

  // Get relative time (e.g., "2 hours ago")
  static String getRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} ${'years_ago'.tr}';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} ${'months_ago'.tr}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ${'days_ago'.tr}';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${'hours_ago'.tr}';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${'minutes_ago'.tr}';
    } else {
      return 'just_now'.tr;
    }
  }

  // Validate email
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // Validate phone (Saudi format)
  static bool isValidSaudiPhone(String phone) {
    // Remove any non-digit characters
    final cleanPhone = phone.replaceAll(RegExp(r'[^\d]'), '');

    // Check for Saudi phone number patterns
    return RegExp(r'^(966|0)?5[0-9]{8}$').hasMatch(cleanPhone) ||
        RegExp(r'^(966|0)?1[0-9]{7}$').hasMatch(cleanPhone);
  }

  // Format phone number
  static String formatSaudiPhone(String phone) {
    final cleanPhone = phone.replaceAll(RegExp(r'[^\d]'), '');

    if (cleanPhone.startsWith('966')) {
      return '+966 ${cleanPhone.substring(3, 5)} ${cleanPhone.substring(5, 8)} ${cleanPhone.substring(8)}';
    } else if (cleanPhone.startsWith('0')) {
      return '${cleanPhone.substring(0, 3)} ${cleanPhone.substring(3, 6)} ${cleanPhone.substring(6)}';
    } else if (cleanPhone.startsWith('5')) {
      return '05${cleanPhone.substring(1, 3)} ${cleanPhone.substring(3, 6)} ${cleanPhone.substring(6)}';
    }

    return phone;
  }

  // Get file size in human readable format
  static String formatFileSize(int bytes) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB"];
    var i = (bytes.bitLength - 1) ~/ 10;
    return '${(bytes / (1 << (i * 10))).toStringAsFixed(1)} ${suffixes[i]}';
  }

  // Copy text to clipboard
  static void copyToClipboard(String text) {
    // Implementation would go here - requires clipboard package
    showSuccess('copied_to_clipboard'.tr);
  }

  // Show confirmation dialog
  static Future<bool> showConfirmDialog({
    required String title,
    required String message,
    String? confirmText,
    String? cancelText,
    Color? confirmColor,
  }) async {
    final result = await Get.dialog<bool>(
      AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text(cancelText ?? 'cancel'.tr),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(
              backgroundColor: confirmColor ?? errorColor,
            ),
            child: Text(confirmText ?? 'confirm'.tr),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  // Generate random color
  static Color generateRandomColor() {
    return Color((DateTime.now().millisecondsSinceEpoch * 1000).toInt())
        .withOpacity(1.0);
  }

  // Get initials from name
  static String getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    } else if (parts.isNotEmpty) {
      return parts.first.substring(0, 1).toUpperCase();
    }
    return '';
  }

  // Convert map to localized text
  static String getLocalizedText(Map<String, String>? textMap) {
    if (textMap == null || textMap.isEmpty) return '';

    final currentLang = _languageController.currentLanguage.value;
    return textMap[currentLang] ?? textMap['en'] ?? textMap.values.first;
  }

  // Get order status badge
  static Widget getOrderStatusBadge(int status) {
    final statusText = OrderStatus.getStatusText(status);
    final statusColor = OrderStatus.getStatusColor(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Text(
        statusText.tr,
        style: TextStyle(
          color: statusColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Get payment status badge
  static Widget getPaymentStatusBadge(String status) {
    final statusColor = PaymentStatus.getStatusColor(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Text(
        status.tr,
        style: TextStyle(
          color: statusColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Get user status badge
  static Widget getUserStatusBadge(String status) {
    final statusColor = UserStatus.getStatusColor(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Text(
        status.tr,
        style: TextStyle(
          color: statusColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
