import 'package:kendamanomics_mobile/mixins/logger_mixin.dart';
import 'package:kendamanomics_mobile/services/environment_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService with LoggerMixin {
  final supabase = Supabase.instance.client;

  Future<void> init() async {
    await Supabase.initialize(url: EnvironmentService.supabaseApiUrl, anonKey: EnvironmentService.supabaseAnonKey);
  }

  @override
  String get className => 'SupabaseService';
}
