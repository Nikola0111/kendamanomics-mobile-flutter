import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:kendamanomics_mobile/constants.dart';
import 'package:kendamanomics_mobile/mixins/logger_mixin.dart';
import 'package:kendamanomics_mobile/mixins/subscription_mixin.dart';
import 'package:kendamanomics_mobile/models/submission.dart';
import 'package:kendamanomics_mobile/models/submission_log.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum SubmissionServiceEvent { submissionStatusChanged, submissionLogsFetched }

class SubmissionService with LoggerMixin, SubscriptionMixin<SubmissionServiceEvent> {
  final _supabase = Supabase.instance.client;
  final _currentSubmissionLogs = <SubmissionLog>[];

  List<SubmissionLog> get currentSubmissionLogs => _currentSubmissionLogs;

  Future<String?> uploadVideoFile({required File videoFile, required String trickName}) async {
    String path = '';
    final userID = _supabase.auth.currentUser?.id;
    final videoName = _formatFileName(trickName);
    if (_supabase.auth.currentUser?.id != null) {
      path = await _supabase.storage.from(kVideoUploadBucketID).upload(
            '$userID/$videoName',
            videoFile,
            fileOptions: const FileOptions(cacheControl: '3600', contentType: 'video/mp4', upsert: false),
          );
    }
    return path;
  }

  Future<void> removeVideoFromStorage({required String videoName}) async {
    final realPath = videoName.split('$kVideoUploadBucketID/')[1];
    await _supabase.storage.from(kVideoUploadBucketID).remove([realPath]);
  }

  Future<Submission> checkForActiveSubmission({
    required String trickID,
    required String tamaID,
  }) async {
    final playerID = _supabase.auth.currentUser?.id;
    Submission submission = Submission();
    final ret = await _supabase.rpc('fetch_active_submission', params: {
      'player_id': playerID,
      'tama_id': tamaID,
      'trick_id': trickID,
    });

    if (ret.isNotEmpty) {
      final json = ret.first['data'];
      submission = Submission.fromJson(json: json);
    }

    return submission;
  }

  Future<String> createSubmission({
    required String playerID,
    required String trickID,
    required String tamaID,
    required String videoUrl,
  }) async {
    final ret = await _supabase.rpc(
      'create_new_submission',
      params: {
        'player_id': playerID,
        'tama_id': tamaID,
        'trick_id': trickID,
        'video_url': videoUrl,
      },
    );

    _addSubmissionLog(status: SubmissionStatus.inReview);
    return ret;
  }

  Future<void> updateSubmissionData({required String submissionID, required SubmissionStatus status}) async {
    final playerID = _supabase.auth.currentUser?.id;
    await _supabase.rpc('update_submission', params: {'sub_id': submissionID, 'status': status.value, 'player_id': playerID});
    _addSubmissionLog(status: status);
  }

  Future<String> getSignedUrl(String path) async {
    final realPath = path.split('$kVideoUploadBucketID/')[1];
    final ret = await _supabase.storage.from(kVideoUploadBucketID).createSignedUrl(realPath, 60);

    return ret;
  }

  String _formatFileName(String name) {
    final tempUnderscores = name.replaceAll(' ', '_');
    final newName = tempUnderscores.replaceAll('-', '_');

    return newName;
  }

  Future<List<SubmissionLog>> fetchSubmissionLogs({required String tamaID, required trickID}) async {
    final playerID = _supabase.auth.currentUser?.id;
    final ret = await _supabase.rpc('fetch_submission_logs', params: {
      'player_id': playerID,
      'tama_id': tamaID,
      'trick_id': trickID,
    });
    _currentSubmissionLogs.clear();
    final deniedList = [
      SubmissionStatus.deniedIncorrectTrick,
      SubmissionStatus.deniedInappropriateBehaviour,
      SubmissionStatus.deniedTooLong,
      SubmissionStatus.deniedOutOfFrame,
    ];
    for (int i = 0; i < ret.length; i++) {
      final log = SubmissionLog.fromJson(json: ret[i]);
      if (deniedList.contains(log.status)) _currentSubmissionLogs.add(log.copyWith(newStatus: SubmissionStatus.denied));
      _currentSubmissionLogs.add(log);
    }

    sendEvent(SubmissionServiceEvent.submissionLogsFetched, params: [_currentSubmissionLogs.isNotEmpty]);
    return _currentSubmissionLogs;
  }

  void notifyRebuildParentScreen(Submission submission) {
    sendEvent(SubmissionServiceEvent.submissionStatusChanged, params: [submission]);
  }

  void _addSubmissionLog({required SubmissionStatus status}) {
    final timestamp = DateTime.now();
    final dateFormatter = DateFormat('d/M/yyyy');
    final timeFormatter = DateFormat('HH:mm');

    _currentSubmissionLogs.add(
      SubmissionLog(
        timestamp: timestamp,
        status: status,
        formattedDate: dateFormatter.format(timestamp),
        formattedTime: timeFormatter.format(timestamp),
      ),
    );

    sendEvent(SubmissionServiceEvent.submissionLogsFetched, params: [_currentSubmissionLogs.isNotEmpty]);
  }

  @override
  String get className => 'UploadTrickService';
}
