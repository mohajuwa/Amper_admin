import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/websocket_service.dart';

class RealtimeController extends GetxController {
  final WebSocketService _wsService = Get.find<WebSocketService>();

  var newOrdersCount = 0.obs;

  var systemAlerts = <SystemAlert>[].obs;

  var realtimeEvents = <RealtimeEvent>[].obs;

  @override
  void onInit() {
    super.onInit();

    _setupWebSocketListeners();
  }

  void _setupWebSocketListeners() {
    // Listen for new orders

    _wsService.addListener('new_order', (data) {
      newOrdersCount.value++;

      _addRealtimeEvent(
          'New Order', 'Order #${data['data']['order_number']} received');

      Get.snackbar(
        'New Order',
        'Order #${data['data']['order_number']} has been placed',
        duration: Duration(seconds: 5),
      );
    });

    // Listen for order updates

    _wsService.addListener('order_updated', (data) {
      _addRealtimeEvent('Order Updated',
          'Order #${data['data']['order_number']} status changed');
    });

    // Listen for new users

    _wsService.addListener('new_user', (data) {
      _addRealtimeEvent('New User', '${data['data']['full_name']} registered');
    });

    // Listen for system alerts

    _wsService.addListener('system_alert', (data) {
      final alert = SystemAlert(
        message: data['data']['message'],
        level: data['data']['level'],
        timestamp:
            DateTime.fromMillisecondsSinceEpoch(data['timestamp'] * 1000),
      );

      systemAlerts.insert(0, alert);

      // Show critical alerts as dialogs

      if (alert.level == 'error' || alert.level == 'critical') {
        Get.dialog(
          AlertDialog(
            title: Text('System Alert'),
            content: Text(alert.message),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    });
  }

  void _addRealtimeEvent(String title, String description) {
    final event = RealtimeEvent(
      title: title,
      description: description,
      timestamp: DateTime.now(),
    );

    realtimeEvents.insert(0, event);

    // Keep only last 50 events

    if (realtimeEvents.length > 50) {
      realtimeEvents.removeLast();
    }
  }

  void markOrdersAsViewed() {
    newOrdersCount.value = 0;
  }

  void dismissAlert(SystemAlert alert) {
    systemAlerts.remove(alert);
  }

  void clearAllAlerts() {
    systemAlerts.clear();
  }
}

class SystemAlert {
  final String message;

  final String level;

  final DateTime timestamp;

  SystemAlert({
    required this.message,
    required this.level,
    required this.timestamp,
  });
}

class RealtimeEvent {
  final String title;

  final String description;

  final DateTime timestamp;

  RealtimeEvent({
    required this.title,
    required this.description,
    required this.timestamp,
  });
}
