import 'package:kendamanomics_mobile/services/connectivity_service.dart';
import 'package:kiwi/kiwi.dart';

void initKiwi() {
  KiwiContainer().registerSingleton((container) => ConnectivityService());
}
