import 'package:kendamanomics_mobile/mixins/logger_mixin.dart';
import 'package:kendamanomics_mobile/models/submission.dart';
import 'package:kendamanomics_mobile/models/trick.dart';
import 'package:kendamanomics_mobile/services/persistent_data_service.dart';
import 'package:kiwi/kiwi.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TrickService with LoggerMixin {
  final _persistantDataService = KiwiContainer().resolve<PersistentDataService>();
  final _supabase = Supabase.instance.client;

  Future<Map<String, SubmissionStatus>> fetchTrickProgress({required String tamaID}) async {
    final playerID = _supabase.auth.currentUser?.id;
    final data = await _supabase.rpc('fetch_trick_progress', params: {'player_id': playerID, 'tama_id': tamaID});

    final progress = <String, SubmissionStatus>{};

    for (final item in data) {
      final info = item['data'];
      progress[info['submission_trick_id']] = SubmissionStatus.fromString(info['submission_status']);
    }

    return progress;
  }

  Future<List<Trick>?> fetchTricksByTamaID({required String tamaID}) async {
    final uuid = await _supabase.rpc('fetch_data_tracking', params: {'filter_tracking_name': 'trick'});
    if (uuid == _persistantDataService.trickValue) return null;
    _persistantDataService.trickValue = uuid;
    final data = await _supabase.rpc('fetch_tricks_by_tama_id', params: {'filter_tama_id': tamaID});
    if (data == null) return null;

    final newTricks = <Trick>[];
    for (final item in data) {
      newTricks.add(Trick.fromJson(json: item, tamaID: tamaID));
    }

    return newTricks;
  }

  @override
  String get className => 'TrickService';
}
