import 'package:ecom_modwir/screens/dashboard/components/side_info_panel.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:ecom_modwir/controllers/dashboard_controller.dart';

import 'package:ecom_modwir/controllers/main_controller.dart';

import 'package:ecom_modwir/responsive.dart';

import 'package:ecom_modwir/constants.dart';

import 'components/header.dart';

import 'components/stats_cards.dart';

import 'components/recent_orders_table.dart';

import 'components/analytics_chart.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dashboardController = Get.put(DashboardController());

    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            const Header(),

            const SizedBox(height: defaultPadding),

            // Stats Cards

            Obx(() {
              if (dashboardController.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return const StatsCards();
            }),

            const SizedBox(height: defaultPadding),

            // Main content area

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      const AnalyticsChart(),
                      const SizedBox(height: defaultPadding),
                      const RecentOrdersTable(),
                      if (Responsive.isMobile(context))
                        const SizedBox(height: defaultPadding),
                    ],
                  ),
                ),
                if (!Responsive.isMobile(context))
                  const SizedBox(width: defaultPadding),
                if (!Responsive.isMobile(context))
                  const Expanded(
                    flex: 2,
                    child: SideInfoPanel(),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
