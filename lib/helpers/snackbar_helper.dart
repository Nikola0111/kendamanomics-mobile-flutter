import 'package:flutter/material.dart';
import 'package:kendamanomics_mobile/extensions/custom_colors.dart';
import 'package:kendamanomics_mobile/extensions/custom_text_styles.dart';

enum SnackbarState { success, error }

class SnackbarHelper {
  static SnackBar snackbar({
    required String text,
    required BuildContext context,
  }) {
    return SnackBar(
      elevation: 4,
      padding: EdgeInsets.zero,
      behavior: SnackBarBehavior.fixed,
      duration: const Duration(seconds: 3),
      dismissDirection: DismissDirection.down,
      content: DecoratedBox(
        decoration: BoxDecoration(
          color: CustomColors.of(context).primary,
          borderRadius: const BorderRadius.all(Radius.circular(4)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Image.asset(
              //   'assets/icon/icon_warning.png',
              //   color: CustomColors.of(context).backgroundColor,
              // ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  text,
                  style: CustomTextStyles.of(context).light16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
