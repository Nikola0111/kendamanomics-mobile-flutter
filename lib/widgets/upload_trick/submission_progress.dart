import 'package:flutter/material.dart';
import 'package:kendamanomics_mobile/providers/submission_progress_provider.dart';
import 'package:kendamanomics_mobile/widgets/bottom_navigation.dart';
import 'package:kendamanomics_mobile/widgets/upload_trick/submission_logs.dart';
import 'package:kendamanomics_mobile/widgets/upload_trick/trick_progress.dart';
import 'package:provider/provider.dart';

class SubmissionProgress extends StatelessWidget {
  final String? trickID;
  const SubmissionProgress({super.key, required this.trickID});

  @override
  Widget build(BuildContext context) {
    final bottomNavHeight = BottomNavigation.iconSize + 12 + 1 + MediaQuery.of(context).viewInsets.bottom;
    const topBarPercent = 0.24;
    final contentHeight =
        MediaQuery.of(context).size.height - bottomNavHeight - MediaQuery.of(context).size.height * topBarPercent;

    return ChangeNotifierProvider(
      create: (context) => SubmissionProgressProvider(trickID: trickID),
      builder: (context, child) => Consumer<SubmissionProgressProvider>(
        builder: (context, provider, child) {
          if (provider.state == SubmissionProgressEnum.loading) return Container();

          return ListView(
            controller: provider.controller,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              SizedBox(
                height: contentHeight,
                child: TrickProgress(
                  submission: provider.submission,
                  trick: provider.trick,
                  onTimelinePressed: provider.scrollToTimeline,
                ),
              ),
              SizedBox(
                height: contentHeight,
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
}
