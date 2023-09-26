import 'package:flutter/cupertino.dart';
import 'package:kendamanomics_mobile/mixins/logger_mixin.dart';
import 'package:kendamanomics_mobile/models/submission.dart';
import 'package:kendamanomics_mobile/models/trick.dart';
import 'package:kendamanomics_mobile/services/persistent_data_service.dart';
import 'package:kendamanomics_mobile/services/submission_service.dart';
import 'package:kiwi/kiwi.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum SubmissionProgressEnum { loading, success, error }

class SubmissionProgressProvider extends ChangeNotifier with LoggerMixin {
  final _persistentDataService = KiwiContainer().resolve<PersistentDataService>();
  final _submissionService = KiwiContainer().resolve<SubmissionService>();
  final String? trickID;
  final Submission _submission = Submission();
  final _controller = ScrollController();
  SubmissionProgressEnum _state = SubmissionProgressEnum.loading;
  Trick? _trick;

  Trick? get trick => _trick;
  Submission get submission => _submission;
  SubmissionProgressEnum get state => _state;
  ScrollController get controller => _controller;

  SubmissionProgressProvider({this.trickID}) {
    _getTrick();
    _checkForActiveSubmission();
  }

  // fetch form submissions table with tama_id, trick_id, player_id (should ignore if submission is marked as revoked)
  // need progress data, video url
  void _checkForActiveSubmission() async {
    logI('checking active submission with: tama_id - ${trick?.tamaID}, trick_id - ${trick?.id}');
    try {
      final temp = await _submissionService.checkForActiveSubmission(trickID: trick!.id!, tamaID: trick!.tamaID!);
      _submission.submissionUpdated(id: temp.submissionID, newVideoUrl: temp.videoUrl, newStatus: temp.status);

      _state = SubmissionProgressEnum.success;
      notifyListeners();
    } on PostgrestException catch (e) {
      logE('error checking for active submission, ${e.message}');
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

  @override
  String get className => 'SubmissionProgressProvider';
}
