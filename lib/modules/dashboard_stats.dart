class DashboardStats {
  final int totalUsers;
  final int totalOrders;
  final double totalRevenue;
  final int pendingOrders;
  final int completedOrders;
  final int activeServices;

  DashboardStats({
    this.totalUsers = 0,
    this.totalOrders = 0,
    this.totalRevenue = 0.0,
    this.pendingOrders = 0,
    this.completedOrders = 0,
    this.activeServices = 0,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      totalUsers: json['total_users'] ?? 0,
      totalOrders: json['total_orders'] ?? 0,
      totalRevenue: json['total_revenue']?.toDouble() ?? 0.0,
      pendingOrders: json['pending_orders'] ?? 0,
      completedOrders: json['completed_orders'] ?? 0,
      activeServices: json['active_services'] ?? 0,
    );
  }
}
