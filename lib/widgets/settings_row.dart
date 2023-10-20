import 'package:flutter/material.dart';
import 'package:kendamanomics_mobile/extensions/custom_colors.dart';
import 'package:kendamanomics_mobile/extensions/custom_text_styles.dart';

class SettingsRow extends StatelessWidget {
  final String rowName;
  final String data;
  final VoidCallback? onPressed;
  final bool clickable;

  const SettingsRow({
    super.key,
    required this.rowName,
    required this.data,
    this.onPressed,
    required this.clickable,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: clickable
          ? () {
              if (onPressed != null) {
                onPressed!();
              }
            }
          : null,
      child: Column(
        children: [
          const SizedBox(height: 18.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(rowName, style: CustomTextStyles.of(context).regular20),
              Text(data, style: CustomTextStyles.of(context).regular20),
            ],
          ),
          const SizedBox(height: 12.0),
          Divider(height: 1, color: CustomColors.of(context).primaryText)
        ],
      ),
    );
  }
}
