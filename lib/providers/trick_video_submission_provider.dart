import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:kendamanomics_mobile/mixins/logger_mixin.dart';
import 'package:kendamanomics_mobile/models/submission.dart';
import 'package:kendamanomics_mobile/services/submission_service.dart';
import 'package:kiwi/kiwi.dart';
import 'package:video_player/video_player.dart';

class TrickVideoSubmissionProvider extends ChangeNotifier with LoggerMixin {
  final _submissionService = KiwiContainer().resolve<SubmissionService>();
  final Submission submission;
  bool _isPlaying = false;
  VideoPlayerController? _controller;
  bool _initialized = false;
  bool _isDisposed = false;

  VideoPlayerController? get controller => _controller;
  bool get initialized => _initialized;

  TrickVideoSubmissionProvider({required this.submission}) {
    _fetchSignedUrlAndInitialize();
  }

  void _fetchSignedUrlAndInitialize() async {
    final path = await _submissionService.getSignedUrl(submission.videoUrl!);
    _controller = VideoPlayerController.networkUrl(Uri.parse(path));
    try {
      await _controller!.initialize();
      _initialized = true;
      _controller!.setLooping(true);
      if (!_isDisposed) {
        notifyListeners();
      }
      await _controller!.setVolume(0);
    } on PlatformException catch (e) {
      logE('error initializing video with url $path: ${e.message}');
    }
  }

  void playPauseVideo() async {
    if (_controller == null) return;

    if (_isPlaying) {
      _isPlaying = false;
      _controller!.pause();
    } else {
      _isPlaying = true;
      _controller!.play();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  @override
  String get className => 'TrickVideoSubmissionProvider';
}
