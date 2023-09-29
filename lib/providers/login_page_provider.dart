import 'package:flutter/material.dart';
import 'package:kendamanomics_mobile/helpers/helper.dart';
import 'package:kendamanomics_mobile/mixins/logger_mixin.dart';
import 'package:kendamanomics_mobile/services/auth_service.dart';
import 'package:kiwi/kiwi.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum LoginState { waiting, loading, success, errorCredentials, errorServer }

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
    _state = LoginState.loading;
    notifyListeners();
    try {
      await _authService.signIn(_email, _password);
      await _authService.fetchPlayerData();
      _state = LoginState.success;
      return true;
    } on AuthException catch (e) {
      logE('Error while signing in with the email: $_email ${e.toString()}');
      if (e.statusCode == '400') {
        _state = LoginState.errorCredentials;
      } else {
        _state = LoginState.errorServer;
      }
      notifyListeners();
      return false;
    }
  }

  void _isAllInputValid() {
    final isValid = Helper.validateEmail(_email) == null && Helper.validatePassword(_password) == null;
    if (isValid != _isButtonEnabled) {
      _isButtonEnabled = isValid;
      notifyListeners();
    }
  }

  void resetState() {
    _state = LoginState.waiting;
  }

  @override
  String get className => 'LoginPageProvider';
}
