import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:kendamanomics_mobile/extensions/custom_colors.dart';
import 'package:kendamanomics_mobile/models/bottom_navigation_data.dart';
import 'package:kendamanomics_mobile/providers/main_page_container_provider.dart';
import 'package:kendamanomics_mobile/widgets/app_header.dart';
import 'package:kendamanomics_mobile/widgets/bottom_navigation.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class MainPageContainer extends StatelessWidget {
  final Widget routerWidget;
  const MainPageContainer({super.key, required this.routerWidget});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MainPageContainerProvider(defaultBackgroundColor: CustomColors.of(context).backgroundColor),
      builder: (context, _) {
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          context.read<MainPageContainerProvider>().resetBackgroundColor();
        });
        return Consumer<MainPageContainerProvider>(
          child: SafeArea(
            child: Column(
              children: [
                const AppHeader(),
                const SizedBox(height: 12),
                Expanded(
                  key: context.read<MainPageContainerProvider>().contentGlobalKey,
                  child: routerWidget,
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
          builder: (context, provider, nonRebuiltChild) {
            return TweenAnimationBuilder<Color?>(
              tween: provider.backgroundTween ??
                  ColorTween(
                    end: CustomColors.of(context).backgroundColor,
                    begin: CustomColors.of(context).backgroundColor,
                  ),
              duration: const Duration(milliseconds: 400),
              builder: (_, color, __) {
                print(color);
                return Scaffold(
                  backgroundColor: color ?? CustomColors.of(context).backgroundColor,
                  body: nonRebuiltChild,
                );
              },
            );
          },
        );
      },
    );
  }
}
