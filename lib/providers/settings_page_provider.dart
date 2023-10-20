import 'package:flutter/material.dart';
import 'package:kendamanomics_mobile/services/auth_service.dart';
import 'package:kiwi/kiwi.dart';

class SettingsPageProvider extends ChangeNotifier {
  final _authService = KiwiContainer().resolve<AuthService>();

  String _playerName = '';
  String? _supportingCompany = '';
  String _instagramUserName = '';
  String _email = '';

  String get playerName => _playerName;
  String? get supportingCompany => _supportingCompany;
  String get instagramUserName => _instagramUserName;
  String get email => _email;

  SettingsPageProvider() {
    _getPlayerData();
  }

  void _getPlayerData() {
    final currentPlayer = _authService.player!;
    _email = currentPlayer.email;
    _playerName = '${currentPlayer.firstName} ${currentPlayer.lastName}';
    _instagramUserName = currentPlayer.instagram!;
    _supportingCompany = currentPlayer.company?.name;
  }
}
