import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';

import '../../../controllers/dashboard_controller.dart';

import '../../../responsive.dart';

import '../../../constants.dart';

class StatsCards extends StatelessWidget {
  const StatsCards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dashboardController = Get.find<DashboardController>();

    return Responsive(
      mobile: StatsCardsGridView(
        crossAxisCount: _getCrossAxisCount(context),
        childAspectRatio: _getChildAspectRatio(context),
      ),
      tablet: const StatsCardsGridView(),
      desktop: StatsCardsGridView(
        childAspectRatio: _getDesktopAspectRatio(context),
      ),
    );
  }

  int _getCrossAxisCount(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    if (width < 650) return 2;

    return 4;
  }

  double _getChildAspectRatio(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    if (width < 650 && width > 350) return 1.3;

    return 1;
  }

  double _getDesktopAspectRatio(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return width < 1400 ? 1.1 : 1.4;
  }
}

class StatsCardsGridView extends StatelessWidget {
  const StatsCardsGridView({
    Key? key,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1,
  }) : super(key: key);

  final int crossAxisCount;

  final double childAspectRatio;

  @override
  Widget build(BuildContext context) {
    final dashboardController = Get.find<DashboardController>();

    return Obx(() {
      final stats = dashboardController.dashboardStats.value;

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
        itemBuilder: (context, index) => StatsCard(
          info: _getStatsInfo(stats)[index],
        ),
      );
    });
  }

  List<StatsInfo> _getStatsInfo(stats) {
    return [
      StatsInfo(
        title: "total_users".tr,
        count: stats.totalUsers.toString(),
        svgSrc: "assets/icons/menu_tran.svg",
        color: const Color(0xFF2697FF),
      ),
      StatsInfo(
        title: "total_orders".tr,
        count: stats.totalOrders.toString(),
        svgSrc: "assets/icons/menu_notification.svg",
        color: const Color(0xFFFFA113),
      ),
      StatsInfo(
        title: "total_revenue".tr,
        count: "\$${stats.totalRevenue.toStringAsFixed(0)}",
        svgSrc: "assets/icons/Documents.svg",
        color: const Color(0xFFA4CDFF),
      ),
      StatsInfo(
        title: "pending_orders".tr,
        count: stats.pendingOrders.toString(),
        svgSrc: "assets/icons/menu_task.svg",
        color: const Color(0xFF007EE5),
      ),
    ];
  }
}

class StatsCard extends StatelessWidget {
  const StatsCard({
    Key? key,
    required this.info,
  }) : super(key: key);

  final StatsInfo info;

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
                child: SvgPicture.asset(
                  info.svgSrc,
                  colorFilter: ColorFilter.mode(info.color, BlendMode.srcIn),
                ),
              ),
              const Icon(Icons.more_vert, color: Colors.white54),
            ],
          ),
          Text(
            info.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            info.count,
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

class StatsInfo {
  final String title, count, svgSrc;

  final Color color;

  StatsInfo({
    required this.title,
    required this.count,
    required this.svgSrc,
    required this.color,
  });
}
