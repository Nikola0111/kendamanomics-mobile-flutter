import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:go_router/go_router.dart';
import 'package:kendamanomics_mobile/extensions/custom_colors.dart';
import 'package:kendamanomics_mobile/helpers/helper.dart';
import 'package:kendamanomics_mobile/helpers/snackbar_helper.dart';
import 'package:kendamanomics_mobile/pages/leaderboard.dart';
import 'package:kendamanomics_mobile/pages/register_shell.dart';
import 'package:kendamanomics_mobile/providers/forgot_password_provider.dart';
import 'package:kendamanomics_mobile/providers/login_page_provider.dart';
import 'package:kendamanomics_mobile/widgets/app_header.dart';
import 'package:kendamanomics_mobile/widgets/clickable_link.dart';
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
      body: GestureDetector(
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
                      SnackbarHelper.snackbar(text: 'This email doesnt exist', context: context),
                    );
                  });
                  provider.resetState();
                  break;
              }
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const AppHeader(),
                            SizedBox(height: MediaQuery.of(context).size.height / 3.1),
                            CustomInputField(
                              textInputAction: TextInputAction.next,
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
                      left: 0,
                      right: 0,
                      bottom: 20,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: CustomButton(
                          text: 'buttons.reset_password'.tr(),
                          isEnabled: provider.isButtonEnabled,
                          customTextColor: CustomColors.of(context).primary,
                          onPressed: () async {
                            FocusManager.instance.primaryFocus?.unfocus();

                            if (context.mounted) {
                              context.goNamed(Leaderboard.pageName);
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
    );
  }
}
