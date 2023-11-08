import 'package:kendamanomics_mobile/models/submission.dart';
import 'package:kendamanomics_mobile/models/trick.dart';

class TamaTrickProgress {
  SubmissionStatus trickStatus;
  final Trick? trick;

  TamaTrickProgress({
    this.trick,
    this.trickStatus = SubmissionStatus.inReview,
  });

  factory TamaTrickProgress.fromTrick({
    required Trick trick,
    SubmissionStatus? status,
  }) {
    return TamaTrickProgress(
      trickStatus: status ?? SubmissionStatus.waitingForSubmission,
      trick: Trick(
        id: trick.id,
        name: trick.name,
        trickTutorialUrl: trick.trickTutorialUrl,
      ),
    );
  }
}
