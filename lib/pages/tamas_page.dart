import 'package:flutter/material.dart';
import 'package:kendamanomics_mobile/extensions/custom_colors.dart';
import 'package:kendamanomics_mobile/services/auth_service.dart';
import 'package:kiwi/kiwi.dart';

class TamasPage extends StatelessWidget {
  static const pageName = 'tamas';
  const TamasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.of(context).backgroundColor,
      body: Center(
        child: Text('Hello ${KiwiContainer().resolve<AuthService>().player?.firstName}'),
      ),
    );
  }
}
