import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kendamanomics_mobile/extensions/custom_colors.dart';
import 'package:kendamanomics_mobile/extensions/custom_text_styles.dart';

class RegisterWelcome extends StatelessWidget {
  const RegisterWelcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'register_page.title',
        style: CustomTextStyles.of(context).regular25.apply(color: CustomColors.of(context).primaryText),
      ).tr(),
    );
  }
}
