import 'package:easy_localization/easy_localization.dart';

class Helper {
  static String? validateEmail(String? value) {
    RegExp regex = RegExp(
        r'^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    if (value == null || value.isEmpty || !regex.hasMatch(value)) {
      return 'helpers.email'.tr();
    } else {
      return null;
    }
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'helpers.password'.tr();
    }
    if (value.length < 6 || value.length > 20) {
      return 'helpers.password_length'.tr();
    } else {
      return null;
    }
  }

  static String? validateRepeatPassword(String? value, String? text) {
    if (value == null || value.isEmpty || value != text) {
      return 'helpers.passwords_dont_match'.tr();
    }
    if (value.length < 6 || value.length > 20) {
      return 'helpers.password_length'.tr();
    }
    return null;
  }

  static String? validateCodes(String? value) {
    if (value == null || value.isEmpty || value.length != 6) {
      return 'helpers.code'.tr();
    } else {
      return null;
    }
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'helpers.name'.tr();
    } else {
      return null;
    }
  }

  static String? validateLastName(String? value) {
    if (value == null || value.isEmpty) {
      return 'helpers.last_name'.tr();
    } else {
      return null;
    }
  }

  static String? validateCompany(String? value) {
    final regex = RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]');
    if (!regex.hasMatch(value!)) {
      return 'helpers.company_name'.tr();
    } else {
      return null;
    }
  }

  static String? validateNumbers(String? value) {
    final regex = RegExp(r'^[0-9]+$');
    if (value == null || value.isEmpty || !regex.hasMatch(value)) {
      return 'helper.years_playing'.tr();
    }
    final parsed = int.tryParse(value);
    if (parsed == null || parsed > 15) {
      return 'helper.years_playing_large'.tr();
    }
    return null;
  }
}
