import 'dart:io';

import 'package:kendamanomics_mobile/constants.dart';
import 'package:kendamanomics_mobile/mixins/logger_mixin.dart';
import 'package:kendamanomics_mobile/mixins/subscription_mixin.dart';
import 'package:kendamanomics_mobile/models/company.dart';
import 'package:kendamanomics_mobile/models/player.dart';
import 'package:kendamanomics_mobile/models/player_tama.dart';
import 'package:kendamanomics_mobile/models/tama.dart';
import 'package:kendamanomics_mobile/services/auth_service.dart';
import 'package:kendamanomics_mobile/services/persistent_data_service.dart';
import 'package:kiwi/kiwi.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum UserServiceEvents { imageUploaded }

class UserService with LoggerMixin, SubscriptionMixin<UserServiceEvents> {
  final _persistentDataService = KiwiContainer().resolve<PersistentDataService>();
  final _authService = KiwiContainer().resolve<AuthService>();
  final _supabase = Supabase.instance.client;

  Future<String?> uploadUserImage(File image) async {
    final userId = _supabase.auth.currentUser?.id;
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final uniqueImageName = '$userId/$timestamp';
    final response = await _supabase.storage.from(kUploadUserImageToSupabase).upload(uniqueImageName, image);

    return response;
  }

  Future<String?> getSignedProfilePictureUrl(String? playerImageUrl) async {
    if (playerImageUrl == null) return null;
    final path = playerImageUrl;
    final realPath = path.split('$kUploadUserImageToSupabase/')[1];
    final ret = await _supabase.storage.from(kUploadUserImageToSupabase).createSignedUrl(realPath, 60);

    // sendEvent(UserServiceEvents.imageUploaded);

    return ret;
  }

  Future<String?> getMySignedProfilePictureUrl() async {
    if (_authService.player?.playerImageUrl == null) return null;
    final path = _authService.player?.playerImageUrl;
    final realPath = path!.split('$kUploadUserImageToSupabase/')[1];
    final ret = await _supabase.storage.from(kUploadUserImageToSupabase).createSignedUrl(realPath, 60);

    _authService.updatePlayerImage(ret);
    sendEvent(UserServiceEvents.imageUploaded);

    return ret;
  }

  Future<Player> fetchPlayerData(String playerId) async {
    try {
      final ret = await _supabase.rpc('fetch_player_data', params: {'player_id_arg': playerId});
      // _authService.player = Player.fromJson(ret.first);
      return Player.fromJson(ret.first);
    } catch (e) {
      logE('error fetching player data: ${e.toString()}');
      rethrow;
    }
  }

  Future<Company> fetchCompanyByID(String compID) async {
    final companyJson = await _supabase.from('companies').select().eq('company_id', compID).single();
    if (companyJson['company_image_url'] != null) {
      companyJson['company_image_url'] =
          _supabase.storage.from(kCompanyBucketID).getPublicUrl(companyJson['company_image_url']);
    }

    return Company.fromJson(json: companyJson);
  }

  // TODO when adding payments should fetch badge type
  Future<List<PlayerTama>> fetchPlayerBadge(String playerId) async {
    try {
      final badgeData = await _supabase.rpc('fetch_player_badges', params: {'player_id_param': playerId});
      final tamaIds = badgeData.map((badge) => badge['badge_tama_id'].toString()).toList();
      final matchingTamas = tamaIds.map((tamaId) => _persistentDataService.tamas[tamaId]).toList();

      final playerTamas = <PlayerTama>[];

      for (final (tama as Tama) in matchingTamas) {
        tama.tamaGroupName = _persistentDataService.fetchTamaGroupName(tama.id);
        playerTamas.add(PlayerTama(tama: tama, badgeType: BadgeType.completedTama));
      }
      return playerTamas;
    } catch (e) {
      logE('Error fetching player badges: ${e.toString()}');
      rethrow;
    }
  }

  // TODO refactor
  Future<Company> updateCompany({required String companyID, required String playerID}) async {
    final ret = await _supabase.rpc('update_company_id', params: {
      'selected_player_id': playerID,
      'new_company_id': companyID,
    });
    final comp = Company.fromJson(json: ret[0]);
    _authService.playerCompany = comp;
    return comp;
  }

  void imageUploaded(String? downloadableUrl) {
    if (downloadableUrl != null) _authService.updatePlayerImage(downloadableUrl);
    sendEvent(UserServiceEvents.imageUploaded);
  }

  @override
  String get className => 'UserService';
}
