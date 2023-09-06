import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kendamanomics_mobile/extensions/custom_colors.dart';
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
            const Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.16),
              child: const CustomInputField(),
            ),
            const Spacer(),
            ClickableLink(
              clickableText: 'forgot password',
              onClick: () {},
            ),
            const Spacer(),
            CustomButton(
              text: 'Login',
              isEnabled: true,
              onPressed: () {
                context.goNamed(Leaderboard.pageName);
              },
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
