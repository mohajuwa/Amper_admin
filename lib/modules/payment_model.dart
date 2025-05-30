class PaymentModel {
  final int paymentId;
  final int? orderId;
  final double amount;
  final String? paymentMethod;
  final DateTime paymentDate;
  final String paymentStatus;

  PaymentModel({
    required this.paymentId,
    this.orderId,
    required this.amount,
    this.paymentMethod,
    required this.paymentDate,
    required this.paymentStatus,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      paymentId: json['payment_id'],
      orderId: json['order_id'],
      amount: json['amount']?.toDouble() ?? 0.0,
      paymentMethod: json['payment_method'],
      paymentDate: DateTime.parse(json['payment_date']),
      paymentStatus: json['payment_status'],
    );
  }
}
