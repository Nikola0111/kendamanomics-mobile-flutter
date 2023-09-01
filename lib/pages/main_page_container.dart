import 'package:flutter/material.dart';
import 'package:kendamanomics_mobile/extensions/custom_colors.dart';
import 'package:kendamanomics_mobile/providers/main_page_container_provider.dart';
import 'package:kendamanomics_mobile/widgets/app_header.dart';
import 'package:kendamanomics_mobile/widgets/bottom_navigation.dart';
import 'package:provider/provider.dart';

class MainPageContainer extends StatelessWidget {
  final Widget child;
  const MainPageContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MainPageContainerProvider(),
      child: Consumer<MainPageContainerProvider>(
        builder: (context, mainPageContainerProvider, _) {
          return ColoredBox(
            color: CustomColors.of(context).backgroundColor,
            child: Column(
              children: [
                const AppHeader(),
                child,
                const BottomNavigation(),
              ],
            ),
          );
        },
      ),
    );
  }
}
