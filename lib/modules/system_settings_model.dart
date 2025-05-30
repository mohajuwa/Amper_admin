class SystemSettingsModel {
  final String appName;

  final String appVersion;

  final String currency;

  final double taxRate;

  final double commissionRate;

  final int defaultDeliveryTime;

  final bool maintenanceMode;

  final Map<String, String> supportInfo;

  SystemSettingsModel({
    required this.appName,
    required this.appVersion,
    required this.currency,
    required this.taxRate,
    required this.commissionRate,
    required this.defaultDeliveryTime,
    required this.maintenanceMode,
    required this.supportInfo,
  });

  factory SystemSettingsModel.fromJson(Map<String, dynamic> json) {
    return SystemSettingsModel(
      appName: json['app_name'] ?? 'Modwir',
      appVersion: json['app_version'] ?? '1.0.0',
      currency: json['currency'] ?? 'SAR',
      taxRate: json['tax_rate']?.toDouble() ?? 0.15,
      commissionRate: json['commission_rate']?.toDouble() ?? 0.10,
      defaultDeliveryTime: json['default_delivery_time'] ?? 24,
      maintenanceMode: json['maintenance_mode'] ?? false,
      supportInfo: Map<String, String>.from(json['support_info'] ?? {}),
    );
  }
}
