import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:fl_chart/fl_chart.dart';

import 'package:ecom_modwir/controllers/payments_controller.dart';

import 'package:ecom_modwir/constants.dart';

import 'package:ecom_modwir/responsive.dart';

import 'package:ecom_modwir/screens/dashboard/components/header.dart';

import 'package:ecom_modwir/utils/app_utils.dart';

class EnhancedPaymentsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final paymentsController = Get.put(PaymentsController());

    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            const Header(),

            const SizedBox(height: defaultPadding),

            // Payment stats cards

            Obx(() => PaymentStatsCards(controller: paymentsController)),

            const SizedBox(height: defaultPadding),

            // Main content

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      PaymentsTable(),
                      if (Responsive.isMobile(context))
                        const SizedBox(height: defaultPadding),
                      if (Responsive.isMobile(context)) PaymentChart(),
                    ],
                  ),
                ),
                if (!Responsive.isMobile(context))
                  const SizedBox(width: defaultPadding),
                if (!Responsive.isMobile(context))
                  Expanded(
                    flex: 2,
                    child: PaymentChart(),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentStatsCards extends StatelessWidget {
  final PaymentsController controller;

  const PaymentStatsCards({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: PaymentStatsGridView(
        crossAxisCount: 2,
        childAspectRatio: 1.3,
        controller: controller,
      ),
      tablet: PaymentStatsGridView(
        crossAxisCount: 3,
        childAspectRatio: 1.2,
        controller: controller,
      ),
      desktop: PaymentStatsGridView(
        crossAxisCount: 4,
        childAspectRatio: 1.4,
        controller: controller,
      ),
    );
  }
}

class PaymentStatsGridView extends StatelessWidget {
  final int crossAxisCount;

  final double childAspectRatio;

  final PaymentsController controller;

  const PaymentStatsGridView({
    Key? key,
    required this.crossAxisCount,
    required this.childAspectRatio,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 4,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: defaultPadding,
        mainAxisSpacing: defaultPadding,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (context, index) {
        return PaymentStatsCard(
          info: _getStatsInfo(controller)[index],
        );
      },
    );
  }

  List<PaymentStatsInfo> _getStatsInfo(PaymentsController controller) {
    return [
      PaymentStatsInfo(
        title: "Total Revenue",
        amount: controller.totalAmount.value,
        icon: Icons.account_balance_wallet,
        color: const Color(0xFF2697FF),
        trend: "+12.5%",
      ),
      PaymentStatsInfo(
        title: "Completed",
        amount: controller.completedAmount.value,
        icon: Icons.check_circle,
        color: const Color(0xFF00D4AA),
        trend: "+8.2%",
      ),
      PaymentStatsInfo(
        title: "Pending",
        amount: controller.pendingAmount.value,
        icon: Icons.access_time,
        color: const Color(0xFFFFA113),
        trend: "-2.1%",
      ),
      PaymentStatsInfo(
        title: "Failed",
        amount: controller.totalAmount.value -
            controller.completedAmount.value -
            controller.pendingAmount.value,
        icon: Icons.error,
        color: const Color(0xFFEE2727),
        trend: "-15.3%",
      ),
    ];
  }
}

class PaymentStatsCard extends StatelessWidget {
  final PaymentStatsInfo info;

  const PaymentStatsCard({Key? key, required this.info}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(defaultPadding * 0.75),
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: info.color.withOpacity(0.1),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: Icon(
                  info.icon,
                  color: info.color,
                  size: 20,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: info.trend.startsWith('+')
                      ? Colors.green.withOpacity(0.1)
                      : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  info.trend,
                  style: TextStyle(
                    color:
                        info.trend.startsWith('+') ? Colors.green : Colors.red,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Text(
            info.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white70),
          ),
          Text(
            AppUtils.formatCurrency(info.amount),
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}

class PaymentStatsInfo {
  final String title;

  final double amount;

  final IconData icon;

  final Color color;

  final String trend;

  PaymentStatsInfo({
    required this.title,
    required this.amount,
    required this.icon,
    required this.color,
    required this.trend,
  });
}

class PaymentsTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final paymentsController = Get.find<PaymentsController>();

    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "payments".tr,
                style: Theme.of(context).textTheme.titleMedium,
              ),

              // Status filter

              Obx(() => DropdownButton<String>(
                    value: paymentsController.selectedStatus.value,
                    items: [
                      DropdownMenuItem(value: 'all', child: Text("All")),
                      DropdownMenuItem(
                          value: 'completed', child: Text("Completed")),
                      DropdownMenuItem(
                          value: 'pending', child: Text("Pending")),
                      DropdownMenuItem(value: 'failed', child: Text("Failed")),
                    ],
                    onChanged: (value) =>
                        paymentsController.filterPayments(value!),
                  )),
            ],
          ),
          const SizedBox(height: defaultPadding),
          Obx(() {
            if (paymentsController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (paymentsController.filteredPayments.isEmpty) {
              return Center(child: Text("no_data".tr));
            }

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: defaultPadding,
                columns: [
                  DataColumn(label: Text("Payment ID")),
                  DataColumn(label: Text("Order ID")),
                  DataColumn(label: Text("amount".tr)),
                  DataColumn(label: Text("payment_method".tr)),
                  DataColumn(label: Text("payment_date".tr)),
                  DataColumn(label: Text("status".tr)),
                  DataColumn(label: Text("Actions")),
                ],
                rows: paymentsController.filteredPayments.map((payment) {
                  return DataRow(
                    cells: [
                      DataCell(Text("#${payment.paymentId}")),
                      DataCell(Text("#${payment.orderId ?? 'N/A'}")),
                      DataCell(Text(AppUtils.formatCurrency(payment.amount))),
                      DataCell(Text(payment.paymentMethod ?? 'N/A')),
                      DataCell(Text(AppUtils.formatDate(payment.paymentDate))),
                      DataCell(_buildPaymentStatusChip(payment.paymentStatus)),
                      DataCell(
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.visibility, size: 18),
                              onPressed: () => _viewPaymentDetails(payment),
                            ),
                            if (payment.paymentStatus == 'pending')
                              IconButton(
                                icon: const Icon(Icons.check,
                                    size: 18, color: Colors.green),
                                onPressed: () => _markAsCompleted(payment),
                              ),
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
    );
  }

  Widget _buildPaymentStatusChip(String status) {
    Color color;

    switch (status.toLowerCase()) {
      case 'completed':
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
        status.toUpperCase(),
        style:
            TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }

  void _viewPaymentDetails(payment) {
    Get.dialog(
      AlertDialog(
        title: Text("Payment Details"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow("Payment ID:", "#${payment.paymentId}"),
            _buildDetailRow("Order ID:", "#${payment.orderId ?? 'N/A'}"),
            _buildDetailRow("Amount:", AppUtils.formatCurrency(payment.amount)),
            _buildDetailRow("Method:", payment.paymentMethod ?? 'N/A'),
            _buildDetailRow(
                "Date:", AppUtils.formatDateTime(payment.paymentDate)),
            _buildDetailRow("Status:", payment.paymentStatus),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text("Close"),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _markAsCompleted(payment) {
    Get.dialog(
      AlertDialog(
        title: Text("Confirm Payment"),
        content: Text("Mark this payment as completed?"),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text("cancel".tr),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();

              // Handle payment completion

              Get.snackbar('Success', 'Payment marked as completed');
            },
            child: Text("confirm".tr),
          ),
        ],
      ),
    );
  }
}

class PaymentChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Payment Distribution",
            style: Theme.of(context).textTheme.titleMedium,
          ),

          const SizedBox(height: defaultPadding),

          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sectionsSpace: 0,
                centerSpaceRadius: 50,
                startDegreeOffset: -90,
                sections: [
                  PieChartSectionData(
                    color: Colors.green,
                    value: 60,
                    title: '60%',
                    radius: 25,
                    titleStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  PieChartSectionData(
                    color: Colors.orange,
                    value: 25,
                    title: '25%',
                    radius: 22,
                    titleStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  PieChartSectionData(
                    color: Colors.red,
                    value: 15,
                    title: '15%',
                    radius: 19,
                    titleStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: defaultPadding),

          // Legend

          Column(
            children: [
              _buildLegendItem("Completed", Colors.green, "60%"),
              _buildLegendItem("Pending", Colors.orange, "25%"),
              _buildLegendItem("Failed", Colors.red, "15%"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color, String percentage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(label)),
          Text(
            percentage,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
