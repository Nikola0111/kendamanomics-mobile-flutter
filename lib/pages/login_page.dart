import 'package:flutter/material.dart';
import 'package:kendamanomics_mobile/extensions/custom_colors.dart';
import 'package:kendamanomics_mobile/widgets/app_header.dart';
import 'package:kendamanomics_mobile/widgets/clickable_link.dart';
import 'package:kendamanomics_mobile/widgets/custom_input_field.dart';

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
          const CustomInputField(),
          const Spacer(),
          ClickableLink(
            clickableText: 'forgot password',
            onClick: () {},
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
