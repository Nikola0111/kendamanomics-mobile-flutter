import 'package:kendamanomics_mobile/mixins/logger_mixin.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService with LoggerMixin {
  final _supabase = Supabase.instance.client;

  Future<void> init() async {
    await Supabase.initialize(
      url: 'https://buqvotvxhtoycdcgfivc.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJ1cXZvdHZ4aHRveWNkY2dmaXZjIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTQxMDE0ODksImV4cCI6MjAwOTY3NzQ4OX0.WEwtAg1ozCXT6-etTjfxsV58JvPDF3vX70pQcL__SGU',
    );
  }

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
  String get className => 'SupabaseService';
}
