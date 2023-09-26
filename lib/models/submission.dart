enum UploadTrickVideoStatus {
  waitingForSubmission('waitingForSubmission'),
  inReview('inReview'),
  denied('denied'),
  revoked('revoked'),
  laced('laced'),
  awarded('awarded');

  final String value;
  const UploadTrickVideoStatus(this.value);

  factory UploadTrickVideoStatus.fromString(String value) {
    switch (value) {
      case 'waitingForSubmission':
        return UploadTrickVideoStatus.waitingForSubmission;
      case 'inReview':
        return UploadTrickVideoStatus.inReview;
      case 'denied':
        return UploadTrickVideoStatus.denied;
      case 'revoked':
        return UploadTrickVideoStatus.revoked;
      case 'laced':
        return UploadTrickVideoStatus.laced;
      case 'awarded':
        return UploadTrickVideoStatus.awarded;
      default:
        throw 'unknown trick status';
    }
  }
}

class Submission {
  String? submissionID;
  String? videoUrl;
  UploadTrickVideoStatus status;

  Submission({this.submissionID, this.videoUrl, this.status = UploadTrickVideoStatus.waitingForSubmission});

  factory Submission.fromJson({required Map<String, dynamic> json}) {
    return Submission(
      submissionID: json['submission_id'],
      videoUrl: json['submission_video_url'],
      status: UploadTrickVideoStatus.fromString(json['submission_status']),
    );
  }

  void submissionUpdated({
    String? id,
    String? newVideoUrl,
    UploadTrickVideoStatus newStatus = UploadTrickVideoStatus.waitingForSubmission,
  }) {
    submissionID = id;
    videoUrl = newVideoUrl;
    status = newStatus;
  }

  void resetSubmission() {
    submissionID = null;
    videoUrl = null;
    status = UploadTrickVideoStatus.waitingForSubmission;
  }
}
