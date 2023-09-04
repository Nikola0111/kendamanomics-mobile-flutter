import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kendamanomics_mobile/extensions/custom_colors.dart';
import 'package:kendamanomics_mobile/extensions/custom_text_styles.dart';
import 'package:kendamanomics_mobile/providers/register_provider.dart';
import 'package:provider/provider.dart';

class RegisterShell extends StatelessWidget {
  static const pageName = 'register';
  const RegisterShell({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: CustomColors.of(context).backgroundColor,
      body: SafeArea(
        child: ChangeNotifierProvider(
          create: (context) => RegisterProvider(),
          builder: (context, child) => Consumer<RegisterProvider>(
            builder: (context, provider, child) => NotificationListener(
              // onNotification: (notification) {
              //   if (notification is ScrollStartNotification) {
              //     consider adding int index to the pages so we can keep the keyboard up properly even on vertical scroll
              //     FocusManager.instance.primaryFocus?.unfocus();
              //   }
              //   return false;
              // },
              child: Stack(
                children: [
                  Positioned(
                    bottom: 0,
                    top: 0,
                    right: 0,
                    left: 0,
                    child: PageView.builder(
                      controller: PageController(initialPage: provider.currentPage),
                      itemCount: 4,
                      onPageChanged: (value) {
                        provider.setCurrentPage(value);
                      },
                      itemBuilder: (context, index) {
                        return provider.pages[index];
                      },
                    ),
                  ),
                  Positioned(
                    bottom: 12.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        provider.pages.length,
                        (index) => buildIndicator(index, provider.currentPage, context),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildIndicator(int index, int currentPage, BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 4,
      height: 4.0,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: index == currentPage ? CustomColors.of(context).activeIndicatorColor : Colors.transparent,
      ),
    );
  }
}
