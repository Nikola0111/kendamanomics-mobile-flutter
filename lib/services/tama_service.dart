import 'package:kendamanomics_mobile/mixins/logger_mixin.dart';
import 'package:kendamanomics_mobile/models/tama.dart';
import 'package:kendamanomics_mobile/services/auth_service.dart';
import 'package:kendamanomics_mobile/services/persistent_data_service.dart';
import 'package:kiwi/kiwi.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TamaService with LoggerMixin {
  final _authService = KiwiContainer().resolve<AuthService>();
  final _persistantDataService = KiwiContainer().resolve<PersistentDataService>();
  final _supabase = Supabase.instance.client;

  // data returned from rpc is in format {"submission_tama_id":"some_tama_uuid","count":x}. if some tama_id is not in the
  // return data, that means that the user has 0 approved tricks for given tama
  Future<Map<String, int>> getTamasProgress() async {
    final progressData = <String, int>{};

    if (_authService.player?.id != null) {
      final data = await _supabase.rpc('fetch_tamas_progress', params: {'player_id': _authService.player?.id});
      for (var map in data) {
        final id = map['data']['submission_tama_id'];
        final count = map['data']['count'];
        progressData[id] = count;
      }
    }

    return progressData;
  }

  Future<List<Tama>?> fetchTamas() async {
    final uuid = await _supabase.rpc('fetch_data_tracking', params: {'filter_tracking_name': 'tama'});
    if (uuid == _persistantDataService.tamaValue) return null;
    _persistantDataService.tamaValue = uuid;

    logI('fetching new tamas');
    final data = await _supabase.rpc('fetch_all_tamas');

    final tamas = <Tama>[];
    for (final map in data) {
      tamas.add(Tama.fromJson(json: map));
    }
    return tamas;
  }

  @override
  String get className => 'TamaService';
}
