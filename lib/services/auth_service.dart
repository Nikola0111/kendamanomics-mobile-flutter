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

  @override
  String get className => 'AuthService';
}
