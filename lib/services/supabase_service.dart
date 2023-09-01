import 'package:kendamanomics_mobile/mixins/logger_mixin.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService with LoggerMixin {
  Future<void> init() async {
    await Supabase.initialize(
      url: 'YOUR_SUPABASE_URL',
      anonKey: 'YOUR_SUPABASE_ANON_KEY',
    );
  }

  @override
  String get className => 'SupabaseService';
}
