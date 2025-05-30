import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

import 'package:get/get.dart';

import 'package:ecom_modwir/utils/app_utils.dart';

class ErrorHandlerService extends GetxService {
  static ErrorHandlerService get to => Get.find();

  final List<AppError> _errors = [];

  void handleError(dynamic error, {String? context, StackTrace? stackTrace}) {
    final appError = AppError(
      message: error.toString(),
      context: context,
      stackTrace: stackTrace,
      timestamp: DateTime.now(),
    );

    _errors.add(appError);

    // Log error for debugging

    if (kDebugMode) {
      developer.log(
        'Error: ${appError.message}',
        name: 'ErrorHandler',
        error: error,
        stackTrace: stackTrace,
      );
    }

    // Show user-friendly error message

    _showUserError(appError);

    // Keep only last 100 errors

    if (_errors.length > 100) {
      _errors.removeAt(0);
    }
  }

  void _showUserError(AppError error) {
    String userMessage = _getUserFriendlyMessage(error.message);

    AppUtils.showError(userMessage);
  }

  String _getUserFriendlyMessage(String errorMessage) {
    final message = errorMessage.toLowerCase();

    if (message.contains('network') || message.contains('connection')) {
      return 'network_connection_error'.tr;
    } else if (message.contains('timeout')) {
      return 'request_timeout_error'.tr;
    } else if (message.contains('unauthorized') || message.contains('401')) {
      return 'unauthorized_error'.tr;
    } else if (message.contains('forbidden') || message.contains('403')) {
      return 'forbidden_error'.tr;
    } else if (message.contains('not found') || message.contains('404')) {
      return 'not_found_error'.tr;
    } else if (message.contains('server') || message.contains('500')) {
      return 'server_error'.tr;
    } else {
      return 'general_error'.tr;
    }
  }

  List<AppError> get recentErrors => _errors.reversed.take(20).toList();

  void clearErrors() {
    _errors.clear();
  }
}

class AppError {
  final String message;

  final String? context;

  final StackTrace? stackTrace;

  final DateTime timestamp;

  AppError({
    required this.message,
    this.context,
    this.stackTrace,
    required this.timestamp,
  });
}
