import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kendamanomics_mobile/extensions/custom_colors.dart';
import 'package:kendamanomics_mobile/extensions/custom_text_styles.dart';
import 'package:kendamanomics_mobile/pages/leaderboard.dart';
import 'package:kendamanomics_mobile/widgets/app_header.dart';
import 'package:kendamanomics_mobile/widgets/clickable_link.dart';
import 'package:kendamanomics_mobile/widgets/custom_button.dart';
import 'package:kendamanomics_mobile/widgets/custom_input_field.dart';

class LoginPage extends StatelessWidget {
  static const pageName = 'login';
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.of(context).backgroundColor,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Column(
          children: [
            const AppHeader(),
            SizedBox(height: MediaQuery.of(context).size.height / 4),
            CustomInputField(
              hintText: 'input_fields.username'.tr(),
            ),
            const SizedBox(height: 6.0),
            CustomInputField(
              hintText: 'input_fields.password'.tr(),
            ),
            const SizedBox(height: 20.0),
            ClickableLink(
              clickableText: 'buttons.forgot_password'.tr(),
              onClick: () {},
            ),
            const SizedBox(height: 20.0),
            ClickableLink(
              clickableText: 'buttons.create_an_account'.tr(),
              onClick: () {},
            ),
            SizedBox(height: MediaQuery.of(context).size.height / 4),
            CustomButton(
              text: 'buttons.login'.tr(),
              isEnabled: false,
              onPressed: () {
                context.goNamed(Leaderboard.pageName);
              },
            ),
          ],
        ),
      ),
    );
  }
}
