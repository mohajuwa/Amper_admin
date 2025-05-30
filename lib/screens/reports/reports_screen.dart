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

class CustomerAnalysisWidget extends StatelessWidget {
  final Map<String, dynamic> data;

  const CustomerAnalysisWidget({Key? key, required this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final customerMetrics =
        Map<String, dynamic>.from(data['customer_metrics'] ?? {});
    final demographicsData =
        List<Map<String, dynamic>>.from(data['demographics'] ?? []);
    final loyaltyData =
        Map<String, dynamic>.from(data['loyalty_metrics'] ?? {});

    return Column(
      children: [
        // Customer KPI Cards
        Row(
          children: [
            Expanded(
                child: _buildKpiCard(
                    'Total Customers',
                    '${customerMetrics['total_customers'] ?? 0}',
                    Icons.people,
                    primaryColor)),
            const SizedBox(width: defaultPadding),
            Expanded(
                child: _buildKpiCard(
                    'New This Month',
                    '${customerMetrics['new_customers_month'] ?? 0}',
                    Icons.person_add,
                    successColor)),
            const SizedBox(width: defaultPadding),
            Expanded(
                child: _buildKpiCard(
                    'Active Users',
                    '${customerMetrics['active_customers'] ?? 0}',
                    Icons.trending_up,
                    warningColor)),
            const SizedBox(width: defaultPadding),
            Expanded(
                child: _buildKpiCard(
                    'Retention Rate',
                    '${loyaltyData['retention_rate'] ?? 0}%',
                    Icons.favorite,
                    Colors.purple)),
          ],
        ),

        const SizedBox(height: defaultPadding),

        // Charts Row
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Customer Growth Chart
            Expanded(
              flex: 2,
              child: Container(
                height: 400,
                padding: const EdgeInsets.all(defaultPadding),
                decoration: BoxDecoration(
                  color: Get.theme.cardColor,
                  borderRadius: BorderRadius.circular(defaultBorderRadius),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Customer Growth Trend',
                      style: Get.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
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
                              spots:
                                  _generateCustomerGrowthSpots(customerMetrics),
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
            ),

            const SizedBox(width: defaultPadding),

            // Customer Demographics
            Expanded(
              child: Container(
                height: 400,
                padding: const EdgeInsets.all(defaultPadding),
                decoration: BoxDecoration(
                  color: Get.theme.cardColor,
                  borderRadius: BorderRadius.circular(defaultBorderRadius),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Customer Demographics',
                      style: Get.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: defaultPadding),
                    Expanded(
                      child: PieChart(
                        PieChartData(
                          sectionsSpace: 2,
                          centerSpaceRadius: 40,
                          sections:
                              _generateDemographicsSections(demographicsData),
                        ),
                      ),
                    ),
                    const SizedBox(height: defaultPadding),
                    ..._buildDemographicsLegend(demographicsData),
                  ],
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: defaultPadding),

        // Customer Loyalty Metrics
        Container(
          padding: const EdgeInsets.all(defaultPadding),
          decoration: BoxDecoration(
            color: Get.theme.cardColor,
            borderRadius: BorderRadius.circular(defaultBorderRadius),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Customer Loyalty & Engagement',
                style: Get.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: defaultPadding),
              Row(
                children: [
                  Expanded(
                      child: _buildLoyaltyMetric(
                    'Average Order Value',
                    '\$${loyaltyData['avg_order_value']?.toStringAsFixed(2) ?? '0.00'}',
                    Icons.attach_money,
                  )),
                  Expanded(
                      child: _buildLoyaltyMetric(
                    'Order Frequency',
                    '${loyaltyData['avg_orders_per_customer']?.toStringAsFixed(1) ?? '0.0'}/month',
                    Icons.repeat,
                  )),
                  Expanded(
                      child: _buildLoyaltyMetric(
                    'Customer Lifetime Value',
                    '\$${loyaltyData['customer_lifetime_value']?.toStringAsFixed(2) ?? '0.00'}',
                    Icons.star,
                  )),
                  Expanded(
                      child: _buildLoyaltyMetric(
                    'Churn Rate',
                    '${loyaltyData['churn_rate'] ?? 0}%',
                    Icons.trending_down,
                  )),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<FlSpot> _generateCustomerGrowthSpots(Map<String, dynamic> metrics) {
    final growthData =
        List<Map<String, dynamic>>.from(metrics['growth_data'] ?? []);
    return growthData.asMap().entries.map((entry) {
      return FlSpot(
        entry.key.toDouble(),
        double.parse(entry.value['total_customers'].toString()),
      );
    }).toList();
  }

  List<PieChartSectionData> _generateDemographicsSections(
      List<Map<String, dynamic>> demographics) {
    final colors = [
      primaryColor,
      successColor,
      warningColor,
      errorColor,
      Colors.purple
    ];

    return demographics.asMap().entries.map((entry) {
      final index = entry.key;
      final demo = entry.value;
      return PieChartSectionData(
        color: colors[index % colors.length],
        value: double.parse(demo['percentage'].toString()),
        title: '${demo['percentage']}%',
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  List<Widget> _buildDemographicsLegend(
      List<Map<String, dynamic>> demographics) {
    final colors = [
      primaryColor,
      successColor,
      warningColor,
      errorColor,
      Colors.purple
    ];

    return demographics.asMap().entries.map((entry) {
      final index = entry.key;
      final demo = entry.value;
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: colors[index % colors.length],
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                demo['category'] ?? 'Unknown',
                style: Get.textTheme.bodySmall,
              ),
            ),
            Text(
              '${demo['count'] ?? 0}',
              style: Get.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildLoyaltyMetric(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Get.theme.brightness == Brightness.dark
            ? Colors.white.withOpacity(0.05)
            : Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: primaryColor, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: Get.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: Get.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildKpiCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: Get.theme.cardColor,
        borderRadius: BorderRadius.circular(defaultBorderRadius),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 24),
              Text(
                value,
                style: Get.textTheme.headlineSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: Get.textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}

// Service Performance Widget
class ServicePerformanceWidget extends StatelessWidget {
  final Map<String, dynamic> data;

  const ServicePerformanceWidget({Key? key, required this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final serviceMetrics =
        Map<String, dynamic>.from(data['service_metrics'] ?? {});
    final topServices =
        List<Map<String, dynamic>>.from(data['top_services'] ?? []);
    final performanceData =
        List<Map<String, dynamic>>.from(data['performance_data'] ?? []);

    return Column(
      children: [
        // Service KPI Cards
        Row(
          children: [
            Expanded(
                child: _buildKpiCard(
                    'Total Services',
                    '${serviceMetrics['total_services'] ?? 0}',
                    Icons.build,
                    primaryColor)),
            const SizedBox(width: defaultPadding),
            Expanded(
                child: _buildKpiCard(
                    'Active Services',
                    '${serviceMetrics['active_services'] ?? 0}',
                    Icons.check_circle,
                    successColor)),
            const SizedBox(width: defaultPadding),
            Expanded(
                child: _buildKpiCard(
                    'Avg Rating',
                    '${serviceMetrics['avg_rating']?.toStringAsFixed(1) ?? '0.0'}',
                    Icons.star,
                    warningColor)),
            const SizedBox(width: defaultPadding),
            Expanded(
                child: _buildKpiCard(
                    'Completion Rate',
                    '${serviceMetrics['completion_rate'] ?? 0}%',
                    Icons.trending_up,
                    Colors.purple)),
          ],
        ),

        const SizedBox(height: defaultPadding),

        // Charts Row
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Service Performance Chart
            Expanded(
              flex: 2,
              child: Container(
                height: 400,
                padding: const EdgeInsets.all(defaultPadding),
                decoration: BoxDecoration(
                  color: Get.theme.cardColor,
                  borderRadius: BorderRadius.circular(defaultBorderRadius),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Service Performance Over Time',
                      style: Get.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: defaultPadding),
                    Expanded(
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: _getMaxPerformanceValue(performanceData),
                          barTouchData: BarTouchData(enabled: false),
                          titlesData: FlTitlesData(show: true),
                          borderData: FlBorderData(show: false),
                          barGroups: _generatePerformanceBars(performanceData),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(width: defaultPadding),

            // Top Services
            Expanded(
              child: Container(
                height: 400,
                padding: const EdgeInsets.all(defaultPadding),
                decoration: BoxDecoration(
                  color: Get.theme.cardColor,
                  borderRadius: BorderRadius.circular(defaultBorderRadius),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Top Performing Services',
                      style: Get.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: defaultPadding),
                    Expanded(
                      child: ListView.builder(
                        itemCount: topServices.length,
                        itemBuilder: (context, index) {
                          final service = topServices[index];
                          return _buildServiceRankItem(service, index + 1);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: defaultPadding),

        // Service Quality Metrics
        Container(
          padding: const EdgeInsets.all(defaultPadding),
          decoration: BoxDecoration(
            color: Get.theme.cardColor,
            borderRadius: BorderRadius.circular(defaultBorderRadius),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Service Quality Metrics',
                style: Get.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: defaultPadding),
              Row(
                children: [
                  Expanded(
                      child: _buildQualityMetric(
                    'Average Response Time',
                    '${serviceMetrics['avg_response_time'] ?? 0} mins',
                    Icons.timer,
                  )),
                  Expanded(
                      child: _buildQualityMetric(
                    'Customer Satisfaction',
                    '${serviceMetrics['satisfaction_score']?.toStringAsFixed(1) ?? '0.0'}/5',
                    Icons.sentiment_satisfied,
                  )),
                  Expanded(
                      child: _buildQualityMetric(
                    'Resolution Rate',
                    '${serviceMetrics['resolution_rate'] ?? 0}%',
                    Icons.check_circle_outline,
                  )),
                  Expanded(
                      child: _buildQualityMetric(
                    'Repeat Customers',
                    '${serviceMetrics['repeat_customer_rate'] ?? 0}%',
                    Icons.repeat,
                  )),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  double _getMaxPerformanceValue(List<Map<String, dynamic>> performanceData) {
    if (performanceData.isEmpty) return 100;
    return performanceData
            .map((data) => double.parse(data['value'].toString()))
            .reduce((a, b) => a > b ? a : b) *
        1.2;
  }

  List<BarChartGroupData> _generatePerformanceBars(
      List<Map<String, dynamic>> performanceData) {
    return performanceData.asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: double.parse(data['value'].toString()),
            color: primaryColor,
            width: 16,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    }).toList();
  }

  Widget _buildServiceRankItem(Map<String, dynamic> service, int rank) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Get.theme.brightness == Brightness.dark
            ? Colors.white.withOpacity(0.05)
            : Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: rank <= 3
                  ? (rank == 1
                      ? Colors.amber
                      : rank == 2
                          ? Colors.grey
                          : Colors.orange)
                  : primaryColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                rank.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service['name'] ?? 'Unknown Service',
                  style: Get.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '${service['orders'] ?? 0} orders',
                  style: Get.textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Text(
            '\$${service['revenue']?.toStringAsFixed(0) ?? '0'}',
            style: Get.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: successColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQualityMetric(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Get.theme.brightness == Brightness.dark
            ? Colors.white.withOpacity(0.05)
            : Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: primaryColor, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: Get.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: Get.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildKpiCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: Get.theme.cardColor,
        borderRadius: BorderRadius.circular(defaultBorderRadius),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 24),
              Text(
                value,
                style: Get.textTheme.headlineSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: Get.textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}

// Predictive Analytics Widget
class PredictiveAnalyticsWidget extends StatelessWidget {
  final Map<String, dynamic> data;

  const PredictiveAnalyticsWidget({Key? key, required this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final predictions = Map<String, dynamic>.from(data['predictions'] ?? {});
    final trends = List<Map<String, dynamic>>.from(data['trends'] ?? []);
    final forecasts = Map<String, dynamic>.from(data['forecasts'] ?? {});

    return Column(
      children: [
        // Prediction Cards
        Row(
          children: [
            Expanded(
                child: _buildPredictionCard(
              'Revenue Forecast (30 days)',
              '\$${forecasts['revenue_30_days']?.toStringAsFixed(0) ?? '0'}',
              '${forecasts['revenue_growth'] ?? 0}%',
              Icons.trending_up,
              successColor,
              true,
            )),
            const SizedBox(width: defaultPadding),
            Expanded(
                child: _buildPredictionCard(
              'Expected Orders',
              '${forecasts['orders_30_days'] ?? 0}',
              '${forecasts['orders_growth'] ?? 0}%',
              Icons.shopping_cart,
              primaryColor,
              true,
            )),
            const SizedBox(width: defaultPadding),
            Expanded(
                child: _buildPredictionCard(
              'Customer Growth',
              '${forecasts['new_customers_30_days'] ?? 0}',
              '${forecasts['customer_growth'] ?? 0}%',
              Icons.people,
              warningColor,
              true,
            )),
            const SizedBox(width: defaultPadding),
            Expanded(
                child: _buildPredictionCard(
              'Churn Risk',
              '${forecasts['churn_risk'] ?? 0}%',
              '${forecasts['churn_change'] ?? 0}%',
              Icons.warning,
              errorColor,
              false,
            )),
          ],
        ),

        const SizedBox(height: defaultPadding),

        // Trend Analysis Chart
        Container(
          height: 400,
          padding: const EdgeInsets.all(defaultPadding),
          decoration: BoxDecoration(
            color: Get.theme.cardColor,
            borderRadius: BorderRadius.circular(defaultBorderRadius),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Trend Analysis & Predictions',
                    style: Get.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.psychology, size: 16, color: primaryColor),
                        const SizedBox(width: 4),
                        Text(
                          'AI Powered',
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: defaultPadding),
              Expanded(
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(show: true),
                    titlesData: FlTitlesData(show: true),
                    borderData: FlBorderData(show: true),
                    lineBarsData: [
                      // Historical data
                      LineChartBarData(
                        spots: _generateHistoricalSpots(trends),
                        isCurved: true,
                        color: primaryColor,
                        barWidth: 3,
                        belowBarData: BarAreaData(
                          show: true,
                          color: primaryColor.withOpacity(0.1),
                        ),
                      ),
                      // Prediction data
                      LineChartBarData(
                        spots: _generatePredictionSpots(trends),
                        isCurved: true,
                        color: warningColor,
                        barWidth: 3,
                        dashArray: [5, 5],
                        belowBarData: BarAreaData(
                          show: true,
                          color: warningColor.withOpacity(0.1),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: defaultPadding),

        // AI Insights
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Key Insights
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(defaultPadding),
                decoration: BoxDecoration(
                  color: Get.theme.cardColor,
                  borderRadius: BorderRadius.circular(defaultBorderRadius),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.lightbulb, color: warningColor),
                        const SizedBox(width: 8),
                        Text(
                          'AI Insights & Recommendations',
                          style: Get.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: defaultPadding),
                    ..._buildInsightsList(predictions),
                  ],
                ),
              ),
            ),

            const SizedBox(width: defaultPadding),

            // Risk Assessment
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(defaultPadding),
                decoration: BoxDecoration(
                  color: Get.theme.cardColor,
                  borderRadius: BorderRadius.circular(defaultBorderRadius),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.security, color: errorColor),
                        const SizedBox(width: 8),
                        Text(
                          'Risk Assessment',
                          style: Get.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: defaultPadding),
                    ..._buildRiskAssessment(predictions),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  List<FlSpot> _generateHistoricalSpots(List<Map<String, dynamic>> trends) {
    return trends
        .where((trend) => trend['type'] == 'historical')
        .toList()
        .asMap()
        .entries
        .map((entry) {
      return FlSpot(
        entry.key.toDouble(),
        double.parse(entry.value['value'].toString()),
      );
    }).toList();
  }

  List<FlSpot> _generatePredictionSpots(List<Map<String, dynamic>> trends) {
    final historicalCount =
        trends.where((trend) => trend['type'] == 'historical').length;
    return trends
        .where((trend) => trend['type'] == 'prediction')
        .toList()
        .asMap()
        .entries
        .map((entry) {
      return FlSpot(
        (historicalCount + entry.key).toDouble(),
        double.parse(entry.value['value'].toString()),
      );
    }).toList();
  }

  List<Widget> _buildInsightsList(Map<String, dynamic> predictions) {
    final insights =
        List<Map<String, dynamic>>.from(predictions['insights'] ?? []);

    return insights.map((insight) {
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Get.theme.brightness == Brightness.dark
              ? Colors.white.withOpacity(0.05)
              : Colors.grey[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
              color: _getInsightColor(insight['priority']).withOpacity(0.3)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 4,
              height: 40,
              decoration: BoxDecoration(
                color: _getInsightColor(insight['priority']),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    insight['title'] ?? 'Insight',
                    style: Get.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    insight['description'] ?? 'No description',
                    style: Get.textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: _getInsightColor(insight['priority']).withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                insight['priority']?.toString().toUpperCase() ?? 'MEDIUM',
                style: TextStyle(
                  color: _getInsightColor(insight['priority']),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  List<Widget> _buildRiskAssessment(Map<String, dynamic> predictions) {
    final risks = List<Map<String, dynamic>>.from(predictions['risks'] ?? []);

    return risks.map((risk) {
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Get.theme.brightness == Brightness.dark
              ? Colors.white.withOpacity(0.05)
              : Colors.grey[50],
          borderRadius: BorderRadius.circular(8),
          border:
              Border.all(color: _getRiskColor(risk['level']).withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  risk['type'] ?? 'Risk',
                  style: Get.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: _getRiskColor(risk['level']).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    risk['level']?.toString().toUpperCase() ?? 'MEDIUM',
                    style: TextStyle(
                      color: _getRiskColor(risk['level']),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: (risk['probability'] ?? 0) / 100,
              backgroundColor: Colors.grey[300],
              valueColor:
                  AlwaysStoppedAnimation<Color>(_getRiskColor(risk['level'])),
            ),
            const SizedBox(height: 4),
            Text(
              '${risk['probability'] ?? 0}% probability',
              style: Get.textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  Color _getInsightColor(String? priority) {
    switch (priority?.toLowerCase()) {
      case 'high':
        return errorColor;
      case 'medium':
        return warningColor;
      case 'low':
        return successColor;
      default:
        return primaryColor;
    }
  }

  Color _getRiskColor(String? level) {
    switch (level?.toLowerCase()) {
      case 'high':
        return errorColor;
      case 'medium':
        return warningColor;
      case 'low':
        return successColor;
      default:
        return Colors.grey;
    }
  }

  Widget _buildPredictionCard(
    String title,
    String value,
    String change,
    IconData icon,
    Color color,
    bool isPositiveGood,
  ) {
    final isPositive =
        change.startsWith('+') || (!change.startsWith('-') && change != '0%');
    final changeColor = isPositiveGood
        ? (isPositive ? successColor : errorColor)
        : (isPositive ? errorColor : successColor);

    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: Get.theme.cardColor,
        borderRadius: BorderRadius.circular(defaultBorderRadius),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 24),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: changeColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isPositive ? Icons.trending_up : Icons.trending_down,
                      size: 12,
                      color: changeColor,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      change,
                      style: TextStyle(
                        color: changeColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: Get.textTheme.headlineSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: Get.textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}

// Generic Report Widget
class GenericReportWidget extends StatelessWidget {
  final Map<String, dynamic> data;

  const GenericReportWidget({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding * 2),
      decoration: BoxDecoration(
        color: Get.theme.cardColor,
        borderRadius: BorderRadius.circular(defaultBorderRadius),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.analytics_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: defaultPadding),
          Text(
            'Report Data',
            style: Get.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: defaultPadding),
          if (data.isNotEmpty) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(defaultPadding),
              decoration: BoxDecoration(
                color: Get.theme.brightness == Brightness.dark
                    ? Colors.white.withOpacity(0.05)
                    : Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Raw Data:',
                    style: Get.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    data.toString(),
                    style: Get.textTheme.bodySmall?.copyWith(
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            Text(
              'No data available for this report type',
              style: Get.textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
