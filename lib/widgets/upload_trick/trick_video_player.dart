import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kendamanomics_mobile/extensions/custom_colors.dart';
import 'package:kendamanomics_mobile/extensions/custom_text_styles.dart';
import 'package:kendamanomics_mobile/models/submission.dart';
import 'package:kendamanomics_mobile/providers/trick_video_submission_provider.dart';
import 'package:kendamanomics_mobile/widgets/custom_loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class TrickVideoPlayer extends StatelessWidget {
  final Submission submission;
  const TrickVideoPlayer({super.key, required this.submission});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TrickVideoSubmissionProvider(submission: submission),
      builder: (context, child) => Consumer<TrickVideoSubmissionProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              ..._title(context),
              Expanded(
                child: provider.initialized && provider.controller != null
                    ? GestureDetector(
                        onTap: provider.playPauseVideo,
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: AspectRatio(
                                aspectRatio: provider.controller!.value.aspectRatio,
                                child: VideoPlayer(provider.controller!),
                              ),
                            ),
                            Positioned(
                              bottom: 8,
                              left: 8,
                              child: SizedBox(
                                width: 44,
                                height: 44,
                                child: Image.asset('assets/icon/icon_play.png'),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const Center(child: CustomLoadingIndicator()), // here goes the loading animation
              ),
              const SizedBox(height: 12),
            ],
          );
        },
      ),
    );
  }

  List<Widget> _title(BuildContext context) {
    switch (submission.status) {
      case SubmissionStatus.awarded:
      case SubmissionStatus.revoked:
      case SubmissionStatus.waitingForSubmission:
        // this will never happen
        return [const SizedBox.shrink()];
      case SubmissionStatus.inReview:
        return [
          Text(
            'upload_trick.in_review',
            style: CustomTextStyles.of(context).regular25.apply(color: CustomColors.of(context).timelineColor),
          ).tr(),
          const SizedBox(height: 12),
        ];
      case SubmissionStatus.deniedIncorrectTrick:
      case SubmissionStatus.deniedInappropriateBehaviour:
      case SubmissionStatus.deniedOutOfFrame:
      case SubmissionStatus.deniedTooLong:
      case SubmissionStatus.denied:
        return [
          Text(
            'upload_trick.denied',
            style: CustomTextStyles.of(context).regular25.apply(color: CustomColors.of(context).deniedColor),
          ).tr(),
          const SizedBox(height: 12),
        ];
      case SubmissionStatus.laced:
        return [
          Text(
            'upload_trick.laced',
            style: CustomTextStyles.of(context).regular25.apply(color: CustomColors.of(context).lacedColor),
          ).tr(),
          const SizedBox(height: 12),
        ];
    }
  }
}
