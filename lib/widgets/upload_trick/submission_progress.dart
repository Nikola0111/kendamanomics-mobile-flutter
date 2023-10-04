import 'package:flutter/material.dart';
import 'package:kendamanomics_mobile/extensions/custom_text_styles.dart';
import 'package:kendamanomics_mobile/extensions/string_extension.dart';
import 'package:kendamanomics_mobile/providers/main_page_container_provider.dart';
import 'package:kendamanomics_mobile/providers/submission_progress_provider.dart';
import 'package:kendamanomics_mobile/widgets/upload_trick/submission_logs.dart';
import 'package:kendamanomics_mobile/widgets/upload_trick/trick_progress.dart';
import 'package:provider/provider.dart';

class SubmissionProgress extends StatelessWidget {
  final String? trickID;
  const SubmissionProgress({super.key, required this.trickID});

  @override
  Widget build(BuildContext context) {
    final contentHeight = context.read<MainPageContainerProvider>().contentHeight;

    return ChangeNotifierProvider(
      create: (context) => SubmissionProgressProvider(trickID: trickID),
      builder: (context, child) => Consumer<SubmissionProgressProvider>(
        builder: (context, provider, child) {
          if (provider.state == SubmissionProgressEnum.loading) return Container();

          final listItemHeight = calculateListItemHeight(
            context,
            contentHeight: contentHeight,
            trickName: provider.trick!.name!,
            numOfSubtitleLines: provider.numberOfSubtitleLines,
          );

          return ListView(
            controller: provider.controller,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              SizedBox(
                height: listItemHeight,
                child: TrickProgress(
                  submission: provider.submission,
                  trick: provider.trick,
                  onTimelinePressed: provider.scrollToTimeline,
                ),
              ),
              SizedBox(
                height: listItemHeight,
                child: SubmissionLogs(
                  trick: provider.trick,
                  onBackToTrickPressed: provider.scrollToVideo,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  double calculateListItemHeight(
    BuildContext context, {
    required double contentHeight,
    required String trickName,
    required int numOfSubtitleLines,
  }) {
    final numOfTitleLines = trickName.getNumberOfLines(
      style: CustomTextStyles.of(context).regular25,
      maxWidth: MediaQuery.of(context).size.width - 2 * 12,
    );

    final titleSingleLineHeight = trickName.calculateSize(CustomTextStyles.of(context).regular25).height;
    int numOfPaddings = 2;
    if (numOfSubtitleLines == 0) {
      numOfPaddings = 1;
    }

    // need to improve this calculation here, for now this works
    return contentHeight -
        (numOfTitleLines + numOfSubtitleLines) * titleSingleLineHeight -
        12 * numOfPaddings -
        (numOfSubtitleLines == 0 ? 20 : -20);
  }
}
