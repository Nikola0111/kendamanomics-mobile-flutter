import 'package:kendamanomics_mobile/mixins/logger_mixin.dart';
import 'package:kendamanomics_mobile/models/submission.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TrickService with LoggerMixin {
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

  @override
  String get className => 'TrickService';
}
