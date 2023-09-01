import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kendamanomics_mobile/extensions/custom_colors.dart';
import 'package:kendamanomics_mobile/extensions/custom_text_styles.dart';
import 'package:kendamanomics_mobile/mixins/logger_mixin.dart';
import 'package:kendamanomics_mobile/mixins/subscription_mixin.dart';

enum AppThemeMode {
  light('light');

  final String value;

  const AppThemeMode(this.value);

  factory AppThemeMode.from(String value) {
    if (value == light.name) {
      return AppThemeMode.light;
    }
    throw ('theme not found for string: $value');
  }
}

enum AppearanceEvent { themeChanged }

class AppearanceService with SubscriptionMixin<AppearanceEvent>, LoggerMixin {
  AppThemeMode _appTheme = AppThemeMode.light;
  AppThemeMode get appTheme => _appTheme;

  ThemeData buildTheme({
    double? additionalFontSize,
    bool? shouldBoldText,
  }) {
    final ThemeData theme;

    switch (_appTheme) {
      // same code repeated here,
      // but usually we will have some differences between themes
      case AppThemeMode.light:
        const colorScheme = CustomColorScheme.classic();
        final textStyleScheme = CustomTextStyleScheme.fromPrimaryTextColor(primaryTextColor: colorScheme.primaryText!);
        theme = ThemeData(
          brightness: Brightness.light,
          extensions: <ThemeExtension<dynamic>>[colorScheme, textStyleScheme],
          appBarTheme: AppBarTheme(systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: colorScheme.backgroundColor!)),
        );
        break;
    }

    return theme;
  }

  Future<void> switchTheme(AppThemeMode newTheme) async {
    if (_appTheme == newTheme) return;
    _appTheme = newTheme;
    logI('switch theme to: ${_appTheme.value}');
    sendEvent(AppearanceEvent.themeChanged, params: [newTheme]);
  }

  @override
  String get className => 'AppearanceService';
}
