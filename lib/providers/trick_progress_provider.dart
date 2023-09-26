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

enum TrickProgressProviderState { none, loading, errorVideoUpload, errorSubmissionCreation, success }

class TrickProgressProvider extends ChangeNotifier with LoggerMixin {
  final _submissionService = KiwiContainer().resolve<SubmissionService>();
  final _authService = KiwiContainer().resolve<AuthService>();
  final Trick? trick;
  final Submission submission;
  TrickProgressProviderState _state = TrickProgressProviderState.loading;

  TrickProgressProviderState get state => _state;
  UploadTrickVideoStatus get status => submission.status;

  TrickProgressProvider({this.trick, required this.submission});

  // changes status to revoked
  // deletes the video from supabase
  Future<void> revokeSubmission() async {
    if (submission.submissionID == null || submission.status == UploadTrickVideoStatus.waitingForSubmission) return;
    final successfulVideoDelete = await _removeSubmissionVideoFromStorage();

    if (!successfulVideoDelete) return;
    final successfulRevoke = await _updateSubmissionData(status: UploadTrickVideoStatus.laced);

    if (successfulRevoke) {
      submission.resetSubmission();
      notifyListeners();
    }
  }

  Future<void> uploadTrickSubmission() async {
    // sanity check
    if (trick?.id == null || submission.status != UploadTrickVideoStatus.waitingForSubmission) return;

    final videoFile = await _selectVideo();
    if (videoFile == null) return;

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

    submission.submissionUpdated(id: id, newVideoUrl: path, newStatus: UploadTrickVideoStatus.inReview);
    notifyListeners();
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

  Future<bool> _updateSubmissionData({required UploadTrickVideoStatus status}) async {
    try {
      await _submissionService.updateSubmissionData(submissionID: submission.submissionID!, status: status);
      return true;
    } on PostgrestException catch (e) {
      logE('error revoking submission: ${e.message}');
      return false;
    }
  }

  @override
  String get className => 'TrickProgressProvider';
}
