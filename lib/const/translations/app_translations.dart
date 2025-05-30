import 'package:ecom_modwir/controllers/language_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {};
}

extension CurrencyTranslation on double {
  String toCurrency([String? languageCode]) {
    final lang =
        languageCode ?? Get.find<LanguageController>().currentLanguage.value;
    final formatter = NumberFormat('#,##0.00');
    final formattedAmount = formatter.format(this);

    if (lang == 'ar') {
      return '$formattedAmount ر.س';
    } else {
      return 'SAR $formattedAmount';
    }
  }
}

extension LocalizedText on Map<String, String>? {
  String localized([String? languageCode]) {
    if (this == null || this!.isEmpty) return '';

    final lang =
        languageCode ?? Get.find<LanguageController>().currentLanguage.value;
    return this![lang] ?? this!['en'] ?? this!.values.first;
  }
}
