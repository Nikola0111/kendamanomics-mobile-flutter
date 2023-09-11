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
  }

  void isEmailValid() {
    if (Helper.validateEmail(_email) == null) {
      _isButtonEnabled = true;
      notifyListeners();
    } else {
      _isButtonEnabled = false;
      notifyListeners();
    }
  }

  void resetState() {
    _state = ForgotPasswordPageState.waiting;
  }

  @override
  String get className => 'ForgotPasswordPageProvider';
}
