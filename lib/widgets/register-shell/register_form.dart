import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:go_router/go_router.dart';
import 'package:kendamanomics_mobile/extensions/custom_colors.dart';
import 'package:kendamanomics_mobile/extensions/custom_text_styles.dart';
import 'package:kendamanomics_mobile/helpers/helper.dart';
import 'package:kendamanomics_mobile/helpers/snackbar_helper.dart';
import 'package:kendamanomics_mobile/pages/tamas_page.dart';
import 'package:kendamanomics_mobile/providers/register_provider.dart';
import 'package:kendamanomics_mobile/widgets/custom_button.dart';
import 'package:kendamanomics_mobile/widgets/custom_input_field.dart';
import 'package:provider/provider.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RegisterProvider>(
      builder: (context, provider, child) {
        switch (provider.state) {
          case RegisterState.waiting:
          case RegisterState.success:
            break;
          case RegisterState.errorEmail:
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackbarHelper.snackbar(text: 'This email doesnt exist', context: context),
              );
            });
            provider.resetState();
            break;
          case RegisterState.errorServer:
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackbarHelper.snackbar(text: 'Error with the server', context: context),
              );
            });
            provider.resetState();
            break;
        }
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
                    initialData: provider.firstName,
                    onChanged: (firstName) => provider.firstName = firstName,
                    validator: (value) => Helper.validateName(value),
                  ),
                  const SizedBox(height: 6.0),
                  CustomInputField(
                    textInputAction: TextInputAction.next,
                    placeholder: 'input_fields.last_name'.tr(),
                    onChanged: (lastName) => provider.lastName = lastName,
                    validator: (value) => Helper.validateLastName(value),
                  ),
                  const SizedBox(height: 6.0),
                  CustomInputField(
                    textInputAction: TextInputAction.next,
                    placeholder: 'input_fields.email'.tr(),
                    onChanged: (email) => provider.email = email,
                    validator: (value) => Helper.validateEmail(value),
                  ),
                  const SizedBox(height: 6.0),
                  CustomInputField(
                    textInputAction: TextInputAction.next,
                    placeholder: 'input_fields.instagram_username'.tr(),
                    onChanged: (instagramUsername) => provider.instagramUsername = instagramUsername,
                  ),
                  const SizedBox(height: 6.0),
                  CustomInputField(
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    placeholder: 'input_fields.experience'.tr(),
                    validator: (value) => Helper.validateNumbers(value),
                    onChanged: (yearsPlaying) {
                      final intYearsPlaying = int.tryParse(yearsPlaying);
                      if (intYearsPlaying != null && intYearsPlaying <= 15) {
                        provider.yearsPlaying = intYearsPlaying;
                      } else {
                        provider.yearsPlaying = -1;
                      }
                    },
                  ),
                  const SizedBox(height: 6.0),
                  CustomInputField(
                    textInputAction: TextInputAction.next,
                    placeholder: 'input_fields.support'.tr(),
                    onChanged: (supportTeamID) => provider.supportTeamID = supportTeamID,
                  ),
                  const SizedBox(height: 6.0),
                  CustomInputField(
                    obscurable: true,
                    textInputAction: TextInputAction.next,
                    placeholder: 'input_fields.password'.tr(),
                    onChanged: (password) => provider.password = password,
                    validator: (value) => Helper.validatePassword(value),
                  ),
                  const SizedBox(height: 6.0),
                  CustomInputField(
                    obscurable: true,
                    textInputAction: TextInputAction.done,
                    placeholder: 'input_fields.confirm_password'.tr(),
                    onChanged: (confirmPassword) => provider.confirmPassword = confirmPassword,
                    validator: (value) => Helper.validateRepeatPassword(value, provider.password),
                  ),
                  Align(
                    heightFactor: 2.075,
                    alignment: Alignment.bottomCenter,
                    child: CustomButton(
                      isEnabled: provider.isButtonEnabled,
                      text: 'buttons.create_an_account'.tr(),
                      customTextColor: CustomColors.of(context).primary,
                      onPressed: () async {
                        FocusManager.instance.primaryFocus?.unfocus();
                        await provider.signUp(provider.email, provider.password);
                        await provider.updateData();
                        if (context.mounted) {
                          context.goNamed(TamasPage.pageName);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
