import 'package:flutter/material.dart';
import 'package:kendamanomics_mobile/extensions/custom_text_styles.dart';
import 'package:kendamanomics_mobile/extensions/string_extension.dart';
import 'package:kendamanomics_mobile/mixins/logger_mixin.dart';
import 'package:kendamanomics_mobile/models/submission_log.dart';
import 'package:kendamanomics_mobile/models/trick.dart';
import 'package:kendamanomics_mobile/services/submission_service.dart';
import 'package:kiwi/kiwi.dart';

class SubmissionLogsProvider extends ChangeNotifier with LoggerMixin {
  final _submissionService = KiwiContainer().resolve<SubmissionService>();
  final Trick? trick;
  final BuildContext context;
  List<SubmissionLog> submissionLogs;
  double dateBlockWidth = 0.0;
  double timeBlockWidth = 0.0;

  SubmissionLogsProvider(this.context, {required this.trick, required this.submissionLogs}) {
    _submissionService.subscribe(_listenToSubmissionService);
  }

  void _listenToSubmissionService(SubmissionServiceEvent event, dynamic params) {
    switch (event) {
      case SubmissionServiceEvent.submissionStatusChanged:
        break;
      case SubmissionServiceEvent.submissionLogsFetched:
        _updateSubmissionLogs(logs: _submissionService.currentSubmissionLogs);
        notifyListeners();
    }
  }

  void _updateSubmissionLogs({required List<SubmissionLog> logs}) {
    logs.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    if (context.mounted) {
      for (final log in logs) {
        final timeWidth = log.formattedTime.calculateSize(CustomTextStyles.of(context).light16).width + 24;
        final dateWidth = log.formattedDate.calculateSize(CustomTextStyles.of(context).light16).width + 24;

        if (timeWidth > timeBlockWidth) timeBlockWidth = timeWidth;
        if (dateWidth > dateBlockWidth) dateBlockWidth = dateWidth;
      }
    }

    submissionLogs.clear();
    submissionLogs.addAll(logs);
  }

  @override
  void dispose() {
    _submissionService.unsubscribe(_listenToSubmissionService);
    super.dispose();
  }

  @override
  String get className => 'SubmissionLogsProvider';
}
