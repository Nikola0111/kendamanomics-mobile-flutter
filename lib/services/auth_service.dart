import 'package:kendamanomics_mobile/mixins/logger_mixin.dart';
import 'package:kendamanomics_mobile/models/player.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService with LoggerMixin {
  final _supabase = Supabase.instance.client;
  Player? _player;

  Player? get player => _player;

  Future<void> signUp(String email, String password) async {
    final ret = await _supabase.auth.signUp(email: email, password: password);
    _player = Player.empty(id: ret.user!.id, email: email);
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
    // String? supportTeamID,
  }) async {
    if (_player == null) {
      throw Exception();
    }
    await _supabase.rpc('update_user_data', params: {
      'id': _player!.id,
      'firstname': firstname,
      'lastname': lastname,
      //'supportteamid': supportTeamID,
      'yearsofplaying': yearsOfPlaying,
      'instagram': instagram,
    });
    _player = _player!.copyWith(
      firstName: firstname,
      lastName: lastname,
      //supportTeamID: supportTeamID,
      instagram: instagram,
      yearsPlaying: yearsOfPlaying,
    );
  }

  Future<void> fetchPlayerData() async {
    final id = Supabase.instance.client.auth.currentUser?.id;
    final response = await _supabase.from('player').select().eq('player_id', id).single();
    if (response == null) {
      throw response.toString();
    } else {
      _player = Player.fromJson(response);
    }
  }

  Future<void> passwordResetRequest(String email) async {
    await _supabase.auth.resetPasswordForEmail(email);
  }

  Future<void> updatePassword(String email, String newPassword) async {
    await _supabase.auth.updateUser(UserAttributes(password: newPassword));
  }

  Future<void> verifyOTP(String resetToken, String email) async {
    await _supabase.auth.verifyOTP(
      token: resetToken,
      type: OtpType.recovery,
      email: email,
    );
  }

  @override
  String get className => 'AuthService';
}
