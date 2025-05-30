class OrderItemModel {
  final int orderItemId;

  final int orderId;

  final int subServiceId;

  final String itemName;

  final double price;

  final int quantity;

  final double totalPrice;

  OrderItemModel({
    required this.orderItemId,
    required this.orderId,
    required this.subServiceId,
    required this.itemName,
    required this.price,
    required this.quantity,
    required this.totalPrice,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      orderItemId: json['order_item_id'],
      orderId: json['order_id'],
      subServiceId: json['sub_service_id'],
      itemName: json['item_name'],
      price: json['price']?.toDouble() ?? 0.0,
      quantity: json['quantity'],
      totalPrice: json['total_price']?.toDouble() ?? 0.0,
    );
  }
}
