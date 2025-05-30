import 'package:ecom_modwir/utils/app_utils.dart';
import 'package:get/get.dart';

class Validators {
  static String? required(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'field_required'.tr}';
    }

    return null;
  }

  static String? email(String? value) {
    if (value == null || value.isEmpty) return null;

    if (!AppUtils.isValidEmail(value)) {
      return 'invalid_email'.tr;
    }

    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.isEmpty) return null;

    if (!AppUtils.isValidSaudiPhone(value)) {
      return 'invalid_phone'.tr;
    }

    return null;
  }

  static String? minLength(String? value, int min) {
    if (value == null || value.isEmpty) return null;

    if (value.length < min) {
      return 'min_length'.trParams({'count': min.toString()});
    }

    return null;
  }

  static String? maxLength(String? value, int max) {
    if (value == null || value.isEmpty) return null;

    if (value.length > max) {
      return 'max_length'.trParams({'count': max.toString()});
    }

    return null;
  }

  static String? number(String? value) {
    if (value == null || value.isEmpty) return null;

    if (double.tryParse(value) == null) {
      return 'invalid_number'.tr;
    }

    return null;
  }

  static String? positiveNumber(String? value) {
    final numberError = number(value);

    if (numberError != null) return numberError;

    final numValue = double.parse(value!);

    if (numValue <= 0) {
      return 'must_be_positive'.tr;
    }

    return null;
  }

  static String? price(String? value) {
    final numberError = positiveNumber(value);

    if (numberError != null) return numberError;

    final numValue = double.parse(value!);

    if (numValue > 999999) {
      return 'price_too_high'.tr;
    }

    return null;
  }

  static String? year(String? value) {
    final numberError = number(value);

    if (numberError != null) return numberError;

    final numValue = int.parse(value!);

    final currentYear = DateTime.now().year;

    if (numValue < 1900 || numValue > currentYear + 10) {
      return 'invalid_year'.tr;
    }

    return null;
  }

  static String? url(String? value) {
    if (value == null || value.isEmpty) return null;

    try {
      Uri.parse(value);

      if (!value.startsWith('http://') && !value.startsWith('https://')) {
        return 'invalid_url'.tr;
      }
    } catch (e) {
      return 'invalid_url'.tr;
    }

    return null;
  }
}
