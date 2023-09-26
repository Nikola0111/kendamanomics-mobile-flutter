import 'package:kendamanomics_mobile/services/appearance_service.dart';
import 'package:kendamanomics_mobile/services/auth_service.dart';
import 'package:kendamanomics_mobile/services/connectivity_service.dart';
import 'package:kendamanomics_mobile/services/environment_service.dart';
import 'package:kendamanomics_mobile/services/persistent_data_service.dart';
import 'package:kendamanomics_mobile/services/router_service.dart';
import 'package:kendamanomics_mobile/services/submission_service.dart';
import 'package:kendamanomics_mobile/services/supabase_service.dart';
import 'package:kendamanomics_mobile/services/tama_service.dart';
import 'package:kiwi/kiwi.dart';

void initKiwi() {
  KiwiContainer().registerSingleton((container) => ConnectivityService());
  KiwiContainer().registerSingleton((container) => RouterService());
  KiwiContainer().registerSingleton((container) => AppearanceService());
  KiwiContainer().registerSingleton((container) => EnvironmentService());
  KiwiContainer().registerSingleton((container) => SupabaseService());
  KiwiContainer().registerSingleton((container) => AuthService());
  KiwiContainer().registerSingleton((container) => PersistentDataService());
  KiwiContainer().registerSingleton((container) => TamaService());
  KiwiContainer().registerSingleton((container) => SubmissionService());
}
