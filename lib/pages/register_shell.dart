import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kendamanomics_mobile/extensions/custom_colors.dart';
import 'package:kendamanomics_mobile/extensions/custom_text_styles.dart';
import 'package:kendamanomics_mobile/widgets/register-shell/register_description.dart';
import 'package:kendamanomics_mobile/widgets/register-shell/register_input.dart';
import 'package:kendamanomics_mobile/widgets/register-shell/register_ranking.dart';
import 'package:kendamanomics_mobile/widgets/register-shell/register_welcome.dart';

class RegisterShell extends StatelessWidget {
  static const pageName = 'register';
  const RegisterShell({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.of(context).backgroundColor,
      body: SafeArea(
        child: NotificationListener(
          onNotification: (notification) {
            if (notification is ScrollEndNotification) {
              FocusManager.instance.primaryFocus?.unfocus();
            }
            return false;
          },
          child: PageView(
            children: const [
              RegisterWelcome(),
              RegisterDescription(),
              RegisterRanking(),
              RegisterInput(),
            ],
          ),
        ),
      ),
    );
  }
}
