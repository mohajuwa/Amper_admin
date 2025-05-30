// lib/app/routes/app_routes.dart
abstract class AppRoutes {
  static const LOGIN = '/login';
  static const DASHBOARD = '/dashboard';
  static const DASHBOARD_CONTENT = '/dashboard_content';

  static const ORDERS = '/orders';
  static const ORDER_DETAILS = '/orders/:id'; // Example with parameter
  static const USERS = '/users';
  static const ADMIN_USERS = '/admin-users';
  static const CUSTOMERS = '/customers';
  static const SERVICES = '/services';
  static const SUB_SERVICES = '/sub-services';
  static const SUB_SERVICES_BY_CAR = '/sub-services-by-car';
  static const VEHICLES = '/vehicles';
  static const PAYMENTS = '/payments';
  static const NOTIFICATIONS = '/notifications';
  static const SETTINGS = '/settings';
  static const DEVELOPER_TOOLS = '/developer-tools';
  // Add other routes as needed
}
