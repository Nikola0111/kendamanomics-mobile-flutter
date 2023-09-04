import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kendamanomics_mobile/extensions/custom_colors.dart';
import 'package:kendamanomics_mobile/extensions/custom_text_styles.dart';

class RegisterDescription extends StatelessWidget {
  const RegisterDescription({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
      child: Text(
        'register_page.app_description',
        style: CustomTextStyles.of(context).regular25.apply(color: CustomColors.of(context).primaryText),
        textAlign: TextAlign.center,
      ).tr(),
    );
  }
}
