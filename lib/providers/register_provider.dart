import 'package:flutter/material.dart';
import 'package:kendamanomics_mobile/mixins/logger_mixin.dart';

class RegisterProvider extends ChangeNotifier with LoggerMixin {
  String _firstName = '';
  String _lastName = '';
  String _email = '';
  String _instagramUsername = '';
  late int _yearsPlaying;
  String _support = '';
  String _password = '';
  String _confirmPassword = '';

  String get firstName => _firstName;
  String get lastName => _lastName;
  String get email => _email;
  String get instagramUsername => _instagramUsername;
  int get yearsPlaying => _yearsPlaying;
  String get support => _support;
  String get password => _password;
  String get confirmPassword => _confirmPassword;

  set firstName(String value) {
    _firstName = value;
    notifyListeners();
  }

  set lastName(String value) {
    _lastName = value;
    notifyListeners();
  }

  set email(String value) {
    _email = value;
    notifyListeners();
  }

  set instagramUsername(String value) {
    _instagramUsername = value;
    notifyListeners();
  }

  set yearsPlaying(int value) {
    _yearsPlaying = value;
    notifyListeners();
  }

  set password(String value) {
    _password = value;
    notifyListeners();
  }

  set confirmPassword(String value) {
    _confirmPassword = value;
    notifyListeners();
  }

  set support(String value) {
    _support = value;
    notifyListeners();
  }

  @override
  String get className => 'RegisterProvider';
}
