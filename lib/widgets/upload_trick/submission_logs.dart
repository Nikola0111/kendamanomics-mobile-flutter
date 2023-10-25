import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kendamanomics_mobile/extensions/custom_colors.dart';
import 'package:kendamanomics_mobile/extensions/custom_text_styles.dart';
import 'package:kendamanomics_mobile/models/submission.dart';
import 'package:kendamanomics_mobile/models/trick.dart';
import 'package:kendamanomics_mobile/providers/submission_logs_provider.dart';
import 'package:provider/provider.dart';

class SubmissionLogs extends StatelessWidget {
  final Trick? trick;
  final VoidCallback onBackToTrickPressed;
  const SubmissionLogs({super.key, required this.trick, required this.onBackToTrickPressed});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SubmissionLogsProvider(context, trick: trick),
      builder: (context, child) => Consumer<SubmissionLogsProvider>(
        builder: (context, provider, child) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.builder(
                    physics: const ClampingScrollPhysics(),
                    itemCount: provider.submissionLogs.length,
                    itemBuilder: (context, index) {
                      final log = provider.submissionLogs[index];
                      return DecoratedBox(
                        decoration: BoxDecoration(color: CustomColors.of(context).borderColor),
                        child: IntrinsicHeight(
                          child: Row(
                            children: [
                              _logTimeBlock(context, title: log.formattedDate, width: provider.dateBlockWidth),
                              _logTimeBlock(context, title: log.formattedTime, width: provider.timeBlockWidth),
                              _logStatusBlock(context, status: log.status),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: onBackToTrickPressed,
                  behavior: HitTestBehavior.translucent,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Transform.rotate(
                        angle: pi,
                        child: Image.asset('assets/icon/icon_arrow.png', height: 18, width: 18),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'upload_trick.back_to_trick',
                        style: CustomTextStyles.of(context).medium24.apply(color: CustomColors.of(context).timelineColor),
                      ).tr(),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _logTimeBlock(BuildContext context, {required String title, required double width}) {
    return Container(
      decoration: BoxDecoration(
        color: CustomColors.of(context).borderColor,
        border: Border.all(color: CustomColors.of(context).logBorder.withOpacity(0.5)),
      ),
      width: width,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 3),
          child: Text(
            title,
            style: CustomTextStyles.of(context).light16.apply(color: CustomColors.of(context).logLabel),
          ),
        ),
      ),
    );
  }

  Widget _logStatusBlock(BuildContext context, {required SubmissionStatus status}) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: CustomColors.of(context).borderColor,
          border: Border.all(color: CustomColors.of(context).logBorder.withOpacity(0.5)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Padding(
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: RichText(text: TextSpan(children: _eventText(context, status))),
        ),
      ),
    );
  }

  List<TextSpan> _eventText(BuildContext context, SubmissionStatus status) {
    final statusStyle = CustomTextStyles.of(context).light16.apply(color: CustomColors.of(context).primary);
    final normalStyle = CustomTextStyles.of(context).light16.apply(color: CustomColors.of(context).logLabel);
    switch (status) {
      case SubmissionStatus.waitingForSubmission:
        return [];
      case SubmissionStatus.inReview:
        final first = 'submission_log_texts.submitted'.tr();
        return [
          TextSpan(text: '$first ', style: normalStyle),
          TextSpan(text: trick?.name, style: statusStyle),
        ];
      case SubmissionStatus.deniedOutOfFrame:
        final second = 'submission_log_texts.denied_out_of_frame'.tr();
        return [
          TextSpan(text: trick?.name, style: statusStyle),
          TextSpan(text: ' $second', style: normalStyle),
        ];
      case SubmissionStatus.deniedTooLong:
        final second = 'submission_log_texts.denied_too_long'.tr();
        return [
          TextSpan(text: trick?.name, style: statusStyle),
          TextSpan(text: ' $second', style: normalStyle),
        ];
      case SubmissionStatus.deniedInappropriateBehaviour:
        final second = 'submission_log_texts.denied_inappropriate_behaviour'.tr();
        return [
          TextSpan(text: trick?.name, style: statusStyle),
          TextSpan(text: ' $second', style: normalStyle),
        ];
      case SubmissionStatus.deniedIncorrectTrick:
        final second = 'submission_log_texts.denied_incorrect_trick'.tr();
        return [
          TextSpan(text: trick?.name, style: statusStyle),
          TextSpan(text: ' $second', style: normalStyle),
        ];
      case SubmissionStatus.denied:
        final second = 'submission_log_texts.denied'.tr();
        return [
          TextSpan(text: trick?.name, style: statusStyle),
          TextSpan(text: ' $second', style: normalStyle),
        ];
      case SubmissionStatus.revoked:
        final second = 'submission_log_texts.revoked'.tr();
        return [
          TextSpan(text: trick?.name, style: statusStyle),
          TextSpan(text: ' $second', style: normalStyle),
        ];
      case SubmissionStatus.laced:
        final second = 'submission_log_texts.laced'.tr();
        return [
          TextSpan(text: trick?.name, style: statusStyle),
          TextSpan(text: ' $second', style: normalStyle),
        ];
      case SubmissionStatus.awarded:
        final first = 'submission_log_texts.awarded'.tr();
        return [
          TextSpan(text: '$first ', style: normalStyle),
          TextSpan(text: trick?.name, style: statusStyle),
        ];
    }
  }
}
