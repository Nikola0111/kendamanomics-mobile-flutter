import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kendamanomics_mobile/extensions/custom_colors.dart';
import 'package:kendamanomics_mobile/pages/login_page.dart';
import 'package:kendamanomics_mobile/services/auth_service.dart';
import 'package:kendamanomics_mobile/widgets/custom_button.dart';
import 'package:kiwi/kiwi.dart';

class Profile extends StatelessWidget {
  static const pageName = 'profile';
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.of(context).backgroundColor,
      body: Center(
        child: CustomButton(
          text: 'logout',
          onPressed: () {
            KiwiContainer().resolve<AuthService>().signOut();
            context.goNamed(LoginPage.pageName);
          },
        ),
      ),
    );
  }
}
