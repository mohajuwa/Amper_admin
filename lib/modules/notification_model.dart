import 'dart:convert';

class NotificationModel {
  final int notificationId;

  final int notificationOrderId;

  final Map<String, String>? notificationTitle;

  final Map<String, String>? notificationBody;

  final int notificationUserId;

  final int notificationRead;

  final DateTime notificationDatetime;

  NotificationModel({
    required this.notificationId,
    required this.notificationOrderId,
    this.notificationTitle,
    this.notificationBody,
    required this.notificationUserId,
    required this.notificationRead,
    required this.notificationDatetime,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    Map<String, String>? title;

    Map<String, String>? body;

    if (json['notification_title'] != null) {
      if (json['notification_title'] is String) {
        title =
            Map<String, String>.from(jsonDecode(json['notification_title']));
      } else {
        title = Map<String, String>.from(json['notification_title']);
      }
    }

    if (json['notification_body'] != null) {
      if (json['notification_body'] is String) {
        body = Map<String, String>.from(jsonDecode(json['notification_body']));
      } else {
        body = Map<String, String>.from(json['notification_body']);
      }
    }

    return NotificationModel(
      notificationId: json['notification_id'],
      notificationOrderId: json['notification_order_id'],
      notificationTitle: title,
      notificationBody: body,
      notificationUserId: json['notification_userid'],
      notificationRead: json['notification_read'],
      notificationDatetime: DateTime.parse(json['notification_datetime']),
    );
  }

  NotificationModel copyWith({
    int? notificationRead,
  }) {
    return NotificationModel(
      notificationId: this.notificationId,
      notificationOrderId: this.notificationOrderId,
      notificationTitle: this.notificationTitle,
      notificationBody: this.notificationBody,
      notificationUserId: this.notificationUserId,
      notificationRead: notificationRead ?? this.notificationRead,
      notificationDatetime: this.notificationDatetime,
    );
  }

  String getLocalizedTitle(String languageCode) {
    return notificationTitle?[languageCode] ??
        notificationTitle?['en'] ??
        'Notification';
  }

  String getLocalizedBody(String languageCode) {
    return notificationBody?[languageCode] ?? notificationBody?['en'] ?? '';
  }
}
