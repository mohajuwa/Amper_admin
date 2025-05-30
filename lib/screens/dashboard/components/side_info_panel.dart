import 'package:ecom_modwir/constants.dart';
import 'package:flutter/material.dart';

class SideInfoPanel extends StatelessWidget {
  const SideInfoPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
                "Quick Actions",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: defaultPadding),
              _buildQuickAction("Add New Service", Icons.add),
              _buildQuickAction("View Reports", Icons.analytics),
              _buildQuickAction("Manage Users", Icons.people),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickAction(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: primaryColor, size: 20),
          const SizedBox(width: 12),
          Text(title),
        ],
      ),
    );
  }
}
