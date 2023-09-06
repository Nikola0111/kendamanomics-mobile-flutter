import 'package:flutter/material.dart';
import 'package:kendamanomics_mobile/extensions/custom_colors.dart';

class Profile extends StatelessWidget {
  static const pageName = 'profile';
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.of(context).backgroundColor,
      body: Center(
        child: Text('Profile'),
      ),
    );
  }
}
