import 'dart:io';

import 'package:flutter/widgets.dart';
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
    try {
      final newImageUrl = await _userService.uploadUserImage(imageFile);
      if (newImageUrl != null) {
        final id = Supabase.instance.client.auth.currentUser?.id;
        await Supabase.instance.client.from('player').upsert(
          {
            'player_id': id,
            'player_image_url': newImageUrl,
          },
        );

        _player = _player?.copyWith(playerImageUrl: newImageUrl);
        _authService.updatePlayerImage(_player!.playerImageUrl!);
        if (_player?.playerImageUrl != null) await getSignedUrl();
      }
      _notify();
    } catch (e) {
      logE('Error uploading user image, ${e.toString}');
    }
  }

  Future<void> getSignedUrl() async {
    try {
      final ret = await _userService.getSignedProfilePictureUrl();
      _signedImageUrl = ret;
    } catch (e) {
      logE('Error getting signed URL: $e');
    }
  }

  Future<void> _fetchPlayerData(String playerId) async {
    try {
      _company = _authService.playerCompany;
      final ret = await _userService.fetchPlayerData(playerId);
      _player = ret;
      _playerName = '${_player!.firstName} ${_player!.lastName}';
      if (_player?.playerImageUrl != null && _player!.playerImageUrl!.isNotEmpty) await getSignedUrl();
      _notify();
    } catch (e) {
      logE('Error fetching  player data: $e');
    }
  }

  void _fetchPlayerBadges(String playerId) async {
    try {
      final ret = await _userService.fetchPlayerBadge(playerId);
      _playerTamas.clear();
      _playerTamas.addAll(ret);
      _state = ProfilePageState.success;
    } catch (e) {
      logE('Error fetching player badges data: $e');
      _state = ProfilePageState.error;
    }
    _notify();
  }

  Future<void> updateCompany(String companyID) async {
    if (_player?.id == null) return;
    try {
      final comp = await _userService.updateCompany(companyID: companyID, playerID: _player!.id);
      _authService.player = _authService.player!.copyWith(company: comp);
      _company = comp;
      _notify();
    } catch (e) {
      logE('error updating company: ${e.toString()}');
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
