import 'package:flutter/material.dart';
import 'package:kendamanomics_mobile/mixins/logger_mixin.dart';
import 'package:kendamanomics_mobile/services/auth_service.dart';
import 'package:kiwi/kiwi.dart';

enum ChangePasswordState { waiting, success, errorPassword, errorServer }

class ChangePasswordPageProvider extends ChangeNotifier with LoggerMixin {
  final _authService = KiwiContainer().resolve<AuthService>();
  String _verificationCode = '';
  String _newPassword = '';
  String _confirmNewPassword = '';
  ChangePasswordState _state = ChangePasswordState.waiting;
  bool _isButtonEnabled = false;

  String get verificationCode => _verificationCode;
  String get newPassword => _newPassword;
  String get confirmNewPassword => _confirmNewPassword;
  ChangePasswordState get state => _state;
  bool get isButtonEnabled => _isButtonEnabled;

  set newPassword(String value) {
    _newPassword = value;
    notifyListeners();
  }

  set confirmNewPassword(String value) {
    _confirmNewPassword = value;
    notifyListeners();
  }

  set verificationCode(String value) {
    _verificationCode = value;
    notifyListeners();
  }

  void resetState() {
    _state = ChangePasswordState.waiting;
  }

  @override
  String get className => 'ChangePasswordPageProvider';
}
