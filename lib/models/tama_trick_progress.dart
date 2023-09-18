import 'package:kendamanomics_mobile/models/trick.dart';

enum TrickStatus {
  approved('approved'),
  pending('pending'),
  denied('denied'),
  none('none');

  final String value;
  const TrickStatus(this.value);

  factory TrickStatus.fromString(String value) {
    switch (value) {
      case 'approved':
        return TrickStatus.approved;
      case 'pending':
        return TrickStatus.pending;
      case 'denied':
        return TrickStatus.denied;
      case 'none':
        return TrickStatus.none;
      default:
        throw 'unknown trick progress value';
    }
  }
}

class TamaTrickProgress {
  final TrickStatus trickStatus;
  final int? trickPosition;
  final Trick? trick;

  TamaTrickProgress({
    this.trick,
    this.trickPosition,
    this.trickStatus = TrickStatus.none,
  });

  factory TamaTrickProgress.fromTrick({
    required Trick trick,
    required int trickPosition,
    String? status,
  }) {
    TrickStatus defaultStatus = TrickStatus.none;
    if (status != null) {
      defaultStatus = TrickStatus.fromString(status);
    }
    return TamaTrickProgress(
      trickPosition: trickPosition,
      trickStatus: defaultStatus,
      trick: Trick(
        id: trick.id,
        name: trick.name,
        trickTutorialUrl: trick.trickTutorialUrl,
      ),
    );
  }
}
