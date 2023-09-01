import 'package:flutter/material.dart';
import 'package:kendamanomics_mobile/services/appearance_service.dart';
import 'package:kiwi/kiwi.dart';

class AppProvider extends ChangeNotifier {
  final _appearanceService = KiwiContainer().resolve<AppearanceService>();
  final bool _isLoaded = true;

  bool get isLoaded => _isLoaded;

  ThemeData getAppThemeData(Brightness systemBrightness) {
    final theme = _appearanceService.buildTheme();
    return theme;
  }
}
