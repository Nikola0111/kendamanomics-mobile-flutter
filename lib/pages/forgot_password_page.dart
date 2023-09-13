import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:go_router/go_router.dart';
import 'package:kendamanomics_mobile/extensions/custom_colors.dart';
import 'package:kendamanomics_mobile/helpers/helper.dart';
import 'package:kendamanomics_mobile/helpers/snackbar_helper.dart';
import 'package:kendamanomics_mobile/pages/change_password_page.dart';
import 'package:kendamanomics_mobile/providers/forgot_password_provider.dart';
import 'package:kendamanomics_mobile/widgets/app_header.dart';
import 'package:kendamanomics_mobile/widgets/custom_button.dart';
import 'package:kendamanomics_mobile/widgets/custom_input_field.dart';
import 'package:provider/provider.dart';

class ForgotPasswordPage extends StatelessWidget {
  static const pageName = 'forgot-password-page';
  const ForgotPasswordPage({super.key});

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
            create: (context) => ForgotPasswordPageProvider(),
            child: Consumer<ForgotPasswordPageProvider>(
              builder: (context, provider, child) {
                switch (provider.state) {
                  case ForgotPasswordPageState.waiting:
                  case ForgotPasswordPageState.success:
                    break;
                  case ForgotPasswordPageState.errorEmail:
                    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackbarHelper.snackbar(text: 'snackbar.error_email'.tr(), context: context),
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
                              SizedBox(height: MediaQuery.of(context).size.height / 2.5),
                              CustomInputField(
                                textInputAction: TextInputAction.done,
                                hintText: 'input_fields.email'.tr(),
                                initialData: provider.email,
                                onChanged: (email) => provider.email = email,
                                validator: (value) => Helper.validateEmail(value),
                              ),
                              SizedBox(height: MediaQuery.of(context).size.height / 4.0),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0.0,
                        right: 0.0,
                        bottom: 0.0,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: CustomButton(
                            text: 'buttons.reset_password'.tr(),
                            isEnabled: provider.isButtonEnabled,
                            customTextColor: CustomColors.of(context).primary,
                            onPressed: () async {
                              FocusManager.instance.primaryFocus?.unfocus();
                              final successful = await provider.sendPasswordResetCode();
                              if (!successful) return;
                              if (context.mounted) {
                                context.pushNamed(ChangePasswordPage.pageName, extra: provider.email);
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
