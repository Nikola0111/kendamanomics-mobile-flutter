import 'package:flutter/widgets.dart';
import 'package:kendamanomics_mobile/helpers/helper.dart';
import 'package:kendamanomics_mobile/mixins/logger_mixin.dart';
import 'package:kendamanomics_mobile/services/auth_service.dart';
import 'package:kiwi/kiwi.dart';

enum ForgotPasswordPageState { waiting, success, errorEmail }

class ForgotPasswordPageProvider extends ChangeNotifier with LoggerMixin {
  final _authService = KiwiContainer().resolve<AuthService>();
  String _email = '';
  bool _isButtonEnabled = false;
  ForgotPasswordPageState _state = ForgotPasswordPageState.waiting;

  String get email => _email;
  bool get isButtonEnabled => _isButtonEnabled;
  ForgotPasswordPageState get state => _state;

  set email(String value) {
    _email = value;
    _isEmailValid();
  }

  void _isEmailValid() {
    final isValid = Helper.validateEmail(_email) == null;
    if (isValid != _isButtonEnabled) {
      _isButtonEnabled = isValid;
      notifyListeners();
    }
  }

  Future<bool> sendPasswordResetCode() async {
    _state = ForgotPasswordPageState.waiting;
    notifyListeners();
    try {
      await _authService.passwordResetRequest(_email);
      _state = ForgotPasswordPageState.success;
      return true;
    } catch (e) {
      logE('Error requesting password reset with the email: $_email ${e.toString()}');
      _state = ForgotPasswordPageState.errorEmail;
      notifyListeners();
      return false;
    }
  }

  void resetState() {
    _state = ForgotPasswordPageState.waiting;
  }

  @override
  String get className => 'ForgotPasswordPageProvider';
}
