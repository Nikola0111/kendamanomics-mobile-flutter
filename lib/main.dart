import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kendamanomics_mobile/injection_container.dart';
import 'package:kendamanomics_mobile/providers/app_provider.dart';
import 'package:kendamanomics_mobile/services/environment_service.dart';
import 'package:kendamanomics_mobile/services/router_service.dart';
import 'package:kiwi/kiwi.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await EnvironmentService.init();
  initKiwi();

  // await KiwiContainer().resolve<SupabaseService>().init();

  runApp(const KendamanomicsApp());
}

class KendamanomicsApp extends StatelessWidget {
  const KendamanomicsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppProvider>(
      create: (context) => AppProvider(),
      child: Consumer<AppProvider>(
        builder: (context, appProvider, child) {
          if (!appProvider.isLoaded) {
            // show splash screen here if needed
            return const SizedBox.shrink();
          }
          // we can get theme and other app settings from app provider
          final router = KiwiContainer().resolve<RouterService>().router;
          final systemBrightness = Theme.of(context).brightness;
          final themeData = appProvider.getAppThemeData(systemBrightness);
          return EasyLocalization(
            supportedLocales: const [Locale('en')],
            fallbackLocale: const Locale('en'),
            startLocale: const Locale('en'),
            path: 'assets/localization',
            child: Builder(
              builder: (context) {
                return MaterialApp.router(
                  title: 'Kendamanomics',
                  locale: const Locale('en'),
                  theme: themeData,
                  supportedLocales: const [Locale('en')],
                  routerConfig: router,
                  debugShowCheckedModeBanner: false,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
