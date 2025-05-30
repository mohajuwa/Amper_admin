import 'package:ecom_modwir/constants.dart';
import 'package:ecom_modwir/models/vehicle_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddVehicleForm extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _makeController = TextEditingController();
  final _modelController = TextEditingController();
  final _yearController = TextEditingController();
  final _plateEnController = TextEditingController();
  final _plateArController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Add New Vehicle",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: defaultPadding),

          // Make dropdown
          DropdownButtonFormField<int>(
            decoration: InputDecoration(
              labelText: "vehicle_make".tr,
              border: OutlineInputBorder(),
            ),
            items: [
              // Add actual car makes here
              DropdownMenuItem(value: 1, child: Text("Toyota")),
              DropdownMenuItem(value: 2, child: Text("Honda")),
            ],
            validator: (value) => value == null ? "field_required".tr : null,
            onChanged: (value) {},
          ),

          const SizedBox(height: defaultPadding),

          // Model dropdown
          DropdownButtonFormField<int>(
            decoration: InputDecoration(
              labelText: "vehicle_model".tr,
              border: OutlineInputBorder(),
            ),
            items: [
              // Add actual car models here
              DropdownMenuItem(value: 1, child: Text("Camry")),
              DropdownMenuItem(value: 2, child: Text("Corolla")),
            ],
            validator: (value) => value == null ? "field_required".tr : null,
            onChanged: (value) {},
          ),

          const SizedBox(height: defaultPadding),

          // Year
          TextFormField(
            controller: _yearController,
            decoration: InputDecoration(
              labelText: "vehicle_year".tr,
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) return "field_required".tr;
              final year = int.tryParse(value);
              if (year == null ||
                  year < 1900 ||
                  year > DateTime.now().year + 1) {
                return "Invalid year";
              }
              return null;
            },
          ),

          const SizedBox(height: defaultPadding),

          // License plate English
          TextFormField(
            controller: _plateEnController,
            decoration: InputDecoration(
              labelText: "License Plate (English)",
              border: OutlineInputBorder(),
            ),
            validator: (value) =>
                value == null || value.isEmpty ? "field_required".tr : null,
          ),

          const SizedBox(height: defaultPadding),

          // License plate Arabic
          TextFormField(
            controller: _plateArController,
            decoration: InputDecoration(
              labelText: "License Plate (Arabic)",
              border: OutlineInputBorder(),
            ),
            textDirection: TextDirection.rtl,
            validator: (value) =>
                value == null || value.isEmpty ? "field_required".tr : null,
          ),

          const SizedBox(height: defaultPadding * 2),

          // Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Get.back(),
                child: Text("cancel".tr),
              ),
              const SizedBox(width: defaultPadding),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text("save".tr),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Handle form submission
      final vehicleData = {
        'make_id': 1, // Selected make ID
        'model_id': 1, // Selected model ID
        'year': int.parse(_yearController.text),
        'license_plate_number': {
          'en': _plateEnController.text,
          'ar': _plateArController.text,
        },
      };

      // Call API to create vehicle
      Get.back();
      Get.snackbar('Success', 'Vehicle added successfully');
    }
  }
}

class EditVehicleForm extends StatelessWidget {
  final VehicleModel vehicle;
  final _formKey = GlobalKey<FormState>();

  EditVehicleForm({Key? key, required this.vehicle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Edit Vehicle",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: defaultPadding),

          // Pre-populated form fields similar to AddVehicleForm
          // ... implementation details

          Text("Edit functionality to be implemented"),

          const SizedBox(height: defaultPadding * 2),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Get.back(),
                child: Text("cancel".tr),
              ),
              const SizedBox(width: defaultPadding),
              ElevatedButton(
                onPressed: () {
                  Get.back();
                  Get.snackbar('Success', 'Vehicle updated successfully');
                },
                child: Text("save".tr),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
