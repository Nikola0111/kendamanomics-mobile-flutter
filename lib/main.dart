import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kendamanomics_mobile/injection_container.dart';
import 'package:kendamanomics_mobile/pages/login_page.dart';
import 'package:kendamanomics_mobile/pages/tamas_page.dart';
import 'package:kendamanomics_mobile/providers/app_provider.dart';
import 'package:kendamanomics_mobile/services/auth_service.dart';
import 'package:kendamanomics_mobile/services/company_service.dart';
import 'package:kendamanomics_mobile/services/environment_service.dart';
import 'package:kendamanomics_mobile/services/logger_service.dart';
import 'package:kendamanomics_mobile/services/persistent_data_service.dart';
import 'package:kendamanomics_mobile/services/router_service.dart';
import 'package:kendamanomics_mobile/services/supabase_service.dart';
import 'package:kendamanomics_mobile/services/user_service.dart';
import 'package:kiwi/kiwi.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  initKiwi();
  await EnvironmentService.init();

  final supabaseService = KiwiContainer().resolve<SupabaseService>();
  await supabaseService.init();
  KiwiContainer().resolve<CompanyService>();
  KiwiContainer().resolve<LoggerService>();

  await KiwiContainer().resolve<PersistentDataService>().init();

  final hasSession = supabaseService.checkHasSession();
  String initialRoute = LoginPage.pageName;
  if (hasSession) {
    try {
      await KiwiContainer().resolve<AuthService>().fetchPlayerData();
      initialRoute = TamasPage.pageName;
    } catch (e) {
      initialRoute = LoginPage.pageName;
      print('failed fetching player ${e.toString()}');
    }

    try {
      await KiwiContainer().resolve<UserService>().getMySignedProfilePictureUrl();
      initialRoute = TamasPage.pageName;
    } catch (e) {
      initialRoute = LoginPage.pageName;
      print('failed fetching profile image ${e.toString()}');
    }
  }

  KiwiContainer().resolve<RouterService>().init(initialRoute: initialRoute);

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
                  theme: themeData,
                  locale: context.locale,
                  supportedLocales: context.supportedLocales,
                  localizationsDelegates: context.localizationDelegates,
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
