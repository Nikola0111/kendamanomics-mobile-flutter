import 'package:flutter/material.dart';
import 'package:kendamanomics_mobile/helpers/helper.dart';
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
    _isInputValid();
  }

  set confirmNewPassword(String value) {
    _confirmNewPassword = value;
    _isInputValid();
  }

  set verificationCode(String value) {
    _verificationCode = value;
    _isInputValid();
  }

  Future<bool> verifyOTP(String email) async {
    try {
      await _authService.verifyOTP(_verificationCode, email);
      _state = ChangePasswordState.success;
      return true;
    } catch (e) {
      logE('Error verifying OTP: $email, ${e.toString()}');
      _state = ChangePasswordState.errorServer;
      return false;
    }
  }

  Future<bool> updateUserPassword(String email) async {
    try {
      await _authService.updatePassword(email, _confirmNewPassword);
      _state = ChangePasswordState.success;
      return true;
    } catch (e) {
      logE('Error updating password with the password: $email, ${e.toString()}');
      _state = ChangePasswordState.errorServer;
      return false;
    }
  }

  void _isInputValid() {
    final isValid = Helper.validateCodes(_verificationCode) == null &&
        Helper.validatePassword(_newPassword) == null &&
        Helper.validateRepeatPassword(_confirmNewPassword, _newPassword) == null;
    if (isValid != _isButtonEnabled) {
      _isButtonEnabled = isValid;
      notifyListeners();
    }
  }

  void resetState() {
    _state = ChangePasswordState.waiting;
  }

  @override
  String get className => 'ChangePasswordPageProvider';
}
