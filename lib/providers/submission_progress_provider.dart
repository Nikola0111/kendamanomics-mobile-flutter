import 'package:flutter/cupertino.dart';
import 'package:kendamanomics_mobile/mixins/logger_mixin.dart';
import 'package:kendamanomics_mobile/models/submission.dart';
import 'package:kendamanomics_mobile/models/submission_log.dart';
import 'package:kendamanomics_mobile/models/trick.dart';
import 'package:kendamanomics_mobile/services/persistent_data_service.dart';
import 'package:kendamanomics_mobile/services/submission_service.dart';
import 'package:kiwi/kiwi.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum SubmissionProgressEnum { loading, success, error }

class SubmissionProgressProvider extends ChangeNotifier with LoggerMixin {
  final _persistentDataService = KiwiContainer().resolve<PersistentDataService>();
  final _submissionService = KiwiContainer().resolve<SubmissionService>();
  final _controller = PreloadPageController();
  final String? trickID;
  final Submission _submission = Submission();
  final _logs = <SubmissionLog>[];
  double listItemHeight = 0.0;
  SubmissionProgressEnum _state = SubmissionProgressEnum.loading;
  Trick? _trick;

  Trick? get trick => _trick;
  Submission get submission => _submission;
  SubmissionProgressEnum get state => _state;
  PreloadPageController get controller => _controller;
  List<SubmissionLog> get logs => _logs;
  int get numberOfSubtitleLines {
    switch (_submission.status) {
      case SubmissionStatus.revoked:
      case SubmissionStatus.waitingForSubmission:
        return 0;
      case SubmissionStatus.inReview:
      case SubmissionStatus.denied:
      case SubmissionStatus.deniedOutOfFrame:
      case SubmissionStatus.deniedTooLong:
      case SubmissionStatus.deniedInappropriateBehaviour:
      case SubmissionStatus.deniedIncorrectTrick:
      case SubmissionStatus.laced:
      case SubmissionStatus.awarded:
        return 1;
    }
  }

  SubmissionProgressProvider({this.trickID}) {
    _submissionService.subscribe(_listenToSubmissionService);
    _getTrick();
    _checkForActiveSubmission();
    _fetchSubmissionLogs();
  }

  void _listenToSubmissionService(SubmissionServiceEvent event, dynamic params) {
    switch (event) {
      case SubmissionServiceEvent.submissionStatusChanged:
        final sub = (params.first as Submission);
        _submission.submissionUpdated(newStatus: sub.status, newVideoUrl: sub.videoUrl, id: sub.submissionID);
        notifyListeners();
      case SubmissionServiceEvent.submissionLogsFetched:
        _logs.clear();
        _logs.addAll(_submissionService.currentSubmissionLogs);
        notifyListeners();
        break;
    }
  }

  // fetch form submissions table with tama_id, trick_id, player_id (should ignore if submission is marked as revoked)
  // need progress data, video url
  void _checkForActiveSubmission() async {
    logI('checking active submission with: tama_id - ${trick?.tamaID}, trick_id - ${trick?.id}');
    try {
      final temp = await _submissionService.checkForActiveSubmission(trickID: trick!.id!, tamaID: trick!.tamaID!);
      _submission.submissionUpdated(id: temp.submissionID, newVideoUrl: temp.videoUrl, newStatus: temp.status);

      _state = SubmissionProgressEnum.success;
      logI('active submission checked, id: ${_submission.submissionID}, status: ${_submission.status}');
      notifyListeners();
    } on PostgrestException catch (e) {
      logE('error checking for active submission, ${e.toString()}');
    }
  }

  void scrollToTimeline() {
    _controller.animateTo(_controller.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300), curve: Curves.linearToEaseOut);
  }

  void scrollToVideo() {
    _controller.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.linearToEaseOut);
  }

  void _getTrick() {
    _trick = _persistentDataService.getTrickByID(trickID);
  }

  void _fetchSubmissionLogs() async {
    if (trick == null) return;
    logI('fetching submission logs');
    try {
      final logs = await _submissionService.fetchSubmissionLogs(tamaID: trick!.tamaID!, trickID: trick!.id!);
      _logs.clear();
      _logs.addAll(logs);
      logI('fetching submission logs succeeded');
      notifyListeners();
    } on PostgrestException catch (e) {
      logE('error fetching submission logs for id ${trick?.id}: ${e.code} - ${e.message}');
    }
  }

  @override
  void dispose() {
    _submissionService.unsubscribe(_listenToSubmissionService);
    super.dispose();
  }

  @override
  String get className => 'SubmissionProgressProvider';
}
