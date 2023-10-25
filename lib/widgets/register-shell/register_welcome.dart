import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kendamanomics_mobile/extensions/custom_colors.dart';
import 'package:kendamanomics_mobile/extensions/custom_text_styles.dart';
import 'package:kendamanomics_mobile/pages/login_page.dart';
import 'package:kendamanomics_mobile/widgets/clickable_link.dart';

class RegisterWelcome extends StatelessWidget {
  const RegisterWelcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0, right: 16.0),
            child: ClickableLink(
              clickableText: 'register_page.back_to_login'.tr(),
              onClick: () => context.goNamed(LoginPage.pageName),
              clickableTextStyle: CustomTextStyles.of(context).regular20.apply(color: CustomColors.of(context).timelineColor),
            ),
          ),
        ),
        Center(
          child: Text(
            'register_page.title',
            style: CustomTextStyles.of(context).regular25.apply(color: CustomColors.of(context).primaryText),
            textAlign: TextAlign.center,
          ).tr(),
        ),
      ],
    );
  }
}
