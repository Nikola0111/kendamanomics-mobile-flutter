import 'package:flutter/material.dart';
import 'package:kendamanomics_mobile/extensions/custom_colors.dart';
import 'package:kendamanomics_mobile/extensions/custom_text_styles.dart';
import 'package:kendamanomics_mobile/widgets/app_header.dart';

class LoginPage extends StatelessWidget {
  static const pageName = 'login';
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.of(context).backgroundColor,
      body: Column(
        children: [
          const AppHeader(),
          const Spacer(),
          Text(
            'Login',
            style: CustomTextStyles.of(context).light16,
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
