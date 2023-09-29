import 'package:kendamanomics_mobile/models/submission.dart';
import 'package:kendamanomics_mobile/models/trick.dart';

class TamaTrickProgress {
  SubmissionStatus trickStatus;
  final int? trickPosition;
  final Trick? trick;

  TamaTrickProgress({
    this.trick,
    this.trickPosition,
    this.trickStatus = SubmissionStatus.inReview,
  });

  factory TamaTrickProgress.fromTrick({
    required Trick trick,
    required int trickPosition,
    SubmissionStatus? status,
  }) {
    return TamaTrickProgress(
      trickPosition: trickPosition,
      trickStatus: status ?? SubmissionStatus.waitingForSubmission,
      trick: Trick(
        id: trick.id,
        name: trick.name,
        trickTutorialUrl: trick.trickTutorialUrl,
      ),
    );
  }
}
