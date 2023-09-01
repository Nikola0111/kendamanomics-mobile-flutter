import 'package:flutter/material.dart';
import 'package:kendamanomics_mobile/services/appearance_service.dart';
import 'package:kiwi/kiwi.dart';

class MainPageContainerProvider extends ChangeNotifier {
  final _appearanceService = KiwiContainer().resolve<AppearanceService>();

  ThemeData getAppThemeData(Brightness systemBrightness) {
    final theme = _appearanceService.buildTheme();
    return theme;
  }
}
