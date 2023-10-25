import 'package:easy_localization/easy_localization.dart';
import 'package:kendamanomics_mobile/models/submission.dart';

class SubmissionLog {
  final DateTime timestamp;
  final SubmissionStatus status;
  final String formattedDate;
  final String formattedTime;

  const SubmissionLog({
    required this.timestamp,
    required this.status,
    this.formattedDate = '',
    this.formattedTime = '',
  });

  factory SubmissionLog.fromJson({required Map<String, dynamic> json}) {
    final data = json['data'];
    final timestamp = DateTime.parse(data['created_at']).toLocal();

    final dateFormatter = DateFormat('d/M/yyyy');
    final timeFormatter = DateFormat('HH:mm');

    return SubmissionLog(
      timestamp: timestamp,
      formattedDate: dateFormatter.format(timestamp),
      formattedTime: timeFormatter.format(timestamp),
      status: SubmissionStatus.fromString(data['submission_log_event']),
    );
  }

  SubmissionLog copyWith({SubmissionStatus? newStatus}) {
    return SubmissionLog(
      timestamp: timestamp,
      status: newStatus ?? status,
      formattedDate: formattedDate,
      formattedTime: formattedTime,
    );
  }
}
