import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:go_router/go_router.dart';
import 'package:kendamanomics_mobile/extensions/custom_colors.dart';
import 'package:kendamanomics_mobile/extensions/custom_text_styles.dart';
import 'package:kendamanomics_mobile/helpers/helper.dart';
import 'package:kendamanomics_mobile/helpers/snackbar_helper.dart';
import 'package:kendamanomics_mobile/pages/login_page.dart';
import 'package:kendamanomics_mobile/pages/select_company_page.dart';
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
          case RegisterState.loading:
          case RegisterState.waiting:
          case RegisterState.success:
            break;
          case RegisterState.errorEmail:
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackbarHelper.snackbar(text: 'snackbar.error_user_exists'.tr(), context: context),
              );
            });
            provider.resetState();
            break;
          case RegisterState.errorServer:
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackbarHelper.snackbar(text: 'snackbar.error_server'.tr(), context: context),
              );
            });
            provider.resetState();
            break;
        }
        return GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Stack(
              children: [
                Positioned.fill(
                  bottom: MediaQuery.of(context).size.height * 0.125,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height / 11.0),
                          child: Text(
                            'register_page.fill_in_fields',
                            style: CustomTextStyles.of(context).regular25.apply(color: CustomColors.of(context).primaryText),
                            textAlign: TextAlign.center,
                          ).tr(),
                        ),
                        CustomInputField(
                          textInputAction: TextInputAction.next,
                          hintText: 'input_fields.first_name'.tr(),
                          initialData: provider.firstName,
                          onChanged: (firstName) => provider.firstName = firstName,
                          validator: (value) => Helper.validateName(value),
                        ),
                        const SizedBox(height: 6.0),
                        CustomInputField(
                          textInputAction: TextInputAction.next,
                          hintText: 'input_fields.last_name'.tr(),
                          onChanged: (lastName) => provider.lastName = lastName,
                          validator: (value) => Helper.validateLastName(value),
                        ),
                        const SizedBox(height: 6.0),
                        CustomInputField(
                          textInputAction: TextInputAction.next,
                          hintText: 'input_fields.email'.tr(),
                          onChanged: (email) => provider.email = email,
                          validator: (value) => Helper.validateEmail(value),
                        ),
                        const SizedBox(height: 6.0),
                        CustomInputField(
                          textInputAction: TextInputAction.next,
                          hintText: 'input_fields.instagram_username'.tr(),
                          onChanged: (instagramUsername) => provider.instagramUsername = instagramUsername,
                        ),
                        const SizedBox(height: 6.0),
                        CustomInputField(
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          hintText: 'input_fields.experience'.tr(),
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
                          suffixIcon: Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: Transform.rotate(
                              angle: -pi / 2,
                              child: Image.asset('assets/icon/icon_arrow.png', height: 16.0, width: 16.0),
                            ),
                          ),
                          textInputAction: TextInputAction.next,
                          hintText: 'input_fields.support'.tr(),
                          controller: provider.supportTeamNameController,
                          onTap: () async {
                            FocusManager.instance.primaryFocus?.unfocus();
                            final data = await context.pushNamed(SelectCompanyPage.pageName);
                            if (data != null) {
                              final map = data as Map<String, dynamic>;
                              provider.setSupportTeamID(map['id'], map['name']);
                            }
                          },
                        ),
                        const SizedBox(height: 6.0),
                        CustomInputField(
                          obscurable: true,
                          textInputAction: TextInputAction.next,
                          hintText: 'input_fields.password'.tr(),
                          onChanged: (password) => provider.password = password,
                          validator: (value) => Helper.validatePassword(value),
                        ),
                        const SizedBox(height: 6.0),
                        CustomInputField(
                          obscurable: true,
                          textInputAction: TextInputAction.done,
                          hintText: 'input_fields.confirm_password'.tr(),
                          onChanged: (confirmPassword) => provider.confirmPassword = confirmPassword,
                          validator: (value) => Helper.validateRepeatPassword(value, provider.password),
                        ),
                        SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      CustomButton(
                        isBackButton: true,
                        buttonStyle: CustomButtonStyle.medium,
                        isEnabled: true,
                        customTextColor: Colors.black,
                        text: 'register_page.back_to_login'.tr(),
                        onPressed: () {
                          context.goNamed(LoginPage.pageName);
                        },
                      ),
                      const SizedBox(height: 10.0),
                      CustomButton(
                        buttonStyle: CustomButtonStyle.medium,
                        isLoading: provider.state == RegisterState.loading,
                        isEnabled: provider.isButtonEnabled,
                        text: 'buttons.create_an_account'.tr(),
                        customTextColor: CustomColors.of(context).primary,
                        onPressed: () async {
                          FocusManager.instance.primaryFocus?.unfocus();
                          final signUpSuccessful = await provider.signUp(provider.email, provider.password);
                          if (!signUpSuccessful) return;

                          final updateDataSuccessful = await provider.updateData();
                          if (!updateDataSuccessful) return;

                          if (context.mounted) {
                            context.goNamed(TamasPage.pageName);
                          }
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
