import 'package:flutter/material.dart';
import 'package:kendamanomics_mobile/extensions/custom_colors.dart';
import 'package:kendamanomics_mobile/models/bottom_navigation_data.dart';
import 'package:kendamanomics_mobile/providers/main_page_container_provider.dart';
import 'package:kendamanomics_mobile/widgets/app_header.dart';
import 'package:kendamanomics_mobile/widgets/bottom_navigation.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class MainPageContainer extends StatelessWidget {
  final Widget child;
  const MainPageContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MainPageContainerProvider(),
      builder: (context, _) {
        return Scaffold(
          backgroundColor: CustomColors.of(context).backgroundColor,
          body: SafeArea(
            child: Column(
              children: [
                const AppHeader(),
                const SizedBox(height: 12),
                Expanded(
                  key: context.read<MainPageContainerProvider>().contentGlobalKey,
                  child: child,
                ),
                Selector<MainPageContainerProvider, Tuple2<int, List<BottomNavigationData>>>(
                  selector: (_, provider) => Tuple2(provider.pageIndex, provider.bottomNav),
                  builder: (context, tuple, child) {
                    return BottomNavigation(
                      items: tuple.item2,
                      pageIndex: tuple.item1,
                      onPageUpdated: (index) => context.read<MainPageContainerProvider>().pageIndex = index,
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
