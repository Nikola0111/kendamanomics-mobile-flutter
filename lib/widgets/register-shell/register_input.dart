import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kendamanomics_mobile/extensions/custom_colors.dart';
import 'package:kendamanomics_mobile/extensions/custom_text_styles.dart';
import 'package:kendamanomics_mobile/widgets/custom_button.dart';
import 'package:kendamanomics_mobile/widgets/custom_input_field.dart';

class RegisterInput extends StatelessWidget {
  const RegisterInput({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 140.0),
              child: Text(
                'register_page.fill_in_fields',
                style: CustomTextStyles.of(context).regular25.apply(color: CustomColors.of(context).primaryText),
                textAlign: TextAlign.center,
              ).tr(),
            ),
            const CustomInputField(
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 6.0),
            const CustomInputField(
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 6.0),
            const CustomInputField(
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 6.0),
            const CustomInputField(
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 6.0),
            const CustomInputField(
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 6.0),
            const CustomInputField(
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 6.0),
            const CustomInputField(
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 6.0),
            const CustomInputField(
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: 100.0),
            CustomButton(
              text: 'buttons.create_an_account',
              customTextColor: CustomColors.of(context).primary,
            ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
