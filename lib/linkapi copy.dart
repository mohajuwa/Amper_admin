class AppLink {
  static const String server = "https://modwir.com/haytham_store";
  static const String AdminLink = "$server/admin";
  static const String imageStatic = "$server/upload";

  // Dashboard
  static const String dashboardStats =
      "$AdminLink/dashboard.php?action=dashboard_stats";

  // Users
  static const String usersView = "$AdminLink/users/view.php";
  static const String usersUpdateStatus = "$AdminLink/users/update_status.php";

  // Services
  static const String serviceDisplay = "$server/services/services_display.php";
  static const String subserviceDisplay =
      "$server/services/sub_services_display.php";

  // Orders
  static const String detailsOrders = "$AdminLink/orders/details.php";
  static const String updateOrderStatus = "$AdminLink/orders/update_status.php";

  // Vehicles
  static const String vehicleView = "$server/vehicles/view.php";
  static const String vehicleAdd = "$server/vehicles/add.php";
  static const String vehicleRemove = "$server/vehicles/remove.php";

  // Cars
  static const String carsMakeDisplay = "$server/cars/view.php";
  static const String carsModelsDisplay = "$server/cars/models.php";

  // Notifications
  static const String notificationView = "$AdminLink/notifications/view.php";
  static const String markNotiRead = "$AdminLink/notifications/mark_read.php";
  static const String markAllNotiRead =
      "$AdminLink/notifications/mark_all_read.php";
  static const String sendNotification =
      "$AdminLink/notifications/notification.php";

  // Payments
  static const String paymentsView = "$AdminLink/payments/view.php";
  static const String paymentsStats = "$AdminLink/payments/stats.php";

  // Settings
  static const String settingsView = "$AdminLink/settings/view.php";
  static const String settingsUpdate = "$AdminLink/settings/update.php";

  // Export
  static const String exportData = "$AdminLink/export.php";
}
