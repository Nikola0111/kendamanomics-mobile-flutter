import 'package:kendamanomics_mobile/models/submission.dart';
import 'package:kendamanomics_mobile/models/trick.dart';

class TamaTrickProgress {
  SubmissionStatus trickStatus;
  int? order;
  final Trick? trick;

  TamaTrickProgress({
    this.trick,
    this.trickStatus = SubmissionStatus.inReview,
    required this.order,
  });

  factory TamaTrickProgress.fromTrick({
    required Trick trick,
    int? trickOrder,
    SubmissionStatus? status,
  }) {
    return TamaTrickProgress(
      trickStatus: status ?? SubmissionStatus.waitingForSubmission,
      order: trickOrder,
      trick: Trick(
        id: trick.id,
        name: trick.name,
        trickTutorialUrl: trick.trickTutorialUrl,
      ),
    );
  }
}
