import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:go_router/go_router.dart';
import 'package:kendamanomics_mobile/extensions/custom_colors.dart';
import 'package:kendamanomics_mobile/helpers/helper.dart';
import 'package:kendamanomics_mobile/helpers/snackbar_helper.dart';
import 'package:kendamanomics_mobile/pages/login_page.dart';
import 'package:kendamanomics_mobile/providers/change_password_page_provider.dart';
import 'package:kendamanomics_mobile/widgets/app_header.dart';
import 'package:kendamanomics_mobile/widgets/custom_button.dart';
import 'package:kendamanomics_mobile/widgets/custom_input_field.dart';
import 'package:provider/provider.dart';

class ChangePasswordPage extends StatelessWidget {
  static const pageName = 'change-password-page';
  final String email;
  const ChangePasswordPage({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: CustomColors.of(context).backgroundColor,
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: ChangeNotifierProvider(
            create: (context) => ChangePasswordPageProvider(),
            child: Consumer<ChangePasswordPageProvider>(
              builder: (context, provider, child) {
                switch (provider.state) {
                  case ChangePasswordState.none:
                  case ChangePasswordState.loading:
                  case ChangePasswordState.success:
                    break;
                  case ChangePasswordState.errorPassword:
                    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackbarHelper.snackbar(text: 'snackbar.error_email'.tr(), context: context),
                      );
                    });
                    provider.resetState();
                    break;
                  case ChangePasswordState.errorServer:
                    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackbarHelper.snackbar(text: 'snackbar.error_server'.tr(), context: context),
                      );
                    });
                    provider.resetState();
                    break;
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Stack(
                    children: [
                      const Positioned(top: 0, left: 0, right: 0, child: AppHeader()),
                      Positioned.fill(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(height: MediaQuery.of(context).size.height / 3.1),
                              CustomInputField(
                                textInputAction: TextInputAction.next,
                                hintText: 'input_fields.verification_code'.tr(),
                                initialData: provider.verificationCode,
                                onChanged: (verificationCode) => provider.verificationCode = verificationCode,
                                validator: (value) => Helper.validateCodes(value),
                                keyboardType: TextInputType.number,
                              ),
                              const SizedBox(height: 6.0),
                              CustomInputField(
                                textInputAction: TextInputAction.next,
                                hintText: 'input_fields.new_password'.tr(),
                                initialData: provider.newPassword,
                                onChanged: (newPassword) => provider.newPassword = newPassword,
                                validator: (value) => Helper.validatePassword(value),
                                obscurable: true,
                              ),
                              const SizedBox(height: 6.0),
                              CustomInputField(
                                textInputAction: TextInputAction.done,
                                hintText: 'input_fields.confirm_new_password'.tr(),
                                initialData: provider.confirmNewPassword,
                                onChanged: (confirmNewPassword) => provider.confirmNewPassword = confirmNewPassword,
                                validator: (value) => Helper.validateRepeatPassword(value, provider.newPassword),
                                obscurable: true,
                              ),
                              SizedBox(height: MediaQuery.of(context).size.height / 4.0),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: CustomButton(
                            text: 'buttons.change_password'.tr(),
                            isEnabled: provider.isButtonEnabled,
                            isLoading: provider.state == ChangePasswordState.loading,
                            customTextColor: CustomColors.of(context).primary,
                            onPressed: () async {
                              FocusManager.instance.primaryFocus?.unfocus();
                              final verifyOTPSuccessful = await provider.verifyOTP(email);
                              if (!verifyOTPSuccessful) return;
                              final updatePasswordSuccessful = await provider.updateUserPassword(email);
                              if (!updatePasswordSuccessful) return;
                              if (context.mounted) {
                                context.goNamed(LoginPage.pageName);
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
