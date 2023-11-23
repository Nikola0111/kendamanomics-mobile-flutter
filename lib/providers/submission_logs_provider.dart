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
    _updateSubmissionLogs();
  }

  void _listenToSubmissionService(SubmissionServiceEvent event, dynamic params) {
    switch (event) {
      case SubmissionServiceEvent.submissionStatusChanged:
        break;
      case SubmissionServiceEvent.submissionLogsFetched:
        logI('submission logs fetched ${_submissionService.currentSubmissionLogs.length}');
        submissionLogs.clear();
        submissionLogs.addAll(_submissionService.currentSubmissionLogs);
        _updateSubmissionLogs();
        notifyListeners();
    }
  }

  void _updateSubmissionLogs() {
    submissionLogs.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    if (context.mounted) {
      for (final log in submissionLogs) {
        final timeWidth = log.formattedTime.calculateSize(CustomTextStyles.of(context).light16).width + 24;
        final dateWidth = log.formattedDate.calculateSize(CustomTextStyles.of(context).light16).width + 24;

        if (timeWidth > timeBlockWidth) timeBlockWidth = timeWidth;
        if (dateWidth > dateBlockWidth) dateBlockWidth = dateWidth;
      }
    }
  }

  @override
  void dispose() {
    _submissionService.unsubscribe(_listenToSubmissionService);
    super.dispose();
  }

  @override
  String get className => 'SubmissionLogsProvider';
}
