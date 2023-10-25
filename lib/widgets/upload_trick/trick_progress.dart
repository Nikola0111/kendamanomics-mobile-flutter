import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kendamanomics_mobile/extensions/custom_colors.dart';
import 'package:kendamanomics_mobile/extensions/custom_text_styles.dart';
import 'package:kendamanomics_mobile/models/submission.dart';
import 'package:kendamanomics_mobile/models/trick.dart';
import 'package:kendamanomics_mobile/providers/trick_progress_provider.dart';
import 'package:kendamanomics_mobile/widgets/custom_button.dart';
import 'package:kendamanomics_mobile/widgets/upload_trick/trick_video_player.dart';
import 'package:provider/provider.dart';

class TrickProgress extends StatelessWidget {
  final Trick? trick;
  final Submission submission;
  final VoidCallback onTimelinePressed;
  const TrickProgress({super.key, required this.submission, required this.trick, required this.onTimelinePressed});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TrickProgressProvider(submission: submission, trick: trick),
      builder: (context, child) => Consumer<TrickProgressProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              Expanded(child: _getChild(provider)),
              const SizedBox(height: 12),
              ..._getBottomWidget(provider, context),
              const SizedBox(height: 12),
            ],
          );
        },
      ),
    );
  }

  Widget _getChild(TrickProgressProvider provider) {
    switch (submission.status) {
      case SubmissionStatus.waitingForSubmission:
        return Center(
          child: CustomButton(
            isLoading: provider.state == TrickProgressProviderState.uploadingSubmission,
            text: 'buttons.upload'.tr(),
            onPressed: () async {
              await provider.uploadTrickSubmission();
            },
          ),
        );
      case SubmissionStatus.inReview:
      case SubmissionStatus.denied:
      case SubmissionStatus.deniedOutOfFrame:
      case SubmissionStatus.deniedTooLong:
      case SubmissionStatus.deniedInappropriateBehaviour:
      case SubmissionStatus.deniedIncorrectTrick:
      case SubmissionStatus.awarded:
      case SubmissionStatus.laced:
        return TrickVideoPlayer(submission: submission);
      case SubmissionStatus.revoked:
        return const SizedBox.shrink();
    }
  }

  List<Widget> _getBottomWidget(TrickProgressProvider provider, BuildContext context) {
    switch (provider.submission.status) {
      case SubmissionStatus.waitingForSubmission:
        if (provider.hasLogs) {
          return [
            GestureDetector(
              onTap: onTimelinePressed,
              behavior: HitTestBehavior.translucent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'upload_trick.timeline',
                    style: CustomTextStyles.of(context).medium24.apply(color: CustomColors.of(context).timelineColor),
                  ).tr(),
                  const SizedBox(height: 2),
                  Image.asset('assets/icon/icon_arrow.png', height: 18, width: 18),
                ],
              ),
            ),
          ];
        }
        return const [SizedBox.shrink()];
      case SubmissionStatus.inReview:
      case SubmissionStatus.denied:
      case SubmissionStatus.deniedOutOfFrame:
      case SubmissionStatus.deniedTooLong:
      case SubmissionStatus.deniedInappropriateBehaviour:
      case SubmissionStatus.deniedIncorrectTrick:
        return [
          CustomButton(
            text: 'buttons.revoke'.tr(),
            isLoading: provider.state == TrickProgressProviderState.revokingSubmission,
            buttonStyle: CustomButtonStyle.small,
            onPressed: () async {
              await provider.revokeSubmission();
            },
          )
        ];
      case SubmissionStatus.laced:
        return [
          GestureDetector(
            onTap: onTimelinePressed,
            behavior: HitTestBehavior.translucent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'upload_trick.timeline',
                  style: CustomTextStyles.of(context).medium24.apply(color: CustomColors.of(context).timelineColor),
                ).tr(),
                const SizedBox(height: 2),
                Image.asset('assets/icon/icon_arrow.png', height: 18, width: 18),
              ],
            ),
          ),
        ];
      case SubmissionStatus.awarded:
      case SubmissionStatus.revoked:
        return const [SizedBox.shrink()];
    }
  }
}
