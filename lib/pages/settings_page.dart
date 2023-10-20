import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kendamanomics_mobile/extensions/custom_colors.dart';
import 'package:kendamanomics_mobile/extensions/custom_text_styles.dart';
import 'package:kendamanomics_mobile/pages/login_page.dart';
import 'package:kendamanomics_mobile/providers/settings_page_provider.dart';
import 'package:kendamanomics_mobile/services/auth_service.dart';
import 'package:kendamanomics_mobile/widgets/clickable_link.dart';
import 'package:kendamanomics_mobile/widgets/settings_row.dart';
import 'package:kiwi/kiwi.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  static const pageName = 'settings';

  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.of(context).backgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ChangeNotifierProvider(
          create: (context) => SettingsPageProvider(),
          builder: (context, child) => Consumer<SettingsPageProvider>(
            builder: (context, provider, child) => Column(
              children: [
                Center(
                  child: Text(
                    'profile_page.settings',
                    style: CustomTextStyles.of(context).regular20.apply(color: CustomColors.of(context).primary),
                  ).tr(),
                ),
                const SizedBox(height: 10.0),
                SettingsRow(
                  rowName: 'settings_page.name'.tr(),
                  data: provider.playerName,
                  onPressed: () {},
                  clickable: false,
                ),
                if (provider.supportingCompany != null)
                  SettingsRow(
                    rowName: 'settings_page.team'.tr(),
                    data: provider.supportingCompany!,
                    // onPressed: () {
                    //   context.pushNamed(ChangeTeamPage.pageName);
                    // },
                    clickable: false,
                  ),
                SettingsRow(
                  rowName: 'settings_page.username'.tr(),
                  data: provider.instagramUserName,
                  clickable: false,
                ),
                SettingsRow(
                  rowName: 'settings_page.email'.tr(),
                  data: provider.email,
                  clickable: false,
                ),
                const Spacer(),
                ClickableLink(
                  clickableText: 'buttons.logout'.tr(),
                  onClick: () {
                    KiwiContainer().resolve<AuthService>().signOut();
                    context.goNamed(LoginPage.pageName);
                  },
                  clickableTextStyle: CustomTextStyles.of(context).regular20.apply(color: CustomColors.of(context).primary),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
