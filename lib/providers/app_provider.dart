import 'package:flutter/material.dart';
import 'package:kendamanomics_mobile/mixins/logger_mixin.dart';
import 'package:kendamanomics_mobile/services/appearance_service.dart';
import 'package:kiwi/kiwi.dart';

class AppProvider extends ChangeNotifier with LoggerMixin {
  final _appearanceService = KiwiContainer().resolve<AppearanceService>();
  final bool _isLoaded = true;

  bool get isLoaded => _isLoaded;

  ThemeData getAppThemeData(Brightness systemBrightness) {
    final theme = _appearanceService.buildTheme();
    logI('theme built');
    return theme;
  }

  @override
  String get className => 'AppProvider';
}
