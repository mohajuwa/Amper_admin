import 'package:flutter/material.dart';

// Color Constants
const primaryColor = Color(0xFF2697FF);
const secondaryColor = Color(0xFF2A2D3E);
const bgColor = Color(0xFF212332);
const surfaceColor = Color(0xFF1E1E2E);
const errorColor = Color(0xFFEE2727);
const warningColor = Color(0xFFFFA113);
const successColor = Color(0xFF00D4AA);

// Spacing
const defaultPadding = 16.0;
const smallPadding = 8.0;
const largePadding = 24.0;

// Border Radius
const defaultBorderRadius = 10.0;
const smallBorderRadius = 6.0;
const largeBorderRadius = 16.0;

// Animation Durations
const shortDuration = Duration(milliseconds: 200);
const mediumDuration = Duration(milliseconds: 300);
const longDuration = Duration(milliseconds: 500);

// Currency Settings
const String defaultCurrency = 'SAR';
const String currencySymbol = 'ر.س';

// API Settings
const int apiTimeoutSeconds = 30;
const int maxRetries = 3;

// App Settings
const String appName = 'Modwir Admin Panel';
const String appVersion = '1.0.0';

// File Size Limits
const int maxImageSizeBytes = 5 * 1024 * 1024; // 5MB
const int maxDocumentSizeBytes = 10 * 1024 * 1024; // 10MB

// Validation Rules
const int minPasswordLength = 6;
const int maxPasswordLength = 50;
const int minUsernameLength = 3;
const int maxUsernameLength = 30;

// Status Colors
class StatusColors {
  static const active = Color(0xFF00C851);
  static const inactive = Color(0xFFFF8800);
  static const pending = Color(0xFF2196F3);
  static const completed = Color(0xFF4CAF50);
  static const cancelled = Color(0xFFF44336);
  static const failed = Color(0xFFE91E63);
}

// Order Status Constants
class OrderStatus {
  static const int pending = 0;
  static const int confirmed = 1;
  static const int inProgress = 2;
  static const int completed = 3;
  static const int cancelled = 4;

  static String getStatusText(int status) {
    switch (status) {
      case pending:
        return 'pending';
      case confirmed:
        return 'confirmed';
      case inProgress:
        return 'in_progress';
      case completed:
        return 'completed';
      case cancelled:
        return 'cancelled';
      default:
        return 'unknown';
    }
  }

  static Color getStatusColor(int status) {
    switch (status) {
      case pending:
        return StatusColors.pending;
      case confirmed:
        return primaryColor;
      case inProgress:
        return StatusColors.inactive;
      case completed:
        return StatusColors.completed;
      case cancelled:
        return StatusColors.cancelled;
      default:
        return Colors.grey;
    }
  }
}

// Payment Status Constants
class PaymentStatus {
  static const String pending = 'pending';
  static const String completed = 'completed';
  static const String failed = 'failed';
  static const String refunded = 'refunded';

  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case pending:
        return StatusColors.pending;
      case completed:
        return StatusColors.completed;
      case failed:
        return StatusColors.failed;
      case refunded:
        return StatusColors.inactive;
      default:
        return Colors.grey;
    }
  }
}

// User Status Constants
class UserStatus {
  static const String active = 'active';
  static const String inactive = 'inactive';
  static const String banned = 'banned';
  static const String pending = 'pending';

  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case active:
        return StatusColors.active;
      case inactive:
        return StatusColors.inactive;
      case banned:
        return StatusColors.cancelled;
      case pending:
        return StatusColors.pending;
      default:
        return Colors.grey;
    }
  }
}

// Responsive Breakpoints
class Breakpoints {
  static const double mobile = 600;
  static const double tablet = 900;
  static const double desktop = 1200;
  static const double largeDesktop = 1600;
}

// Theme Extensions
extension ThemeDataExtension on ThemeData {
  Color get containerColor =>
      brightness == Brightness.dark ? secondaryColor : Colors.white;

  Color get surfaceVariant =>
      brightness == Brightness.dark ? surfaceColor : Colors.grey[50]!;

  Color get onSurfaceVariant =>
      brightness == Brightness.dark ? Colors.white70 : Colors.black54;

  Color get borderColor =>
      brightness == Brightness.dark ? Colors.white24 : Colors.grey[300]!;
}
