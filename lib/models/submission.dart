enum SubmissionStatus {
  waitingForSubmission('waitingForSubmission'),
  inReview('inReview'),
  denied('denied'),
  revoked('revoked'),
  laced('laced'),
  awarded('awarded');

  final String value;
  const SubmissionStatus(this.value);

  factory SubmissionStatus.fromString(String value) {
    switch (value) {
      case 'waitingForSubmission':
        return SubmissionStatus.waitingForSubmission;
      case 'inReview':
        return SubmissionStatus.inReview;
      case 'denied':
        return SubmissionStatus.denied;
      case 'revoked':
        return SubmissionStatus.revoked;
      case 'laced':
        return SubmissionStatus.laced;
      case 'awarded':
        return SubmissionStatus.awarded;
      default:
        throw 'unknown submission status';
    }
  }
}

class Submission {
  String? submissionID;
  String? videoUrl;
  SubmissionStatus status;

  Submission({this.submissionID, this.videoUrl, this.status = SubmissionStatus.waitingForSubmission});

  factory Submission.fromJson({required Map<String, dynamic> json}) {
    return Submission(
      submissionID: json['submission_id'],
      videoUrl: json['submission_video_url'],
      status: SubmissionStatus.fromString(json['submission_status']),
    );
  }

  void submissionUpdated({
    String? id,
    String? newVideoUrl,
    SubmissionStatus newStatus = SubmissionStatus.waitingForSubmission,
  }) {
    submissionID = id;
    videoUrl = newVideoUrl;
    status = newStatus;
  }

  void resetSubmission() {
    submissionID = null;
    videoUrl = null;
    status = SubmissionStatus.waitingForSubmission;
  }
}
