import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:kendamanomics_mobile/constants.dart';
import 'package:kendamanomics_mobile/mixins/logger_mixin.dart';
import 'package:kendamanomics_mobile/models/company.dart';
import 'package:kendamanomics_mobile/models/player.dart';
import 'package:kendamanomics_mobile/models/player_tama.dart';
import 'package:kendamanomics_mobile/services/auth_service.dart';
import 'package:kendamanomics_mobile/services/user_service.dart';
import 'package:kiwi/kiwi.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum ProfilePageState { success, waiting, error }

class ProfilePageProvider extends ChangeNotifier with LoggerMixin {
  final _userService = KiwiContainer().resolve<UserService>();
  final _authService = KiwiContainer().resolve<AuthService>();
  final _playerTamas = <PlayerTama>[];
  final String userId;
  Player? _player;
  String? _signedImageUrl;
  String _playerName = '';
  Company? _company;
  ProfilePageState _state = ProfilePageState.waiting;
  bool _isDisposed = false;

  List<PlayerTama> get playerTamas => _playerTamas;
  Player? get player => _player;
  String? get signedImageUrl => _signedImageUrl;
  String get playerName => _playerName;
  Company? get company => _company;
  ProfilePageState get state => _state;

  ProfilePageProvider({required this.userId}) {
    _fetchPlayerData(userId);
    _fetchPlayerBadges(userId);
  }

  bool availableForUpload(String id) {
    final ret = _authService.getCurrentUserId();
    if (ret == userId) {
      return true;
    }
    return false;
  }

  Future<void> uploadUserImage(File imageFile) async {
    logI('updating user image');
    try {
      final newImageUrl = await _userService.uploadUserImage(imageFile);
      if (newImageUrl != null) {
        final id = Supabase.instance.client.auth.currentUser?.id;
        await Supabase.instance.client.from('player').upsert({'player_id': id, 'player_image_url': newImageUrl});

        _player = _player?.copyWith(playerImageUrl: newImageUrl);
        _authService.updatePlayerImage(_player!.playerImageUrl!);
        if (_player?.playerImageUrl != null) await getSignedUrl();
        _userService.imageUploaded(_signedImageUrl);
      }
      logI('user image updated successfully');
      _notify();
    } catch (e) {
      logE('error uploading user image, error: ${e.toString()}');
    }
  }

  Future<void> getSignedUrl() async {
    logI('getting signed url ${_player?.playerImageUrl}');
    try {
      final ret = await _userService.getSignedProfilePictureUrl(_player?.playerImageUrl);
      _signedImageUrl = ret;
      logI('signed url successfully fetched');
    } catch (e) {
      logE('error getting signed URL, error: ${e.toString()}');
    }
  }

  Future<void> _fetchPlayerData(String playerId) async {
    logI('fetching data for player $playerId');
    try {
      final ret = await _userService.fetchPlayerData(playerId);
      _player = ret;
      _playerName = '${_player!.firstName} ${_player!.lastName}';
      if (_player?.playerImageUrl != null && _player!.playerImageUrl!.isNotEmpty) await getSignedUrl();
      if (_player?.companyID != null) _company = await _userService.fetchCompanyByID(_player!.companyID!);

      logI('successfully fetched player data ${_player?.firstName} ${_player?.lastName}');
      _notify();
    } catch (e) {
      logE('Error fetching  player data: $e');
    }
  }

  void _fetchPlayerBadges(String playerId) async {
    logI('fetching badges for player $playerId');
    try {
      final ret = await _userService.fetchPlayerBadge(playerId);
      _playerTamas.clear();
      _playerTamas.addAll(ret);
      _state = ProfilePageState.success;
      logI('successfully fetched ${_playerTamas.length} badges');
    } catch (e) {
      logE('error fetching player badges data, error: ${e.toString()}');
      _state = ProfilePageState.error;
    }
    _notify();
  }

  Future<void> updateCompany(String companyID) async {
    if (_player?.id == null) return;
    logI('updating company from ${_company?.id}: ${_company?.name} to $companyID');
    try {
      Company comp = await _userService.updateCompany(companyID: companyID, playerID: _player!.id);
      if (comp.imageUrl != null) {
        final imageUrl = Supabase.instance.client.storage.from(kCompanyBucketID).getPublicUrl(comp.imageUrl!);
        comp = comp.copyWith(imageUrl: imageUrl);
      }
      _authService.player = _authService.player!.copyWith(company: comp);
      _company = comp;

      logI('successfully updated company to ${_company?.id}: ${_company?.name}');
      _notify();
    } catch (e) {
      logE('error updating company, error: ${e.toString()}');
    }
  }

  void _notify() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  @override
  String get className => 'ProfilePageProvider';
}
