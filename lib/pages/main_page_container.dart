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
      child: Scaffold(
        backgroundColor: CustomColors.of(context).backgroundColor,
        body: Column(
          children: [
            const AppHeader(),
            Expanded(child: child),
            Selector<MainPageContainerProvider, int>(
              selector: (_, provider) => provider.pageIndex,
              builder: (context, pageIndex, child) {
                return BottomNavigation(
                  items: context.read<MainPageContainerProvider>().bottomNav,
                  pageIndex: pageIndex,
                  onPageUpdated: (index) => context.read<MainPageContainerProvider>().pageIndex = index,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
