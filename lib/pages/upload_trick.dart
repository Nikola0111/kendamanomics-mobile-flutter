import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kendamanomics_mobile/extensions/custom_colors.dart';
import 'package:kendamanomics_mobile/extensions/custom_text_styles.dart';
import 'package:kendamanomics_mobile/providers/upload_trick_provider.dart';
import 'package:kendamanomics_mobile/widgets/upload_trick/submission_progress.dart';
import 'package:kendamanomics_mobile/widgets/upload_trick/trick_tutorial.dart';
import 'package:provider/provider.dart';

class UploadTrick extends StatelessWidget {
  static const pageName = 'upload-trick';
  final String? trickID;
  const UploadTrick({super.key, this.trickID});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.of(context).backgroundColor,
      body: SafeArea(
        child: ChangeNotifierProvider(
          create: (context) => UploadTrickProvider(trickID: trickID),
          builder: (context, child) {
            return Consumer<UploadTrickProvider>(
              builder: (context, provider, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        provider.trick?.name ?? 'default_titles.trick'.tr(),
                        textAlign: TextAlign.center,
                        style: CustomTextStyles.of(context).regular25.apply(color: CustomColors.of(context).primary),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: PageView(
                        onPageChanged: (index) {
                          provider.pageIndex = index;
                        },
                        children: [
                          SubmissionProgress(trickID: trickID),
                          TrickTutorial(trickTutorialUrl: provider.trick?.trickTutorialUrl),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    buildIndicator(context, provider.pageIndex),
                    const SizedBox(height: 8),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget buildIndicator(BuildContext context, int currentPage) {
    return AnimatedPadding(
      duration: const Duration(milliseconds: 450),
      curve: Curves.linearToEaseOut,
      padding: EdgeInsets.only(left: (MediaQuery.of(context).size.width / 2) * currentPage),
      child: Container(
        height: 4.0,
        width: MediaQuery.of(context).size.width / 2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(80.0),
          shape: BoxShape.rectangle,
          color: CustomColors.of(context).activeIndicatorColor,
        ),
      ),
    );
  }
}
