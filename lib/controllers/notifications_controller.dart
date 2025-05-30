import 'package:get/get.dart';

import '../models/notification_model.dart';

import '../services/api_service.dart';

class NotificationsController extends GetxController {
  var isLoading = false.obs;

  var notifications = <NotificationModel>[].obs;

  var unreadCount = 0.obs;

  @override
  void onInit() {
    super.onInit();

    loadNotifications();
  }

  Future<void> loadNotifications() async {
    try {
      isLoading.value = true;

      final response = await ApiService.getNotifications();

      notifications.value = response;

      unreadCount.value = response.where((n) => n.notificationRead == 0).length;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load notifications');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> markAsRead(int notificationId) async {
    try {
      await ApiService.markNotificationRead(notificationId);

      final index =
          notifications.indexWhere((n) => n.notificationId == notificationId);

      if (index != -1) {
        notifications[index] =
            notifications[index].copyWith(notificationRead: 1);

        unreadCount.value =
            notifications.where((n) => n.notificationRead == 0).length;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to mark notification as read');
    }
  }

  Future<void> markAllAsRead() async {
    try {
      await ApiService.markAllNotificationsRead();

      for (int i = 0; i < notifications.length; i++) {
        notifications[i] = notifications[i].copyWith(notificationRead: 1);
      }

      unreadCount.value = 0;

      Get.snackbar('Success', 'All notifications marked as read');
    } catch (e) {
      Get.snackbar('Error', 'Failed to mark all notifications as read');
    }
  }

  Future<void> sendNotification(String title, String body, int userId) async {
    try {
      await ApiService.sendNotification(title, body, userId);

      Get.snackbar('Success', 'Notification sent successfully');

      loadNotifications(); // Refresh notifications
    } catch (e) {
      Get.snackbar('Error', 'Failed to send notification');
    }
  }
}
