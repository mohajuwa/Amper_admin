import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/orders_controller.dart';
import '../../constants.dart';
import '../dashboard/components/header.dart';

class OrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ordersController = Get.put(OrdersController());

    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            const Header(),
            const SizedBox(height: defaultPadding),

            // Page header with filter
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "orders".tr,
                  style: Theme.of(context).textTheme.titleLarge,
                ),

                // Status filter dropdown
                Obx(() => DropdownButton<String>(
                      value: ordersController.selectedStatus.value,
                      items: [
                        DropdownMenuItem(value: 'all', child: Text("All")),
                        DropdownMenuItem(value: '0', child: Text("pending".tr)),
                        DropdownMenuItem(
                            value: '1', child: Text("confirmed".tr)),
                        DropdownMenuItem(
                            value: '2', child: Text("in_progress".tr)),
                        DropdownMenuItem(
                            value: '3', child: Text("completed".tr)),
                        DropdownMenuItem(
                            value: '4', child: Text("cancelled".tr)),
                      ],
                      onChanged: (value) =>
                          ordersController.filterOrders(value!),
                    )),
              ],
            ),

            const SizedBox(height: defaultPadding),

            // Orders table
            Container(
              padding: const EdgeInsets.all(defaultPadding),
              decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "orders".tr,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: defaultPadding),
                  Obx(() {
                    if (ordersController.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (ordersController.filteredOrders.isEmpty) {
                      return Center(child: Text("no_data".tr));
                    }

                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columnSpacing: defaultPadding,
                        columns: [
                          DataColumn(label: Text("order_number".tr)),
                          DataColumn(label: Text("customer".tr)),
                          DataColumn(label: Text("order_date".tr)),
                          DataColumn(label: Text("order_status".tr)),
                          DataColumn(label: Text("payment_status".tr)),
                          DataColumn(label: Text("total_amount".tr)),
                          DataColumn(label: Text("Actions")),
                        ],
                        rows: ordersController.filteredOrders.map((order) {
                          return DataRow(
                            cells: [
                              DataCell(Text("#${order.orderNumber}")),
                              DataCell(Text(order.userName ?? 'N/A')),
                              DataCell(Text(_formatDate(order.orderDate))),
                              DataCell(_buildStatusChip(order.getStatusText())),
                              DataCell(
                                  _buildPaymentStatusChip(order.paymentStatus)),
                              DataCell(Text(
                                  "\$${order.totalAmount?.toStringAsFixed(2) ?? '0.00'}")),
                              DataCell(
                                PopupMenuButton<int>(
                                  onSelected: (status) => ordersController
                                      .updateOrderStatus(order.orderId, status),
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                        value: 0, child: Text("pending".tr)),
                                    PopupMenuItem(
                                        value: 1, child: Text("confirmed".tr)),
                                    PopupMenuItem(
                                        value: 2,
                                        child: Text("in_progress".tr)),
                                    PopupMenuItem(
                                        value: 3, child: Text("completed".tr)),
                                    PopupMenuItem(
                                        value: 4, child: Text("cancelled".tr)),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'completed':
        color = Colors.green;
        break;
      case 'pending':
        color = Colors.orange;
        break;
      case 'cancelled':
        color = Colors.red;
        break;
      case 'confirmed':
        color = Colors.blue;
        break;
      case 'in progress':
        color = Colors.purple;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(color: color, fontSize: 12),
      ),
    );
  }

  Widget _buildPaymentStatusChip(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'paid':
        color = Colors.green;
        break;
      case 'pending':
        color = Colors.orange;
        break;
      case 'failed':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(color: color, fontSize: 12),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }
}
