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
      child: Column(
        children: [
          Text(
            'register_page.app_description',
            style: CustomTextStyles.of(context).regular25.apply(color: CustomColors.of(context).primaryText),
            textAlign: TextAlign.center,
          ).tr(),
          const SizedBox(height: 20.0),
          Image.asset(
            'assets/images/register_placeholder_border.png',
            height: MediaQuery.of(context).size.height * 0.7,
            fit: BoxFit.fitWidth,
          )
        ],
      ),
    );
  }
}
