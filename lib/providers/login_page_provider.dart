import 'package:flutter/material.dart';
import 'package:kendamanomics_mobile/helpers/helper.dart';
import 'package:kendamanomics_mobile/mixins/logger_mixin.dart';
import 'package:kendamanomics_mobile/services/auth_service.dart';
import 'package:kiwi/kiwi.dart';

enum LoginState { waiting, success, errorEmail, errorServer }

class LoginPageProvider extends ChangeNotifier with LoggerMixin {
  final _authService = KiwiContainer().resolve<AuthService>();
  String _email = '';
  String _password = '';
  bool _isButtonEnabled = false;
  LoginState _state = LoginState.waiting;

  String get email => _email;
  String get password => _password;
  bool get isButtonEnabled => _isButtonEnabled;
  LoginState get state => _state;

  set email(String value) {
    _email = value;
    _isAllInputValid();
  }

  set password(String value) {
    _password = value;
    _isAllInputValid();
  }

  Future<bool> signIn() async {
    try {
      await _authService.signIn(email, password);
      _state = LoginState.success;
      return true;
    } catch (e) {
      notifyListeners();
      logE('error while signing in: $e');
      return false;
    }
  }

  void _isAllInputValid() {
    final isValid = Helper.validateEmail(_email) == null && Helper.validatePassword(_password) == null;
    if (isValid) {
      if (isValid != _isButtonEnabled) {
        _isButtonEnabled = true;
        notifyListeners();
      }
    } else {
      if (isValid != _isButtonEnabled) {
        _isButtonEnabled = false;
        notifyListeners();
      }
    }
  }

  void resetState() {
    _state = LoginState.waiting;
  }

  @override
  String get className => 'LoginPageProvider';
}
