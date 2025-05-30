class OrderModel {
  final int orderId;
  final int orderNumber;
  final int? userId;
  final int ordersAddress;
  final int? vendorId;
  final int? vehicleId;
  final int? faultTypeId;
  final int orderStatus;
  final int orderType;
  final int? ordersCouponId;
  final int ordersPaymentmethod;
  final int ordersPricedelivery;
  final DateTime orderDate;
  final double? totalAmount;
  final double? workshopAmount;
  final double? appCommission;
  final String paymentStatus;
  final String? notes;
  final String? userName;
  final String? vendorName;
  final String? addressName;

  OrderModel({
    required this.orderId,
    required this.orderNumber,
    this.userId,
    required this.ordersAddress,
    this.vendorId,
    this.vehicleId,
    this.faultTypeId,
    required this.orderStatus,
    required this.orderType,
    this.ordersCouponId,
    required this.ordersPaymentmethod,
    required this.ordersPricedelivery,
    required this.orderDate,
    this.totalAmount,
    this.workshopAmount,
    this.appCommission,
    required this.paymentStatus,
    this.notes,
    this.userName,
    this.vendorName,
    this.addressName,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      orderId: json['order_id'],
      orderNumber: json['order_number'],
      userId: json['user_id'],
      ordersAddress: json['orders_address'],
      vendorId: json['vendor_id'],
      vehicleId: json['vehicle_id'],
      faultTypeId: json['fault_type_id'],
      orderStatus: json['order_status'],
      orderType: json['order_type'],
      ordersCouponId: json['orders_coupon_id'],
      ordersPaymentmethod: json['orders_paymentmethod'],
      ordersPricedelivery: json['orders_pricedelivery'],
      orderDate: DateTime.parse(json['order_date']),
      totalAmount: json['total_amount']?.toDouble(),
      workshopAmount: json['workshop_amount']?.toDouble(),
      appCommission: json['app_commission']?.toDouble(),
      paymentStatus: json['payment_status'],
      notes: json['notes'],
      userName: json['user_name'],
      vendorName: json['vendor_name'],
      addressName: json['address_name'],
    );
  }

  String getStatusText() {
    switch (orderStatus) {
      case 0:
        return 'Pending';
      case 1:
        return 'Confirmed';
      case 2:
        return 'In Progress';
      case 3:
        return 'Completed';
      case 4:
        return 'Cancelled';
      default:
        return 'Unknown';
    }
  }
}
