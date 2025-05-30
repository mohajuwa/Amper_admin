import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../constants.dart';

class RecentOrdersTable extends StatelessWidget {
  const RecentOrdersTable({Key? key}) : super(key: key);

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
            "recent_orders".tr,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(
            width: double.infinity,
            child: DataTable(
              columnSpacing: defaultPadding,
              columns: [
                DataColumn(label: Text("order_number".tr)),
                DataColumn(label: Text("customer".tr)),
                DataColumn(label: Text("order_date".tr)),
                DataColumn(label: Text("status".tr)),
                DataColumn(label: Text("total_amount".tr)),
              ],
              rows: _buildDataRows(),
            ),
          ),
        ],
      ),
    );
  }

  List<DataRow> _buildDataRows() {
    // Sample data - replace with real data from controller

    final orders = [
      {
        'number': '#1001',
        'customer': 'Ahmed Ali',
        'date': '2023-12-01',
        'status': 'Completed',
        'amount': '\$250'
      },
      {
        'number': '#1002',
        'customer': 'Sara Mohamed',
        'date': '2023-12-02',
        'status': 'Pending',
        'amount': '\$180'
      },
    ];

    return orders
        .map((order) => DataRow(
              cells: [
                DataCell(Text(order['number']!)),
                DataCell(Text(order['customer']!)),
                DataCell(Text(order['date']!)),
                DataCell(_buildStatusChip(order['status']!)),
                DataCell(Text(order['amount']!)),
              ],
            ))
        .toList();
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
}
