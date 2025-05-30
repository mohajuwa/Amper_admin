import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecom_modwir/constants.dart';
import 'package:ecom_modwir/models/order_model.dart';
import 'package:ecom_modwir/controllers/orders_controller.dart';
import 'package:ecom_modwir/controllers/language_controller.dart';
import 'package:ecom_modwir/utils/app_utils.dart';
import 'package:ecom_modwir/widgets/license_plate_widget.dart';

class OrderDetailScreen extends StatelessWidget {
  final OrderModel order;
  final bool canEdit;

  const OrderDetailScreen({
    Key? key,
    required this.order,
    this.canEdit = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ordersController = Get.find<OrdersController>();
    final languageController = Get.find<LanguageController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('${'order_details'.tr} #${order.orderNumber}'),
        elevation: 0,
        actions: [
          if (canEdit)
            PopupMenuButton<String>(
              onSelected: (value) =>
                  _handleOrderAction(value, ordersController),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'edit_status',
                  child: Row(
                    children: [
                      const Icon(Icons.edit, size: 16),
                      const SizedBox(width: 8),
                      Text('edit_status'.tr),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'print',
                  child: Row(
                    children: [
                      const Icon(Icons.print, size: 16),
                      const SizedBox(width: 8),
                      Text('print_order'.tr),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'export',
                  child: Row(
                    children: [
                      const Icon(Icons.file_download, size: 16),
                      const SizedBox(width: 8),
                      Text('export_pdf'.tr),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Status Header
            _buildOrderStatusHeader(),

            const SizedBox(height: defaultPadding),

            // Order Information Cards
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      _buildOrderInfoCard(),
                      const SizedBox(height: defaultPadding),
                      _buildCustomerInfoCard(),
                      const SizedBox(height: defaultPadding),
                      _buildVehicleInfoCard(),
                    ],
                  ),
                ),
                const SizedBox(width: defaultPadding),
                Expanded(
                  child: Column(
                    children: [
                      _buildPaymentInfoCard(),
                      const SizedBox(height: defaultPadding),
                      _buildOrderTimelineCard(),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: defaultPadding),

            // Services and Items
            _buildServicesCard(),

            const SizedBox(height: defaultPadding),

            // Order Notes
            if (order.notes != null && order.notes!.isNotEmpty)
              _buildNotesCard(),

            const SizedBox(height: defaultPadding),

            // Action Buttons
            if (canEdit) _buildActionButtons(ordersController),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderStatusHeader() {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            OrderStatus.getStatusColor(order.orderStatus),
            OrderStatus.getStatusColor(order.orderStatus).withOpacity(0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(defaultBorderRadius),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(
              _getStatusIcon(order.orderStatus),
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: defaultPadding),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${'order'.tr} #${order.orderNumber}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  OrderStatus.getStatusText(order.orderStatus).tr,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                AppUtils.formatCurrency(order.totalAmount ?? 0),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                AppUtils.formatDate(order.orderDate),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'order_information'.tr,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: defaultPadding),
            _buildInfoRow('order_number'.tr, '#${order.orderNumber}'),
            _buildInfoRow(
                'order_date'.tr, AppUtils.formatDateTime(order.orderDate)),
            _buildInfoRow('order_type'.tr, _getOrderTypeText(order.orderType)),
            _buildInfoRow('payment_method'.tr,
                _getPaymentMethodText(order.ordersPaymentmethod)),
            _buildInfoRow('delivery_fee'.tr,
                AppUtils.formatCurrency(order.ordersPricedelivery.toDouble())),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.person, color: primaryColor),
                const SizedBox(width: 8),
                Text(
                  'customer_information'.tr,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: defaultPadding),
            _buildInfoRow('customer_name'.tr, order.userName ?? 'N/A'),
            _buildInfoRow('vendor'.tr, order.vendorName ?? 'N/A'),
            _buildInfoRow('address'.tr, order.addressName ?? 'N/A'),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.directions_car, color: primaryColor),
                const SizedBox(width: 8),
                Text(
                  'vehicle_information'.tr,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: defaultPadding),
            if (order.vehicleId != null) ...[
              _buildInfoRow('vehicle_id'.tr, '#${order.vehicleId}'),
              const SizedBox(height: 8),
              // Placeholder for license plate - would need vehicle data
              Center(
                child: Container(
                  padding: const EdgeInsets.all(defaultPadding),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'vehicle_details_loading'.tr,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              ),
            ] else ...[
              Center(
                child: Text(
                  'no_vehicle_assigned'.tr,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.payment, color: primaryColor),
                const SizedBox(width: 8),
                Text(
                  'payment_information'.tr,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: defaultPadding),
            _buildInfoRow('payment_status'.tr, order.paymentStatus),
            if (order.workshopAmount != null)
              _buildInfoRow('workshop_amount'.tr,
                  AppUtils.formatCurrency(order.workshopAmount!)),
            if (order.appCommission != null)
              _buildInfoRow('app_commission'.tr,
                  AppUtils.formatCurrency(order.appCommission!)),
            const Divider(),
            _buildInfoRow(
              'total_amount'.tr,
              AppUtils.formatCurrency(order.totalAmount ?? 0),
              isTotal: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderTimelineCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.timeline, color: primaryColor),
                const SizedBox(width: 8),
                Text(
                  'order_timeline'.tr,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: defaultPadding),
            _buildTimelineItem(
              'order_placed'.tr,
              AppUtils.formatDateTime(order.orderDate),
              true,
            ),
            if (order.orderStatus >= 1)
              _buildTimelineItem(
                'order_confirmed'.tr,
                AppUtils.formatDateTime(order.orderDate),
                true,
              ),
            if (order.orderStatus >= 2)
              _buildTimelineItem(
                'in_progress'.tr,
                AppUtils.formatDateTime(order.orderDate),
                true,
              ),
            if (order.orderStatus >= 3)
              _buildTimelineItem(
                'completed'.tr,
                AppUtils.formatDateTime(order.orderDate),
                true,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildServicesCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.build, color: primaryColor),
                const SizedBox(width: 8),
                Text(
                  'services_items'.tr,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: defaultPadding),
            // Placeholder for services - would need to fetch from API
            Container(
              padding: const EdgeInsets.all(defaultPadding),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  'services_loading'.tr,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.note, color: primaryColor),
                const SizedBox(width: 8),
                Text(
                  'order_notes'.tr,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: defaultPadding),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(defaultPadding),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Text(order.notes!),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(OrdersController ordersController) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _showStatusUpdateDialog(ordersController),
                icon: const Icon(Icons.edit),
                label: Text('update_status'.tr),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: defaultPadding),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _addOrderNote(),
                icon: const Icon(Icons.note_add),
                label: Text('add_note'.tr),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                fontSize: isTotal ? 16 : 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(String title, String time, bool isCompleted) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: isCompleted ? successColor : Colors.grey[300],
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: isCompleted ? null : Colors.grey[600],
                  ),
                ),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getStatusIcon(int status) {
    switch (status) {
      case 0:
        return Icons.access_time;
      case 1:
        return Icons.check_circle;
      case 2:
        return Icons.build;
      case 3:
        return Icons.check_circle_outline;
      case 4:
        return Icons.cancel;
      default:
        return Icons.help;
    }
  }

  String _getOrderTypeText(int type) {
    switch (type) {
      case 0:
        return 'home_service'.tr;
      case 1:
        return 'workshop_service'.tr;
      case 2:
        return 'emergency_service'.tr;
      default:
        return 'unknown'.tr;
    }
  }

  String _getPaymentMethodText(int method) {
    switch (method) {
      case 0:
        return 'cash'.tr;
      case 1:
        return 'card'.tr;
      case 2:
        return 'online'.tr;
      default:
        return 'unknown'.tr;
    }
  }

  void _handleOrderAction(String action, OrdersController ordersController) {
    switch (action) {
      case 'edit_status':
        _showStatusUpdateDialog(ordersController);
        break;
      case 'print':
        AppUtils.showInfo('print_functionality_coming_soon'.tr);
        break;
      case 'export':
        AppUtils.showInfo('export_functionality_coming_soon'.tr);
        break;
    }
  }

  void _showStatusUpdateDialog(OrdersController ordersController) {
    Get.dialog(
      AlertDialog(
        title: Text('update_order_status'.tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (int i = 0; i <= 4; i++)
              ListTile(
                title: Text(OrderStatus.getStatusText(i).tr),
                leading: Radio<int>(
                  value: i,
                  groupValue: order.orderStatus,
                  onChanged: (value) {
                    Get.back();
                    if (value != null && value != order.orderStatus) {
                      ordersController.updateOrderStatus(order.orderId, value);
                    }
                  },
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('cancel'.tr),
          ),
        ],
      ),
    );
  }

  void _addOrderNote() {
    final noteController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: Text('add_order_note'.tr),
        content: TextField(
          controller: noteController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'enter_note'.tr,
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('cancel'.tr),
          ),
          ElevatedButton(
            onPressed: () {
              if (noteController.text.isNotEmpty) {
                // Add note functionality would go here
                Get.back();
                AppUtils.showSuccess('note_added_successfully'.tr);
              }
            },
            child: Text('add'.tr),
          ),
        ],
      ),
    );
  }
}
