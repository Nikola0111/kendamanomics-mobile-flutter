import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kendamanomics_mobile/mixins/logger_mixin.dart';
import 'package:kendamanomics_mobile/models/submission.dart';
import 'package:kendamanomics_mobile/models/trick.dart';
import 'package:kendamanomics_mobile/services/auth_service.dart';
import 'package:kendamanomics_mobile/services/submission_service.dart';
import 'package:kiwi/kiwi.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum TrickProgressProviderState {
  none,
  loading,
  uploadingSubmission,
  revokingSubmission,
  errorVideoUpload,
  errorSubmissionCreation,
  success,
}

class TrickProgressProvider extends ChangeNotifier with LoggerMixin {
  final _submissionService = KiwiContainer().resolve<SubmissionService>();
  final _authService = KiwiContainer().resolve<AuthService>();
  final Trick? trick;
  final Submission submission;
  TrickProgressProviderState _state = TrickProgressProviderState.loading;
  bool _hasLogs = false;

  TrickProgressProviderState get state => _state;
  bool get hasLogs => _hasLogs;

  TrickProgressProvider({this.trick, required this.submission}) {
    _submissionService.subscribe(_listenToSubmissionService);
  }

  void _listenToSubmissionService(SubmissionServiceEvent event, dynamic params) {
    switch (event) {
      case SubmissionServiceEvent.submissionLogsFetched:
        if (params.first == true) {
          _hasLogs = true;
          notifyListeners();
        }
      case SubmissionServiceEvent.submissionStatusChanged:
        break;
    }
  }

  // changes status to revoked
  // deletes the video from supabase
  Future<void> revokeSubmission() async {
    _state = TrickProgressProviderState.revokingSubmission;
    notifyListeners();
    if (submission.submissionID == null || submission.status == SubmissionStatus.waitingForSubmission) {
      _state = TrickProgressProviderState.none;
      notifyListeners();
      return;
    }
    final successfulVideoDelete = await _removeSubmissionVideoFromStorage();

    if (!successfulVideoDelete) {
      _state = TrickProgressProviderState.none;
      notifyListeners();
      return;
    }

    final successfulRevoke = await _updateSubmissionData(status: SubmissionStatus.revoked);

    if (successfulRevoke) {
      _state = TrickProgressProviderState.none;
      submission.resetSubmission();
      _submissionService.notifyRebuildParentScreen(submission);
    }
  }

  Future<void> uploadTrickSubmission() async {
    // sanity check
    if (trick?.id == null || submission.status != SubmissionStatus.waitingForSubmission) return;

    final videoFile = await _selectVideo();
    if (videoFile == null) {
      _state = TrickProgressProviderState.none;
      return;
    }

    _state = TrickProgressProviderState.uploadingSubmission;
    notifyListeners();

    // if video with given name already exists, it means that the user didn't revoke the submission, hence show snackbar
    final path = await _uploadVideoToStorage(videoFile);
    if (path == null) {
      _state = TrickProgressProviderState.errorVideoUpload;
      notifyListeners();
      return;
    }

    final id = await _createSubmission(videoUrl: path);
    if (id == null) {
      _state = TrickProgressProviderState.errorSubmissionCreation;
      notifyListeners();
      return;
    }

    submission.submissionUpdated(id: id, newVideoUrl: path, newStatus: SubmissionStatus.inReview);
    _submissionService.notifyRebuildParentScreen(submission);
  }

  Future<File?> _selectVideo() async {
    final picker = ImagePicker();
    final videoXFile = await picker.pickVideo(source: ImageSource.gallery);
    if (videoXFile != null) {
      return File(videoXFile.path);
    } else {
      return null;
    }
  }

  Future<String?> _uploadVideoToStorage(File videoFile) async {
    try {
      final path = await _submissionService.uploadVideoFile(videoFile: videoFile, trickName: trick!.name!);
      return path;
    } on StorageException catch (e) {
      logE('error uploading video to storage: ${e.statusCode} - ${e.message}');
      return null;
    }
  }

  Future<bool> _removeSubmissionVideoFromStorage() async {
    try {
      await _submissionService.removeVideoFromStorage(videoName: submission.videoUrl!);
      return true;
    } on StorageException catch (e) {
      logE('error deleting video from storage: ${e.statusCode} - ${e.message}');
      return false;
    }
  }

  Future<String?> _createSubmission({required String videoUrl}) async {
    try {
      final submissionID = await _submissionService.createSubmission(
        playerID: _authService.player!.id,
        trickID: trick!.id!,
        tamaID: trick!.tamaID!,
        videoUrl: videoUrl,
      );

      return submissionID;
    } on PostgrestException catch (e) {
      logE('error creating submission: ${e.message}');
      return null;
    }
  }

  Future<bool> _updateSubmissionData({required SubmissionStatus status}) async {
    try {
      await _submissionService.updateSubmissionData(submissionID: submission.submissionID!, status: status);
      return true;
    } on PostgrestException catch (e) {
      logE('error revoking submission: ${e.message}');
      return false;
    }
  }

  @override
  void dispose() {
    _submissionService.unsubscribe(_listenToSubmissionService);
    super.dispose();
  }

  @override
  String get className => 'TrickProgressProvider';
}
