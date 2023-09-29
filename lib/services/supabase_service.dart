import 'package:kendamanomics_mobile/mixins/logger_mixin.dart';
import 'package:kendamanomics_mobile/services/environment_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService with LoggerMixin {
  Future<void> init() async {
    try {
      await Supabase.initialize(url: EnvironmentService.supabaseApiUrl, anonKey: EnvironmentService.supabaseAnonKey);
    } catch (e) {
      logE('failed initialization: ${e.toString()}');
    }
  }

  bool checkHasSession() {
    try {
      final session = Supabase.instance.client.auth.currentSession;
      if (session != null) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  @override
  String get className => 'SupabaseService';
}
