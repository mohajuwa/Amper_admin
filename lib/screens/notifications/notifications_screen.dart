import 'package:ecom_modwir/models/notification_model.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../controllers/notifications_controller.dart';

import '../../controllers/language_controller.dart';

import '../../constants.dart';

import '../dashboard/components/header.dart';

import '../../utils/app_utils.dart';

class NotificationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final notificationsController = Get.put(NotificationsController());

    final languageController = Get.find<LanguageController>();

    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            const Header(),

            const SizedBox(height: defaultPadding),

            // Page header

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      "Notifications",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(width: 8),
                    Obx(() => Badge(
                          label: Text(notificationsController.unreadCount.value
                              .toString()),
                          child: const Icon(Icons.notifications),
                        )),
                  ],
                ),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => _showSendNotificationDialog(),
                      icon: const Icon(Icons.send),
                      label: Text("Send Notification"),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: notificationsController.markAllAsRead,
                      child: Text("Mark All Read"),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: defaultPadding),

            // Notifications list

            Container(
              decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: Obx(() {
                if (notificationsController.isLoading.value) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(defaultPadding * 2),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (notificationsController.notifications.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(defaultPadding * 2),
                      child: Column(
                        children: [
                          const Icon(Icons.notifications_none,
                              size: 64, color: Colors.grey),
                          const SizedBox(height: 16),
                          Text("No notifications available"),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: notificationsController.notifications.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final notification =
                        notificationsController.notifications[index];

                    return NotificationCard(
                      notification: notification,
                      languageCode: languageController.currentLanguage.value,
                      onTap: () => notificationsController
                          .markAsRead(notification.notificationId),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  void _showSendNotificationDialog() {
    final titleController = TextEditingController();

    final bodyController = TextEditingController();

    final userIdController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: Text("Send Notification"),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: "Title",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: defaultPadding),
              TextField(
                controller: bodyController,
                decoration: InputDecoration(
                  labelText: "Message",
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: defaultPadding),
              TextField(
                controller: userIdController,
                decoration: InputDecoration(
                  labelText: "User ID (0 for all users)",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text("cancel".tr),
          ),
          ElevatedButton(
            onPressed: () {
              final notificationsController =
                  Get.find<NotificationsController>();

              notificationsController.sendNotification(
                titleController.text,
                bodyController.text,
                int.tryParse(userIdController.text) ?? 0,
              );

              Get.back();
            },
            child: Text("Send"),
          ),
        ],
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;

  final String languageCode;

  final VoidCallback onTap;

  const NotificationCard({
    Key? key,
    required this.notification,
    required this.languageCode,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: notification.notificationRead == 0
              ? primaryColor.withOpacity(0.1)
              : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          Icons.notifications,
          color:
              notification.notificationRead == 0 ? primaryColor : Colors.grey,
        ),
      ),
      title: Text(
        notification.getLocalizedTitle(languageCode),
        style: TextStyle(
          fontWeight: notification.notificationRead == 0
              ? FontWeight.bold
              : FontWeight.normal,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            notification.getLocalizedBody(languageCode),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            AppUtils.formatDateTime(notification.notificationDatetime),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
      trailing: notification.notificationRead == 0
          ? Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(4),
              ),
            )
          : null,
    );
  }
}
