import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:fl_chart/fl_chart.dart';

import 'package:ecom_modwir/controllers/reports_controller.dart';

import 'package:ecom_modwir/constants.dart';

import 'package:ecom_modwir/screens/dashboard/components/header.dart';

class ReportsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final reportsController = Get.put(ReportsController());

    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            const Header(),

            const SizedBox(height: defaultPadding),

            // Report Configuration Panel

            ReportConfigurationPanel(),

            const SizedBox(height: defaultPadding),

            // Report Visualization

            Obx(() {
              if (reportsController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (reportsController.reportData.isEmpty) {
                return const ReportPlaceholder();
              }

              return ReportVisualization(
                reportType: reportsController.selectedReportType.value,
                data: reportsController.reportData,
              );
            }),
          ],
        ),
      ),
    );
  }
}

class ReportConfigurationPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final reportsController = Get.find<ReportsController>();

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
            'Report Configuration',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: defaultPadding),
          Row(
            children: [
              // Report Type

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Report Type'),
                    const SizedBox(height: 8),
                    Obx(() => DropdownButtonFormField<String>(
                          value: reportsController.selectedReportType.value,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            filled: true,
                            fillColor: bgColor,
                          ),
                          items: reportsController.availableReports.entries
                              .map((entry) => DropdownMenuItem(
                                    value: entry.key,
                                    child: Text(entry.value),
                                  ))
                              .toList(),
                          onChanged: (value) =>
                              reportsController.updateReportType(value!),
                        )),
                  ],
                ),
              ),

              const SizedBox(width: defaultPadding),

              // Date Range

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Date Range'),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4),
                        color: bgColor,
                      ),
                      child: Obx(() => Text(
                            '${_formatDate(reportsController.selectedDateRange.value.start)} - ${_formatDate(reportsController.selectedDateRange.value.end)}',
                          )),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: defaultPadding),

              // Format

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Export Format'),
                    const SizedBox(height: 8),
                    Obx(() => DropdownButtonFormField<String>(
                          value: reportsController.selectedFormat.value,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            filled: true,
                            fillColor: bgColor,
                          ),
                          items: [
                            DropdownMenuItem(
                                value: 'json', child: Text('View Online')),
                            DropdownMenuItem(
                                value: 'csv', child: Text('CSV Export')),
                            DropdownMenuItem(
                                value: 'excel', child: Text('Excel Export')),
                            DropdownMenuItem(
                                value: 'pdf', child: Text('PDF Export')),
                          ],
                          onChanged: (value) =>
                              reportsController.updateFormat(value!),
                        )),
                  ],
                ),
              ),

              const SizedBox(width: defaultPadding),

              // Generate Button

              ElevatedButton.icon(
                onPressed: () => reportsController.generateReport(),
                icon: const Icon(Icons.analytics),
                label: Text('Generate Report'),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }
}

class ReportVisualization extends StatelessWidget {
  final String reportType;

  final Map<String, dynamic> data;

  const ReportVisualization({
    Key? key,
    required this.reportType,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (reportType) {
      case 'financial_summary':
        return FinancialReportWidget(data: data);

      case 'customer_analysis':
        return CustomerAnalysisWidget(data: data);

      case 'service_performance':
        return ServicePerformanceWidget(data: data);

      case 'predictive_analytics':
        return PredictiveAnalyticsWidget(data: data);

      default:
        return GenericReportWidget(data: data);
    }
  }
}

class FinancialReportWidget extends StatelessWidget {
  final Map<String, dynamic> data;

  const FinancialReportWidget({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dailyRevenue =
        List<Map<String, dynamic>>.from(data['daily_revenue'] ?? []);

    final kpis = Map<String, dynamic>.from(data['kpis'] ?? {});

    return Column(
      children: [
        // KPI Cards

        Row(
          children: [
            Expanded(
                child: _buildKpiCard('Total Revenue',
                    '\$${kpis['total_revenue']?.toStringAsFixed(2) ?? '0'}')),
            const SizedBox(width: defaultPadding),
            Expanded(
                child: _buildKpiCard(
                    'Total Orders', '${kpis['total_orders'] ?? 0}')),
            const SizedBox(width: defaultPadding),
            Expanded(
                child: _buildKpiCard('Avg Order Value',
                    '\$${kpis['avg_order_value']?.toStringAsFixed(2) ?? '0'}')),
            const SizedBox(width: defaultPadding),
            Expanded(
                child: _buildKpiCard(
                    'Total Customers', '${kpis['total_customers'] ?? 0}')),
          ],
        ),

        const SizedBox(height: defaultPadding),

        // Revenue Chart

        Container(
          height: 400,
          padding: const EdgeInsets.all(defaultPadding),
          decoration: BoxDecoration(
            color: secondaryColor,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Daily Revenue Trend',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: defaultPadding),
              Expanded(
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(show: true),
                    titlesData: FlTitlesData(show: true),
                    borderData: FlBorderData(show: true),
                    lineBarsData: [
                      LineChartBarData(
                        spots: dailyRevenue.asMap().entries.map((entry) {
                          return FlSpot(
                            entry.key.toDouble(),
                            double.parse(
                                entry.value['gross_revenue'].toString()),
                          );
                        }).toList(),
                        isCurved: true,
                        color: primaryColor,
                        barWidth: 3,
                        belowBarData: BarAreaData(
                          show: true,
                          color: primaryColor.withOpacity(0.1),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildKpiCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class ReportPlaceholder extends StatelessWidget {
  const ReportPlaceholder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      padding: const EdgeInsets.all(defaultPadding * 2),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.analytics_outlined, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'Select report parameters and click "Generate Report"',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
