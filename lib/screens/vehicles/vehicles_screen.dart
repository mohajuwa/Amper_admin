import 'package:ecom_modwir/models/vehicle_model.dart';
import 'package:ecom_modwir/screens/vehicles/vehicle_detail_screen.dart';
import 'package:ecom_modwir/widgets/forms/add_vehicle_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/vehicles_controller.dart';
import '../../controllers/language_controller.dart';
import '../../widgets/license_plate_widget.dart';
import '../../constants.dart';
import '../../responsive.dart';
import '../dashboard/components/header.dart';

class VehiclesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vehiclesController = Get.put(VehiclesController());
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
                  "Vehicles",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                ElevatedButton.icon(
                  onPressed: () => _showAddVehicleDialog(),
                  icon: const Icon(Icons.add),
                  label: Text("add_new".tr),
                ),
              ],
            ),

            const SizedBox(height: defaultPadding),

            // Filters row
            Row(
              children: [
                // Search
                Expanded(
                  flex: 2,
                  child: TextField(
                    onChanged: vehiclesController.searchVehicles,
                    decoration: InputDecoration(
                      hintText: "search".tr,
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: secondaryColor,
                    ),
                  ),
                ),

                const SizedBox(width: defaultPadding),

                // Make filter
                Expanded(
                  child: Obx(() => DropdownButtonFormField<int>(
                        value: vehiclesController.selectedMakeId.value == 0
                            ? null
                            : vehiclesController.selectedMakeId.value,
                        decoration: InputDecoration(
                          labelText: "Filter by Make",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: secondaryColor,
                        ),
                        items: [
                          DropdownMenuItem<int>(
                            value: 0,
                            child: Text("All Makes"),
                          ),
                          // Add actual car makes here
                        ],
                        onChanged: (value) =>
                            vehiclesController.filterByMake(value ?? 0),
                      )),
                ),
              ],
            ),

            const SizedBox(height: defaultPadding),

            // Vehicles grid
            Obx(() {
              if (vehiclesController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (vehiclesController.filteredVehicles.isEmpty) {
                return Center(
                  child: Column(
                    children: [
                      const Icon(Icons.directions_car,
                          size: 64, color: Colors.grey),
                      const SizedBox(height: 16),
                      Text("no_data".tr),
                    ],
                  ),
                );
              }

              return Responsive(
                mobile: VehiclesGridView(
                  crossAxisCount: 1,
                  childAspectRatio: 2.5,
                ),
                tablet: VehiclesGridView(
                  crossAxisCount: 2,
                  childAspectRatio: 2.2,
                ),
                desktop: VehiclesGridView(
                  crossAxisCount: 3,
                  childAspectRatio: 2.0,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  void _showAddVehicleDialog() {
    Get.dialog(
      Dialog(
        child: Container(
          width: 500,
          padding: const EdgeInsets.all(defaultPadding),
          child: AddVehicleForm(),
        ),
      ),
    );
  }
}

class VehiclesGridView extends StatelessWidget {
  final int crossAxisCount;
  final double childAspectRatio;

  const VehiclesGridView({
    Key? key,
    required this.crossAxisCount,
    required this.childAspectRatio,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vehiclesController = Get.find<VehiclesController>();

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: vehiclesController.filteredVehicles.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: defaultPadding,
        mainAxisSpacing: defaultPadding,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (context, index) {
        final vehicle = vehiclesController.filteredVehicles[index];
        return VehicleCard(vehicle: vehicle);
      },
    );
  }
}

class VehicleCard extends StatelessWidget {
  final VehicleModel vehicle;

  const VehicleCard({Key? key, required this.vehicle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(
          color: vehicle.status == 1 ? Colors.green : Colors.orange,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Vehicle header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${vehicle.makeName ?? ''} ${vehicle.modelName ?? ''}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (vehicle.year != null)
                      Text(
                        vehicle.year.toString(),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) => _handleMenuAction(value, vehicle),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'view',
                    child: Row(
                      children: [
                        const Icon(Icons.visibility, size: 16),
                        const SizedBox(width: 8),
                        Text("view_details".tr),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        const Icon(Icons.edit, size: 16),
                        const SizedBox(width: 8),
                        Text("edit".tr),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        const Icon(Icons.delete, size: 16, color: Colors.red),
                        const SizedBox(width: 8),
                        Text("delete".tr,
                            style: const TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: defaultPadding),

          // License plate
          Center(
            child: LicensePlateWidget(
              licensePlateData: vehicle.licensePlateNumber,
              width: 180,
              height: 55,
            ),
          ),

          const Spacer(),

          // Status indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: vehicle.status == 1
                  ? Colors.green.withOpacity(0.1)
                  : Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              vehicle.status == 1 ? "active".tr : "inactive".tr,
              style: TextStyle(
                color: vehicle.status == 1 ? Colors.green : Colors.orange,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleMenuAction(String action, VehicleModel vehicle) {
    final vehiclesController = Get.find<VehiclesController>();

    switch (action) {
      case 'view':
        Get.to(() => VehicleDetailScreen(vehicleData: vehicle.toJson()));
        break;
      case 'edit':
        _showEditVehicleDialog(vehicle);
        break;
      case 'delete':
        _confirmDelete(vehicle);
        break;
    }
  }

  void _showEditVehicleDialog(VehicleModel vehicle) {
    Get.dialog(
      Dialog(
        child: Container(
          width: 500,
          padding: const EdgeInsets.all(defaultPadding),
          child: EditVehicleForm(vehicle: vehicle),
        ),
      ),
    );
  }

  void _confirmDelete(VehicleModel vehicle) {
    final vehiclesController = Get.find<VehiclesController>();

    Get.dialog(
      AlertDialog(
        title: Text("confirm".tr),
        content: Text("Are you sure you want to delete this vehicle?"),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text("cancel".tr),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              vehiclesController.deleteVehicle(vehicle.vehicleId);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text("delete".tr),
          ),
        ],
      ),
    );
  }
}
