import 'package:flutter/material.dart';
import 'package:kendamanomics_mobile/extensions/custom_colors.dart';

class TamasPage extends StatelessWidget {
  static const pageName = 'tamas';
  const TamasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.of(context).backgroundColor,
      body: const Center(
        child: Text('Tamas page'),
      ),
    );
  }
}
