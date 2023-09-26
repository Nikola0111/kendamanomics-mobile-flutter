import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kendamanomics_mobile/extensions/custom_colors.dart';
import 'package:kendamanomics_mobile/extensions/custom_text_styles.dart';
import 'package:kendamanomics_mobile/models/submission.dart';
import 'package:kendamanomics_mobile/providers/trick_video_submission_provider.dart';
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
              _title(context),
              const SizedBox(height: 12),
              Expanded(
                child: provider.initialized && provider.controller != null
                    ? Stack(
                        children: [
                          Positioned.fill(
                            child: AspectRatio(
                              aspectRatio: provider.controller!.value.aspectRatio,
                              child: VideoPlayer(provider.controller!),
                            ),
                          ),
                        ],
                      )
                    : Container(), // here goes the loading animation
              ),
              const SizedBox(height: 12),
            ],
          );
        },
      ),
    );
  }

  Widget _title(BuildContext context) {
    switch (submission.status) {
      case UploadTrickVideoStatus.awarded:
      case UploadTrickVideoStatus.revoked:
      case UploadTrickVideoStatus.waitingForSubmission:
        // this will never happen
        return const SizedBox.shrink();
      case UploadTrickVideoStatus.inReview:
        return Text(
          'upload_trick.in_review',
          style: CustomTextStyles.of(context).regular25.apply(color: CustomColors.of(context).timelineColor),
        ).tr();
      case UploadTrickVideoStatus.denied:
        return Text(
          'upload_trick.denied',
          style: CustomTextStyles.of(context).regular25.apply(color: CustomColors.of(context).deniedColor),
        ).tr();
      case UploadTrickVideoStatus.laced:
        return Text(
          'upload_trick.laced',
          style: CustomTextStyles.of(context).regular25.apply(color: CustomColors.of(context).lacedColor),
        ).tr();
    }
  }
}
