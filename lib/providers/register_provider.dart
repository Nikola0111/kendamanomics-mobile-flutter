import 'package:flutter/material.dart';
import 'package:kendamanomics_mobile/helpers/helper.dart';
import 'package:kendamanomics_mobile/mixins/logger_mixin.dart';
import 'package:kendamanomics_mobile/services/auth_service.dart';
import 'package:kendamanomics_mobile/widgets/register-shell/register_description.dart';
import 'package:kendamanomics_mobile/widgets/register-shell/register_form.dart';
import 'package:kendamanomics_mobile/widgets/register-shell/register_ranking.dart';
import 'package:kendamanomics_mobile/widgets/register-shell/register_welcome.dart';
import 'package:kiwi/kiwi.dart';

enum RegisterState { waiting, success, errorEmail, errorServer }

class RegisterProvider extends ChangeNotifier with LoggerMixin {
  final _authService = KiwiContainer().resolve<AuthService>();
  List<Widget> pages = [
    const RegisterWelcome(),
    const RegisterDescription(),
    const RegisterRanking(),
    const RegisterForm(),
  ];

  RegisterState _state = RegisterState.waiting;
  String _firstName = '';
  String _lastName = '';
  String _email = '';
  String? _instagramUsername;
  int _yearsPlaying = -1;
  String? _company;
  String _password = '';
  String _confirmPassword = '';
  int _currentPage = 0;
  bool _isButtonEnabled = false;

  String get firstName => _firstName;
  String get lastName => _lastName;
  String get email => _email;
  String? get instagramUsername => _instagramUsername;
  int get yearsPlaying => _yearsPlaying;
  String? get company => _company;
  String get password => _password;
  String get confirmPassword => _confirmPassword;
  int get currentPage => _currentPage;
  RegisterState get state => _state;
  bool get isButtonEnabled => _isButtonEnabled;

  set firstName(String value) {
    _firstName = value;
    isAllInputValid();
  }

  set lastName(String value) {
    _lastName = value;
    isAllInputValid();
  }

  set email(String value) {
    _email = value;
    isAllInputValid();
  }

  set instagramUsername(String? value) {
    _instagramUsername = value;
    isAllInputValid();
  }

  set yearsPlaying(int value) {
    _yearsPlaying = value;
    isAllInputValid();
  }

  set password(String value) {
    _password = value;
    isAllInputValid();
  }

  set confirmPassword(String value) {
    _confirmPassword = value;
    isAllInputValid();
  }

  set company(String? value) {
    _company = value;
    isAllInputValid();
  }

  void setCurrentPage(int page) {
    _currentPage = page;
    notifyListeners();
  }

  Future<void> signUp(String email, String password) async {
    try {
      await _authService.signUp(email, password);
      _state = RegisterState.success;
    } catch (e) {
      logE('error while signing up: $e');
      notifyListeners();
    }
  }

  void isAllInputValid() {
    if (Helper.validateEmail(_email) == null &&
        Helper.validatePassword(_password) == null &&
        Helper.validateRepeatPassword(_confirmPassword, _password) == null &&
        Helper.validateName(_firstName) == null &&
        Helper.validateLastName(_lastName) == null &&
        Helper.validateNumbers(_yearsPlaying.toString()) == null) {
      notifyListeners();
      _isButtonEnabled = true;
    } else {
      notifyListeners();
      _isButtonEnabled = false;
    }
  }

  void resetState() {
    _state = RegisterState.waiting;
  }

  @override
  String get className => 'RegisterProvider';
}
