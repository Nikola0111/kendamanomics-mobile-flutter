import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:go_router/go_router.dart';
import 'package:kendamanomics_mobile/extensions/custom_colors.dart';
import 'package:kendamanomics_mobile/helpers/helper.dart';
import 'package:kendamanomics_mobile/helpers/snackbar_helper.dart';
import 'package:kendamanomics_mobile/pages/forgot_password_page.dart';
import 'package:kendamanomics_mobile/pages/leaderboard.dart';
import 'package:kendamanomics_mobile/pages/register_shell.dart';
import 'package:kendamanomics_mobile/providers/login_page_provider.dart';
import 'package:kendamanomics_mobile/widgets/app_header.dart';
import 'package:kendamanomics_mobile/widgets/clickable_link.dart';
import 'package:kendamanomics_mobile/widgets/custom_button.dart';
import 'package:kendamanomics_mobile/widgets/custom_input_field.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  static const pageName = 'login';
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: CustomColors.of(context).backgroundColor,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: ChangeNotifierProvider(
          create: (context) => LoginPageProvider(),
          child: Consumer<LoginPageProvider>(
            builder: (context, provider, child) {
              switch (provider.state) {
                case LoginState.waiting:
                case LoginState.success:
                  break;
                case LoginState.errorEmail:
                  SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackbarHelper.snackbar(text: 'snackbar.error_email'.tr(), context: context),
                    );
                  });
                  provider.resetState();
                  break;
                case LoginState.errorServer:
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
                    Positioned.fill(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const AppHeader(),
                            SizedBox(height: MediaQuery.of(context).size.height / 4),
                            CustomInputField(
                              textInputAction: TextInputAction.next,
                              hintText: 'input_fields.username'.tr(),
                              initialData: provider.email,
                              onChanged: (email) => provider.email = email,
                              validator: (value) => Helper.validateEmail(value),
                            ),
                            const SizedBox(height: 6.0),
                            CustomInputField(
                              textInputAction: TextInputAction.done,
                              hintText: 'input_fields.password'.tr(),
                              initialData: provider.password,
                              onChanged: (password) => provider.password = password,
                              validator: (value) => Helper.validatePassword(value),
                            ),
                            const SizedBox(height: 20.0),
                            ClickableLink(
                              clickableText: 'buttons.forgot_password'.tr(),
                              onClick: () {
                                context.pushNamed(ForgotPasswordPage.pageName);
                              },
                            ),
                            const SizedBox(height: 20.0),
                            ClickableLink(
                              clickableText: 'buttons.create_an_account'.tr(),
                              onClick: () {
                                context.pushNamed(RegisterShell.pageName);
                              },
                            ),
                            SizedBox(height: MediaQuery.of(context).size.height / 4),
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
                          text: 'buttons.login'.tr(),
                          isEnabled: provider.isButtonEnabled,
                          customTextColor: CustomColors.of(context).primary,
                          onPressed: () async {
                            FocusManager.instance.primaryFocus?.unfocus();
                            final logInSuccesfull = await provider.signIn();
                            if (!logInSuccesfull) return;
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
