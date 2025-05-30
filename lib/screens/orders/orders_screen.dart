import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecom_modwir/controllers/orders_controller.dart';
import 'package:ecom_modwir/constants.dart';
import 'package:ecom_modwir/utils/app_utils.dart';
import 'package:ecom_modwir/screens/dashboard/components/header.dart';
import 'package:ecom_modwir/screens/orders/order_detail_screen.dart';
import 'package:ecom_modwir/responsive.dart';

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
            _buildPageHeader(ordersController),

            const SizedBox(height: defaultPadding),

            // Orders summary cards
            _buildOrdersSummaryCards(ordersController),

            const SizedBox(height: defaultPadding),

            // Orders table
            _buildOrdersTable(ordersController, context),
          ],
        ),
      ),
    );
  }

  Widget _buildPageHeader(OrdersController ordersController) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "orders".tr,
              style: Get.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "manage_all_orders".tr,
              style: Get.textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        Row(
          children: [
            // Refresh button
            IconButton(
              onPressed: () => ordersController.loadOrders(),
              icon: const Icon(Icons.refresh),
              tooltip: "refresh".tr,
            ),

            const SizedBox(width: 8),

            // Status filter dropdown
            Obx(() => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButton<String>(
                    value: ordersController.selectedStatus.value,
                    underline: const SizedBox(),
                    items: [
                      DropdownMenuItem(
                          value: 'all', child: Text("all_orders".tr)),
                      DropdownMenuItem(value: '0', child: Text("pending".tr)),
                      DropdownMenuItem(value: '1', child: Text("confirmed".tr)),
                      DropdownMenuItem(
                          value: '2', child: Text("in_progress".tr)),
                      DropdownMenuItem(value: '3', child: Text("completed".tr)),
                      DropdownMenuItem(value: '4', child: Text("cancelled".tr)),
                    ],
                    onChanged: (value) => ordersController.filterOrders(value!),
                  ),
                )),
          ],
        ),
      ],
    );
  }

  Widget _buildOrdersSummaryCards(OrdersController ordersController) {
    return Obx(() {
      final orders = ordersController.orders;
      final pendingCount = orders.where((o) => o.orderStatus == 0).length;
      final confirmedCount = orders.where((o) => o.orderStatus == 1).length;
      final inProgressCount = orders.where((o) => o.orderStatus == 2).length;
      final completedCount = orders.where((o) => o.orderStatus == 3).length;

      return Responsive(
        mobile: _buildSummaryCardsGrid(2, 1.3, [
          _buildSummaryCard('pending_orders'.tr, pendingCount,
              StatusColors.pending, Icons.access_time),
          _buildSummaryCard('confirmed_orders'.tr, confirmedCount, primaryColor,
              Icons.check_circle),
          _buildSummaryCard('in_progress_orders'.tr, inProgressCount,
              StatusColors.inactive, Icons.build),
          _buildSummaryCard('completed_orders'.tr, completedCount,
              StatusColors.completed, Icons.check_circle_outline),
        ]),
        tablet: _buildSummaryCardsGrid(4, 1.2, [
          _buildSummaryCard('pending_orders'.tr, pendingCount,
              StatusColors.pending, Icons.access_time),
          _buildSummaryCard('confirmed_orders'.tr, confirmedCount, primaryColor,
              Icons.check_circle),
          _buildSummaryCard('in_progress_orders'.tr, inProgressCount,
              StatusColors.inactive, Icons.build),
          _buildSummaryCard('completed_orders'.tr, completedCount,
              StatusColors.completed, Icons.check_circle_outline),
        ]),
        desktop: _buildSummaryCardsGrid(4, 1.4, [
          _buildSummaryCard('pending_orders'.tr, pendingCount,
              StatusColors.pending, Icons.access_time),
          _buildSummaryCard('confirmed_orders'.tr, confirmedCount, primaryColor,
              Icons.check_circle),
          _buildSummaryCard('in_progress_orders'.tr, inProgressCount,
              StatusColors.inactive, Icons.build),
          _buildSummaryCard('completed_orders'.tr, completedCount,
              StatusColors.completed, Icons.check_circle_outline),
        ]),
      );
    });
  }

  Widget _buildSummaryCardsGrid(
      int crossAxisCount, double childAspectRatio, List<Widget> cards) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: defaultPadding,
      mainAxisSpacing: defaultPadding,
      childAspectRatio: childAspectRatio,
      children: cards,
    );
  }

  Widget _buildSummaryCard(
      String title, int count, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: Get.theme.cardColor,
        borderRadius: BorderRadius.circular(defaultBorderRadius),
        border: Border.all(color: color.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              Text(
                count.toString(),
                style: Get.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          Text(
            title,
            style: Get.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersTable(
      OrdersController ordersController, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: Get.theme.cardColor,
        borderRadius: BorderRadius.circular(defaultBorderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "recent_orders".tr,
                style: Get.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton.icon(
                onPressed: () => ordersController.loadOrders(),
                icon: const Icon(Icons.refresh, size: 16),
                label: Text("refresh".tr),
              ),
            ],
          ),
          const SizedBox(height: defaultPadding),
          Obx(() {
            if (ordersController.isLoading.value) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(defaultPadding * 2),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (ordersController.filteredOrders.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(defaultPadding * 2),
                  child: Column(
                    children: [
                      Icon(
                        Icons.inbox_outlined,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "no_orders_found".tr,
                        style: Get.textTheme.titleMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth:
                      MediaQuery.of(context).size.width - (defaultPadding * 4),
                ),
                child: DataTable(
                  columnSpacing: defaultPadding,
                  dataRowMaxHeight: 80,
                  columns: [
                    DataColumn(label: Text("order_number".tr)),
                    DataColumn(label: Text("customer".tr)),
                    DataColumn(label: Text("order_date".tr)),
                    DataColumn(label: Text("order_status".tr)),
                    DataColumn(label: Text("payment_status".tr)),
                    DataColumn(label: Text("total_amount".tr)),
                    DataColumn(label: Text("actions".tr)),
                  ],
                  rows: ordersController.filteredOrders.map((order) {
                    return DataRow(
                      onSelectChanged: (_) => _navigateToOrderDetail(order),
                      cells: [
                        DataCell(
                          InkWell(
                            onTap: () => _navigateToOrderDetail(order),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                "#${order.orderNumber}",
                                style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        DataCell(
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                order.userName ?? 'N/A',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500),
                              ),
                              if (order.vendorName != null)
                                Text(
                                  'via ${order.vendorName}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                            ],
                          ),
                        ),
                        DataCell(
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(AppUtils.formatDate(order.orderDate)),
                              Text(
                                AppUtils.formatTime(order.orderDate),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        DataCell(
                            AppUtils.getOrderStatusBadge(order.orderStatus)),
                        DataCell(AppUtils.getPaymentStatusBadge(
                            order.paymentStatus)),
                        DataCell(
                          Text(
                            AppUtils.formatCurrency(order.totalAmount ?? 0),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: successColor,
                            ),
                          ),
                        ),
                        DataCell(
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.visibility, size: 18),
                                onPressed: () => _navigateToOrderDetail(order),
                                tooltip: "view_details".tr,
                              ),
                              PopupMenuButton<int>(
                                onSelected: (status) => ordersController
                                    .updateOrderStatus(order.orderId, status),
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    value: 0,
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 12,
                                          height: 12,
                                          decoration: BoxDecoration(
                                            color: StatusColors.pending,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text("pending".tr),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 1,
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 12,
                                          height: 12,
                                          decoration: BoxDecoration(
                                            color: primaryColor,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text("confirmed".tr),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 2,
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 12,
                                          height: 12,
                                          decoration: BoxDecoration(
                                            color: StatusColors.inactive,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text("in_progress".tr),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 3,
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 12,
                                          height: 12,
                                          decoration: BoxDecoration(
                                            color: StatusColors.completed,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text("completed".tr),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 4,
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 12,
                                          height: 12,
                                          decoration: BoxDecoration(
                                            color: StatusColors.cancelled,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text("cancelled".tr),
                                      ],
                                    ),
                                  ),
                                ],
                                child: const Icon(Icons.more_vert, size: 18),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  void _navigateToOrderDetail(order) {
    Get.to(() => OrderDetailScreen(order: order));
  }
}
