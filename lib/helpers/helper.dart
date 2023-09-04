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
    if (value == null || value.isEmpty || value.length < 6) {
      return 'Incorrect format';
    } else {
      return null;
    }
  }

  static String? validateRepeatPassword(String? value, String? text) {
    if (value == null || value.isEmpty || value.length < 6) {
      return 'Incorrect format';
    }
    if (text != value) {
      return 'Incorrect format';
    } else {
      return null;
    }
  }

  static String? validateCodes(String? value) {
    if (value == null || value.isEmpty || value.length != 6) {
      return 'Incorrect format';
    } else {
      return null;
    }
  }

  static String? validateName(String? value) {
    final regex = RegExp(r'^[A-Za-z -]+$');
    if (value == null || value.isEmpty || !regex.hasMatch(value)) {
      return 'Incorrect format';
    } else {
      return null;
    }
  }
}
