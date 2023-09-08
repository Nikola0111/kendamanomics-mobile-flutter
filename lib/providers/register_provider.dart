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

  set instagramUsername(String? value) {
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

  set company(String? value) {
    _company = value;
    notifyListeners();
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
    if (Helper.validateEmail(_email) == null && Helper.validatePassword(_password) == null) {}
  }

  void resetState() {
    _state = RegisterState.waiting;
  }

  @override
  String get className => 'RegisterProvider';
}
