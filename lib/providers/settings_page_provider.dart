import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:kendamanomics_mobile/services/auth_service.dart';
import 'package:kendamanomics_mobile/services/environment_service.dart';
import 'package:kendamanomics_mobile/services/logger_service.dart';
import 'package:kiwi/kiwi.dart';
import 'package:path_provider/path_provider.dart';

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

  Future<void> sendSupportRequest() async {
    final path = getLogFilePath();
    File file = File(path);
    Directory tempDir = await getTemporaryDirectory();
    File tempFile = File('${tempDir.path}/logger.txt');
    final smth = file.readAsStringSync();
    final value = file.readAsBytesSync();
    tempFile.writeAsBytesSync(value);

    final MailOptions mailOptions = MailOptions(
      subject: 'Kendamanomics Support Request',
      recipients: [EnvironmentService.supportEmail],
      isHTML: false,
      attachments: [tempFile.path],
    );
    await FlutterMailer.send(mailOptions);
    await clearLogs();
  }

  void logout() {
    _authService.signOut();
  }
}
