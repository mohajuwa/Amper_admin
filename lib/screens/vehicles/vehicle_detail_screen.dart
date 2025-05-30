import 'package:flutter/material.dart';
import 'package:ecom_modwir/widgets/license_plate_widget.dart';
import 'package:ecom_modwir/constants.dart';

class VehicleDetailScreen extends StatelessWidget {
  final Map<String, dynamic> vehicleData;

  const VehicleDetailScreen({Key? key, required this.vehicleData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vehicle Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            // License Plate Display
            DetailedLicensePlateWidget(
              licensePlateData: vehicleData['license_plate_number'],
              vehicleMake: vehicleData['make_name'],
              vehicleModel: vehicleData['model_name'],
              year: vehicleData['year'],
            ),

            const SizedBox(height: defaultPadding * 2),

            // Vehicle Information Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Vehicle Information',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: defaultPadding),
                    _buildInfoRow('Make:', vehicleData['make_name'] ?? 'N/A'),
                    _buildInfoRow('Model:', vehicleData['model_name'] ?? 'N/A'),
                    _buildInfoRow(
                        'Year:', vehicleData['year']?.toString() ?? 'N/A'),
                    _buildInfoRow('Status:',
                        vehicleData['status'] == 1 ? 'Active' : 'Inactive'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
