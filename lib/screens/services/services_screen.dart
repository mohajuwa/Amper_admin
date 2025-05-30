import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecom_modwir/controllers/services_controller.dart';
import 'package:ecom_modwir/controllers/language_controller.dart';
import 'package:ecom_modwir/constants.dart';
import 'package:ecom_modwir/screens/dashboard/components/header.dart';

class ServicesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final servicesController = Get.put(ServicesController());
    final languageController = Get.find<LanguageController>();

    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            const Header(),
            const SizedBox(height: defaultPadding),

            // Page header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "services".tr,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                ElevatedButton.icon(
                  onPressed: () => _showAddServiceDialog(),
                  icon: const Icon(Icons.add),
                  label: Text("add_service".tr),
                ),
              ],
            ),

            const SizedBox(height: defaultPadding),

            // Services grid
            Obx(() {
              if (servicesController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (servicesController.services.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.inbox, size: 64, color: Colors.grey),
                      const SizedBox(height: 16),
                      Text("no_data".tr),
                    ],
                  ),
                );
              }

              return GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: servicesController.services.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: _getCrossAxisCount(context),
                  crossAxisSpacing: defaultPadding,
                  mainAxisSpacing: defaultPadding,
                  childAspectRatio: 1.2,
                ),
                itemBuilder: (context, index) {
                  final service = servicesController.services[index];
                  return ServiceCard(
                    service: service,
                    languageCode: languageController.currentLanguage.value,
                    onDelete: () =>
                        servicesController.deleteService(service.serviceId),
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  int _getCrossAxisCount(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width > 1200) return 4;
    if (width > 800) return 3;
    if (width > 600) return 2;
    return 1;
  }

  void _showAddServiceDialog() {
    Get.dialog(
      AlertDialog(
        title: Text("add_service".tr),
        content: const Text("Add service functionality to be implemented"),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text("cancel".tr),
          ),
          ElevatedButton(
            onPressed: () => Get.back(),
            child: Text("save".tr),
          ),
        ],
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final service;
  final String languageCode;
  final VoidCallback onDelete;

  const ServiceCard({
    Key? key,
    required this.service,
    required this.languageCode,
    required this.onDelete,
  }) : super(key: key);

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
          // Service image
          Container(
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: service.serviceImg != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      service.serviceImg!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.image, size: 40),
                    ),
                  )
                : const Icon(Icons.build, size: 40, color: primaryColor),
          ),

          const SizedBox(height: 12),

          // Service name
          Text(
            service.getLocalizedName(languageCode),
            style: Theme.of(context).textTheme.titleMedium,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          const Spacer(),

          // Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                service.status == 1 ? "active".tr : "inactive".tr,
                style: TextStyle(
                  color: service.status == 1 ? Colors.green : Colors.orange,
                  fontSize: 12,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, size: 18),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                    onPressed: () => _confirmDelete(context),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: Text("confirm".tr),
        content: Text("Are you sure you want to delete this service?"),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text("cancel".tr),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              onDelete();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text("delete".tr),
          ),
        ],
      ),
    );
  }
}
