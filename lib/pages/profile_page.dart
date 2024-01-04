import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kendamanomics_mobile/extensions/custom_colors.dart';
import 'package:kendamanomics_mobile/extensions/custom_text_styles.dart';
import 'package:kendamanomics_mobile/extensions/string_extension.dart';
import 'package:kendamanomics_mobile/pages/select_company_page.dart';
import 'package:kendamanomics_mobile/pages/settings_page.dart';
import 'package:kendamanomics_mobile/providers/profile_page_provider.dart';
import 'package:kendamanomics_mobile/services/auth_service.dart';
import 'package:kendamanomics_mobile/widgets/clickable_link.dart';
import 'package:kendamanomics_mobile/widgets/leaderboard_type.dart';
import 'package:kendamanomics_mobile/widgets/profile_header.dart';
import 'package:kendamanomics_mobile/widgets/profile_tama_progress.dart';
import 'package:kiwi/kiwi.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  final String userId;
  static const pageName = 'profile';
  const ProfilePage({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    final tabWidth = MediaQuery.sizeOf(context).width * 0.27 - 8;
    final tabFontSize = 'leaderboards.kendamanomics'.tr().calculateConstrainedFontSize(
          context: context,
          textStyle: CustomTextStyles.of(context).light16,
          maxWidth: tabWidth,
          maxHeight: 16,
          minFontSize: 10,
        );
    return ChangeNotifierProvider(
      create: (context) => ProfilePageProvider(userId: userId),
      builder: (context, child) => Consumer<ProfilePageProvider>(
        builder: (context, provider, child) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(
            children: [
              ProfileHeader(
                damxPoints: 0,
                company: provider.company,
                name: provider.playerName,
                profileImageUrl: provider.signedImageUrl,
                onProfilePicturePressed: () async {
                  if (provider.availableForUpload(userId) == true) {
                    final picker = ImagePicker();
                    final image = await picker.pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      await provider.uploadUserImage(File(image.path));
                    }
                  }
                },
                canPickTeam: provider.availableForUpload(userId),
                onCompanyPressed: () async {
                  final data = await context.pushNamed(SelectCompanyPage.pageName);
                  if (data != null) {
                    final map = data as Map<String, dynamic>;
                    await provider.updateCompany(map['id']);
                  }
                },
              ),
              const SizedBox(height: 20.0),
              Row(
                children: [
                  Expanded(
                    child: _leaderboardTab(
                      context,
                      tabFontSize: tabFontSize,
                      title: 'leaderboards.kendamanomics'.tr(),
                      backgroundColor: CustomColors.of(context).primaryText,
                      isActive: true,
                      points: provider.player?.playerPoints?.kendamanomicsPoints,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _leaderboardTab(
                      context,
                      tabFontSize: tabFontSize,
                      title: 'leaderboards.competition'.tr(),
                      backgroundColor: CustomColors.of(context).timelineColor,
                      isActive: false,
                      points: provider.player?.playerPoints?.competitionPoints,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _leaderboardTab(
                      context,
                      tabFontSize: tabFontSize,
                      title: 'leaderboards.overall'.tr(),
                      backgroundColor: CustomColors.of(context).borderColor,
                      isActive: false,
                      points: provider.player?.playerPoints?.overallPoints,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Expanded(
                child: ProfileTamaProgress(
                  state: provider.state,
                  playerTamas: provider.playerTamas,
                ),
              ),
              if (provider.availableForUpload(userId)) ...[
                ClickableLink(
                  clickableText: 'profile_page.settings'.tr(),
                  onTap: () {
                    final ret = KiwiContainer().resolve<AuthService>().getCurrentUserId();
                    context.pushNamed(SettingsPage.pageName, extra: ret);
                  },
                  clickableTextStyle: CustomTextStyles.of(context).regular20.apply(color: CustomColors.of(context).primary),
                ),
                const SizedBox(height: 8),
              ]
            ],
          ),
        ),
      ),
    );
  }

  Widget _leaderboardTab(
    BuildContext context, {
    required double tabFontSize,
    required String title,
    required Color backgroundColor,
    required bool isActive,
    int? points,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LeaderboardType(
          fontSize: tabFontSize,
          leaderboardName: title,
          color: backgroundColor,
          isActive: isActive,
        ),
        const SizedBox(height: 4.0),
        Text(
          (points ?? 0).toString(),
          textAlign: TextAlign.center,
          style: CustomTextStyles.of(context).regular18.apply(color: CustomColors.of(context).primaryText),
        )
      ],
    );
  }
}
