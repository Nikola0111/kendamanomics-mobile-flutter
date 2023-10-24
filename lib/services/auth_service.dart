import 'package:kendamanomics_mobile/constants.dart';
import 'package:kendamanomics_mobile/mixins/logger_mixin.dart';
import 'package:kendamanomics_mobile/models/company.dart';
import 'package:kendamanomics_mobile/models/player.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService with LoggerMixin {
  final _supabase = Supabase.instance.client;
  Player? player;
  Company? playerCompany;

  Future<void> signUp(String email, String password) async {
    final ret = await _supabase.auth.signUp(email: email, password: password);
    player = Player.empty(id: ret.user!.id, email: email);
  }

  Future<void> signIn(String email, String password) async {
    await _supabase.auth.signInWithPassword(password: password, email: email);
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
    player = null;
  }

  Future<void> updateData({
    required String firstname,
    required String lastname,
    required int yearsOfPlaying,
    String? instagram,
    String? supportTeamID,
  }) async {
    if (player == null) {
      throw Exception();
    }
    await _supabase.rpc('update_user_data_company', params: {
      'id': player!.id,
      'firstname': firstname,
      'lastname': lastname,
      'supportteamid': supportTeamID,
      'yearsofplaying': yearsOfPlaying,
      'instagram': instagram,
    });
    player = player!.copyWith(
      firstName: firstname,
      lastName: lastname,
      instagram: instagram,
      yearsPlaying: yearsOfPlaying,
    );

    if (supportTeamID != null) {
      final companyJson = await _supabase.from('companies').select().eq('company_id', supportTeamID).single();
      final comp = Company.fromJson(json: companyJson);
      player = player!.copyWith(company: comp);
      playerCompany = comp;
    }
  }

  Future<void> fetchPlayerData() async {
    final id = _supabase.auth.currentUser?.id;
    final response = await _supabase.from('player').select().eq('player_id', id).single();
    if (response.containsKey('player_company_id') && response['player_company_id'] != null) {
      final companyJson = await _supabase.from('companies').select().eq('company_id', response['player_company_id']).single();
      if (companyJson['company_image_url'] != null) {
        companyJson['company_image_url'] =
            _supabase.storage.from(kCompanyBucketID).getPublicUrl(companyJson['company_image_url']);
      }

      response['player_company'] = companyJson;
    }
    player = Player.fromJson(response);
    playerCompany = player?.company;
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

  String? getCurrentUserId() {
    final user = _supabase.auth.currentUser;
    if (user != null) {
      return user.id;
    } else {
      return null;
    }
  }

  void updatePlayerImage(String signedImage) {
    player = player?.copyWith(playerImageUrl: signedImage);
  }

  @override
  String get className => 'AuthService';
}
