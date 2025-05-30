class AnalyticsModel {
  final Map<String, dynamic> revenueData;

  final Map<String, dynamic> userMetrics;

  final Map<String, dynamic> orderMetrics;

  final Map<String, dynamic> serviceMetrics;

  AnalyticsModel({
    required this.revenueData,
    required this.userMetrics,
    required this.orderMetrics,
    required this.serviceMetrics,
  });

  factory AnalyticsModel.fromJson(Map<String, dynamic> json) {
    return AnalyticsModel(
      revenueData: json['revenue_data'] ?? {},
      userMetrics: json['user_metrics'] ?? {},
      orderMetrics: json['order_metrics'] ?? {},
      serviceMetrics: json['service_metrics'] ?? {},
    );
  }
}
