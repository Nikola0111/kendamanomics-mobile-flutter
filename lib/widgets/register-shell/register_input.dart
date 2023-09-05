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
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height / 8.0),
                child: Text(
                  'register_page.fill_in_fields',
                  style: CustomTextStyles.of(context).regular25.apply(color: CustomColors.of(context).primaryText),
                  textAlign: TextAlign.center,
                ).tr(),
              ),
              CustomInputField(
                textInputAction: TextInputAction.next,
                placeholder: 'input_fields.first_name'.tr(),
              ),
              const SizedBox(height: 6.0),
              CustomInputField(
                textInputAction: TextInputAction.next,
                placeholder: 'input_fields.last_name'.tr(),
              ),
              const SizedBox(height: 6.0),
              CustomInputField(
                textInputAction: TextInputAction.next,
                placeholder: 'input_fields.email'.tr(),
              ),
              const SizedBox(height: 6.0),
              CustomInputField(
                textInputAction: TextInputAction.next,
                placeholder: 'input_fields.instagram_username'.tr(),
              ),
              const SizedBox(height: 6.0),
              CustomInputField(
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                placeholder: 'input_fields.experience'.tr(),
              ),
              const SizedBox(height: 6.0),
              CustomInputField(
                textInputAction: TextInputAction.next,
                placeholder: 'input_fields.support'.tr(),
              ),
              const SizedBox(height: 6.0),
              CustomInputField(
                textInputAction: TextInputAction.next,
                placeholder: 'input_fields.password'.tr(),
              ),
              const SizedBox(height: 6.0),
              CustomInputField(
                textInputAction: TextInputAction.done,
                placeholder: 'input_fields.confirm_password'.tr(),
              ),
              const SizedBox(height: 30.0),
              CustomButton(
                text: 'buttons.create_an_account'.tr(),
                customTextColor: CustomColors.of(context).primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
