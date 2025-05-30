// lib/widgets/license_plate_widget.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecom_modwir/controllers/language_controller.dart';

class LicensePlateWidget extends StatelessWidget {
  final Map<String, String>? licensePlateData;
  final double? width;
  final double? height;

  const LicensePlateWidget({
    Key? key,
    required this.licensePlateData,
    this.width = 200,
    this.height = 60,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final languageController = Get.find<LanguageController>();

    if (licensePlateData == null || licensePlateData!.isEmpty) {
      return _buildPlaceholderPlate();
    }

    return Obx(() {
      final currentLang = languageController.currentLanguage.value;
      final plateNumber =
          licensePlateData![currentLang] ?? licensePlateData!['en'] ?? 'N/A';

      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Colors.grey[100]!,
            ],
          ),
          border: Border.all(
            color: Colors.black,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Country identifier (top section)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Kingdom of Saudi Arabia identifier
                  Text(
                    currentLang == 'ar' ? 'المملكة العربية السعودية' : 'KSA',
                    style: TextStyle(
                      fontSize: currentLang == 'ar' ? 8 : 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  // Flag or crown symbol
                  Container(
                    width: 20,
                    height: 15,
                    decoration: BoxDecoration(
                      color: Colors.green[800],
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: const Icon(
                      Icons.flag,
                      color: Colors.white,
                      size: 12,
                    ),
                  ),
                ],
              ),
            ),

            // License plate number (main section)
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Center(
                  child: FittedBox(
                    child: Text(
                      plateNumber,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        letterSpacing: currentLang == 'ar' ? 2 : 4,
                        fontFamily: currentLang == 'ar' ? 'Arial' : 'Courier',
                      ),
                      textDirection: currentLang == 'ar'
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                    ),
                  ),
                ),
              ),
            ),

            // Security features (bottom section)
            Container(
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blue[800]!,
                    Colors.blue[600]!,
                    Colors.blue[800]!,
                  ],
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildPlaceholderPlate() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        border: Border.all(color: Colors.grey[400]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: Text(
          'NO PLATE',
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

// Enhanced version for detailed view
class DetailedLicensePlateWidget extends StatelessWidget {
  final Map<String, String>? licensePlateData;
  final String? vehicleMake;
  final String? vehicleModel;
  final int? year;

  const DetailedLicensePlateWidget({
    Key? key,
    required this.licensePlateData,
    this.vehicleMake,
    this.vehicleModel,
    this.year,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue[50]!,
              Colors.white,
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Vehicle info
            if (vehicleMake != null || vehicleModel != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  '${vehicleMake ?? ''} ${vehicleModel ?? ''} ${year ?? ''}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),

            // License plate
            LicensePlateWidget(
              licensePlateData: licensePlateData,
              width: 250,
              height: 80,
            ),

            const SizedBox(height: 16),

            // Language toggle for plate display
            _buildLanguageToggle(),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageToggle() {
    final languageController = Get.find<LanguageController>();

    return Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLanguageButton('EN', 'en', languageController),
            const SizedBox(width: 8),
            _buildLanguageButton('العربية', 'ar', languageController),
          ],
        ));
  }

  Widget _buildLanguageButton(
      String label, String langCode, LanguageController controller) {
    final isSelected = controller.currentLanguage.value == langCode;

    return GestureDetector(
      onTap: () => controller.changeLanguage(langCode),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue[600] : Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
