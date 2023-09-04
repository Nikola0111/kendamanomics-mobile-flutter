import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kendamanomics_mobile/extensions/custom_colors.dart';
import 'package:kendamanomics_mobile/extensions/custom_text_styles.dart';

class RegisterPage extends StatelessWidget {
  static const pageName = 'register';
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.of(context).backgroundColor,
      body: PageView(
        scrollDirection: Axis.horizontal,
        children: [
          Center(
            child: Text(
              'register_page.title'.tr(),
              style: CustomTextStyles.of(context).regular16.apply(color: CustomColors.of(context).primaryText),
            ),
          )
        ],
      ),
    );
  }
}
