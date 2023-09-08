import 'package:kendamanomics_mobile/mixins/logger_mixin.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService with LoggerMixin {
  final _supabase = Supabase.instance.client;

  Future<void> signUp(String email, String password) async {
    await _supabase.auth.signUp(email: email, password: password);
  }

  Future<void> signIn(String email, String password) async {
    await _supabase.auth.signInWithPassword(password: password, email: email);
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  Future<void> updateData({
    required String firstname,
    required String lastname,
    required int yearsOfPlaying,
    String? instagram,
    String? supportTeamID,
  }) async {
    await _supabase.rpc('update_user_data', params: {
      // 'id': id, uncomment this when we have the id of logged in user
      'firstname': firstname,
      'lastname': lastname,
      'supportteamid': supportTeamID,
      'yearsofplaying': yearsOfPlaying,
      'instagram': instagram,
    });
  }

  @override
  String get className => 'AuthService';
}
