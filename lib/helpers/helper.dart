class Helper {
  static String? validateEmail(String? value) {
    RegExp regex = RegExp(
        r'^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    if (value == null || value.isEmpty || !regex.hasMatch(value)) {
      return 'Incorrect format';
    } else {
      return null;
    }
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty || value.length < 6 || value.length > 20) {
      return 'Incorrect format';
    } else {
      return null;
    }
  }

  static String? validateRepeatPassword(String? value, String? text) {
    if (value == null || value.isEmpty || value != text) {
      return 'Passwords do not match';
    }
    if (value.length < 6 || value.length > 20) {
      return 'Incorrect format';
    }
    return null;
  }

  static String? validateCodes(String? value) {
    if (value == null || value.isEmpty || value.length != 6) {
      return 'Incorrect format';
    } else {
      return null;
    }
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Incorrect';
    } else {
      return null;
    }
  }

  static String? validateLastName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Incorrect';
    } else {
      return null;
    }
  }

  static String? validateCompany(String? value) {
    final regex = RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]');
    if (!regex.hasMatch(value!)) {
      return 'Incorrect input';
    } else {
      return null;
    }
  }

  static String? validateNumbers(String? value) {
    final regex = RegExp(r'^[0-9]+$');
    if (value == null || value.isEmpty || !regex.hasMatch(value)) {
      return 'not correct format';
    }
    final parsed = int.tryParse(value);
    if (parsed == null || parsed > 15) {
      return 'still incorrect';
    }
    return null;
  }
}
