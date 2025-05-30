// lib/screens/customers/customers_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/users_controller.dart';
import '../../constants.dart';
import '../../responsive.dart';
import '../dashboard/components/header.dart';

class CustomersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final usersController = Get.put(UsersController());

    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            const Header(),
            const SizedBox(height: defaultPadding),

            // Page header with actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "customers".tr,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                ElevatedButton.icon(
                  onPressed: () => usersController.loadUsers(),
                  icon: const Icon(Icons.refresh),
                  label: Text("refresh".tr),
                ),
              ],
            ),

            const SizedBox(height: defaultPadding),

            // Search bar
            Container(
              padding: const EdgeInsets.all(defaultPadding),
              decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: TextField(
                onChanged: usersController.searchUsers,
                decoration: InputDecoration(
                  hintText: "search".tr,
                  prefixIcon: const Icon(Icons.search),
                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(height: defaultPadding),

            // Users table
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
                    "customers".tr,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: defaultPadding),
                  Obx(() {
                    if (usersController.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (usersController.filteredUsers.isEmpty) {
                      return Center(
                        child: Text("no_data".tr),
                      );
                    }

                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columnSpacing: defaultPadding,
                        columns: [
                          DataColumn(label: Text("user_name".tr)),
                          DataColumn(label: Text("phone_number".tr)),
                          DataColumn(label: Text("status".tr)),
                          DataColumn(label: Text("created_at".tr)),
                          DataColumn(label: Text("Actions")),
                        ],
                        rows: usersController.filteredUsers.map((user) {
                          return DataRow(
                            cells: [
                              DataCell(Text(user.fullName)),
                              DataCell(Text(user.phone ?? 'N/A')),
                              DataCell(_buildStatusChip(user.status)),
                              DataCell(Text(_formatDate(user.createdAt))),
                              DataCell(
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit, size: 18),
                                      onPressed: () => _editUser(user.userId),
                                    ),
                                    PopupMenuButton<String>(
                                      onSelected: (value) => usersController
                                          .updateUserStatus(user.userId, value),
                                      itemBuilder: (context) => [
                                        PopupMenuItem(
                                          value: 'active',
                                          child: Text("active".tr),
                                        ),
                                        PopupMenuItem(
                                          value: 'inactive',
                                          child: Text("inactive".tr),
                                        ),
                                        PopupMenuItem(
                                          value: 'banned',
                                          child: Text("banned".tr),
                                        ),
                                      ],
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'active':
        color = Colors.green;
        break;
      case 'inactive':
        color = Colors.orange;
        break;
      case 'banned':
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
        status.tr,
        style: TextStyle(color: color, fontSize: 12),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  void _editUser(int userId) {
    // Implement edit user functionality
    Get.snackbar("Info", "Edit user functionality to be implemented");
  }
}
