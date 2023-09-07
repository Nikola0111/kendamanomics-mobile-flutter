import 'package:kendamanomics_mobile/mixins/logger_mixin.dart';
import 'package:kendamanomics_mobile/services/supabase_service.dart';
import 'package:kiwi/kiwi.dart';

class AuthService with LoggerMixin {
  final _supabase = KiwiContainer().resolve<SupabaseService>().supabase;

  Future<void> signUp(String email, String password) async {
    await _supabase.auth.signUp(email: email, password: password);
  }

  Future<void> signIn(String email, String password) async {
    await _supabase.auth.signInWithPassword(password: password, email: email);
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  @override
  String get className => 'AuthService';
}
