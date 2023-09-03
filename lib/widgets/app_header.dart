import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final sidePadding = MediaQuery.of(context).size.width * 0.15;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          top: 12,
          left: sidePadding,
          right: sidePadding,
        ),
        child: Image.asset('assets/images/image_kendamanomics_header.png'),
      ),
    );
  }
}
