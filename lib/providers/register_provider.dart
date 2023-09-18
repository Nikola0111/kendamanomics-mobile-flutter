import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kendamanomics_mobile/helpers/helper.dart';
import 'package:kendamanomics_mobile/mixins/logger_mixin.dart';
import 'package:kendamanomics_mobile/services/auth_service.dart';
import 'package:kendamanomics_mobile/widgets/register-shell/register_description.dart';
import 'package:kendamanomics_mobile/widgets/register-shell/register_form.dart';
import 'package:kendamanomics_mobile/widgets/register-shell/register_ranking.dart';
import 'package:kendamanomics_mobile/widgets/register-shell/register_welcome.dart';
import 'package:kiwi/kiwi.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
  String? _supportTeamID;
  String _password = '';
  String _confirmPassword = '';
  int _currentPage = 0;
  bool _isButtonEnabled = false;

  String get firstName => _firstName;
  String get lastName => _lastName;
  String get email => _email;
  String? get instagramUsername => _instagramUsername;
  int get yearsPlaying => _yearsPlaying;
  String? get supportTeamID => _supportTeamID;
  String get password => _password;
  String get confirmPassword => _confirmPassword;
  int get currentPage => _currentPage;
  RegisterState get state => _state;
  bool get isButtonEnabled => _isButtonEnabled;

  set firstName(String value) {
    _firstName = value;
    _isAllInputValid();
  }

  set lastName(String value) {
    _lastName = value;
    _isAllInputValid();
  }

  set email(String value) {
    _email = value;
    _isAllInputValid();
  }

  set instagramUsername(String? value) {
    _instagramUsername = value;
    _isAllInputValid();
  }

  set yearsPlaying(int value) {
    _yearsPlaying = value;
    _isAllInputValid();
  }

  set password(String value) {
    _password = value;
    _isAllInputValid();
  }

  set confirmPassword(String value) {
    _confirmPassword = value;
    _isAllInputValid();
  }

  set supportTeamID(String? value) {
    _supportTeamID = value;
    _isAllInputValid();
  }

  void setCurrentPage(int page) {
    _currentPage = page;
    notifyListeners();
  }

  Future<bool> signUp(String email, String password) async {
    try {
      await _authService.signUp(email, password);
      _state = RegisterState.success;
      return true;
    } on AuthException catch (e) {
      if (e.statusCode == '400') {
        logE(e.message);
        _state = RegisterState.errorEmail;
      } else {
        logE('${'register_provider_errors'.tr()}${e.message}');
        _state = RegisterState.errorServer;
      }
      notifyListeners();

      return false;
    }
  }

  Future<bool> updateData() async {
    try {
      await _authService.updateData(
        firstname: _firstName,
        lastname: _lastName,
        yearsOfPlaying: _yearsPlaying,
        instagram: _instagramUsername,
        //supportTeamID: _supportTeamID,
      );
      return true;
    } on PostgrestException catch (e) {
      logE('${'register_provider_errors'.tr()}${e.message} - code: ${e.code}');
      return false;
    }
  }

  void _isAllInputValid() {
    final isValid = Helper.validateEmail(_email) == null &&
        Helper.validatePassword(_password) == null &&
        Helper.validateRepeatPassword(_confirmPassword, _password) == null &&
        Helper.validateName(_firstName) == null &&
        Helper.validateLastName(_lastName) == null &&
        Helper.validateNumbers(_yearsPlaying.toString()) == null;
    if (isValid != _isButtonEnabled) {
      _isButtonEnabled = isValid;
      notifyListeners();
    }
  }

  void resetState() {
    _state = RegisterState.waiting;
  }

  @override
  String get className => 'RegisterProvider';
}
