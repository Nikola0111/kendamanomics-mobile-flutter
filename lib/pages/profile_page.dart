import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kendamanomics_mobile/extensions/custom_colors.dart';
import 'package:kendamanomics_mobile/extensions/custom_text_styles.dart';
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
    return Scaffold(
      backgroundColor: CustomColors.of(context).backgroundColor,
      body: ChangeNotifierProvider(
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        LeaderboardType(
                          leaderboardName: 'leaderboards.kendamanomics'.tr(),
                          color: CustomColors.of(context).primaryText,
                          onPressed: () {},
                          isActive: true,
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          (provider.player?.playerPoints?.kendamanomicsPoints ?? 0).toString(),
                          style: CustomTextStyles.of(context).regular18.apply(color: CustomColors.of(context).primaryText),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        LeaderboardType(
                          leaderboardName: 'leaderboards.competition'.tr(),
                          color: CustomColors.of(context).timelineColor,
                          onPressed: () {},
                          isActive: false,
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          (provider.player?.playerPoints?.competitionPoints ?? 0).toString(),
                          style: CustomTextStyles.of(context).regular18.apply(color: CustomColors.of(context).primaryText),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        LeaderboardType(
                          leaderboardName: 'leaderboards.overall'.tr(),
                          color: CustomColors.of(context).borderColor,
                          onPressed: () {},
                          isActive: false,
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          (provider.player?.playerPoints?.overallPoints ?? 0).toString(),
                          style: CustomTextStyles.of(context).regular18.apply(color: CustomColors.of(context).primaryText),
                        )
                      ],
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
                    onClick: () {
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
      ),
    );
  }
}
