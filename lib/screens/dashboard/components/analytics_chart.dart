import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecom_modwir/constants.dart';

class AnalyticsChart extends StatelessWidget {
  const AnalyticsChart({Key? key}) : super(key: key);

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
            "statistics".tr,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: defaultPadding),
          Container(
            height: 200,
            child: const Center(
              child: Text('Analytics Chart Placeholder'),
            ),
          ),
        ],
      ),
    );
  }
}
