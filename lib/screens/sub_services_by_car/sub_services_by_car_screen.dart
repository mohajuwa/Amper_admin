import 'package:ecom_modwir/models/sub_service_model.dart';
import 'package:ecom_modwir/utils/app_utils.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../controllers/sub_services_by_car_controller.dart';

import '../../controllers/language_controller.dart';

import '../../constants.dart';

import '../dashboard/components/header.dart';

class SubServicesByCarScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SubServicesByCarController());

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
                  "sub_services_by_car".tr,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                ElevatedButton.icon(
                  onPressed: () => _showAssignServiceDialog(),
                  icon: const Icon(Icons.add),
                  label: Text("Assign Service"),
                ),
              ],
            ),

            const SizedBox(height: defaultPadding),

            // Car make filter

            Container(
              padding: const EdgeInsets.all(defaultPadding),
              decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: Row(
                children: [
                  Text(
                    "Filter by Car Make:",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(width: defaultPadding),
                  Expanded(
                    child: Obx(() => DropdownButton<int>(
                          value: controller.selectedMakeId.value == 0
                              ? null
                              : controller.selectedMakeId.value,
                          hint: const Text("Select Car Make"),
                          isExpanded: true,
                          items: [
                            DropdownMenuItem<int>(
                              value: 0,
                              child: Text("All Makes"),
                            ),
                            ...controller.carMakes
                                .map((make) => DropdownMenuItem<int>(
                                      value: make.makeId,
                                      child: Text(make.getLocalizedName(
                                          languageController
                                              .currentLanguage.value)),
                                    ))
                                .toList(),
                          ],
                          onChanged: (value) =>
                              controller.filterByCarMake(value ?? 0),
                        )),
                  ),
                ],
              ),
            ),

            const SizedBox(height: defaultPadding),

            // Services grid

            Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.filteredSubServices.isEmpty) {
                return Center(
                  child: Column(
                    children: [
                      const Icon(Icons.build, size: 64, color: Colors.grey),
                      const SizedBox(height: 16),
                      Text("no_data".tr),
                    ],
                  ),
                );
              }

              return GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: controller.filteredSubServices.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: _getCrossAxisCount(context),
                  crossAxisSpacing: defaultPadding,
                  mainAxisSpacing: defaultPadding,
                  childAspectRatio: 1.2,
                ),
                itemBuilder: (context, index) {
                  final subService = controller.filteredSubServices[index];

                  return SubServiceByCarCard(
                    subService: subService,
                    languageCode: languageController.currentLanguage.value,
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

  void _showAssignServiceDialog() {
    Get.dialog(
      AlertDialog(
        title: Text("Assign Service to Car"),
        content: Text("Service assignment functionality to be implemented"),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text("cancel".tr),
          ),
          ElevatedButton(
            onPressed: () => Get.back(),
            child: Text("assign".tr),
          ),
        ],
      ),
    );
  }
}

class SubServiceByCarCard extends StatelessWidget {
  final SubServiceModel subService;

  final String languageCode;

  const SubServiceByCarCard({
    Key? key,
    required this.subService,
    required this.languageCode,
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
          // Service header

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  subService.getLocalizedName(languageCode),
                  style: Theme.of(context).textTheme.titleMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                AppUtils.formatCurrency(subService.price),
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),

          const Spacer(),

          // Compatible cars section

          Text(
            "Compatible Cars:",
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),

          const SizedBox(height: 8),

          // Placeholder for compatible car makes

          Wrap(
            spacing: 4,
            children: [
              Chip(
                label: Text("Toyota", style: TextStyle(fontSize: 10)),
                backgroundColor: primaryColor.withOpacity(0.1),
              ),
              Chip(
                label: Text("Honda", style: TextStyle(fontSize: 10)),
                backgroundColor: primaryColor.withOpacity(0.1),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
