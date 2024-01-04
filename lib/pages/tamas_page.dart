import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kendamanomics_mobile/extensions/custom_colors.dart';
import 'package:kendamanomics_mobile/pages/tricks_page.dart';
import 'package:kendamanomics_mobile/providers/tamas_provider.dart';
import 'package:kendamanomics_mobile/widgets/tama_page_group.dart';
import 'package:provider/provider.dart';

class TamasPage extends StatelessWidget {
  static const pageName = 'tamas';
  const TamasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TamasProvider(),
      builder: (context, child) => Consumer<TamasProvider>(
        builder: (context, provider, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: PageView.builder(
                  controller: provider.controller,
                  onPageChanged: (index) => provider.pageUpdated(),
                  itemCount: provider.tamasGroup.length,
                  itemBuilder: (context, index) => TamaPageGroup(
                    group: provider.tamasGroup[index],
                    state: provider.state,
                    showPurchaseOverlay: provider.showPurchaseOverlay(provider.tamasGroup[index].id ?? ''),
                    onTamaPressed: (String? tamaID) {
                      context.pushNamed(TricksPage.pageName, extra: tamaID);
                    },
                  ),
                ),
              ),
              if (provider.tamasGroup.length > 1) ...[
                buildIndicator(context, provider.currentPage, provider.tamasGroup.length),
                const SizedBox(height: 8),
              ]
            ],
          );
        },
      ),
    );
  }

  Widget buildIndicator(BuildContext context, int currentPage, int numOfPages) {
    return AnimatedPadding(
      duration: const Duration(milliseconds: 450),
      curve: Curves.linearToEaseOut,
      padding: EdgeInsets.only(left: (MediaQuery.of(context).size.width / numOfPages) * currentPage),
      child: Container(
        height: 4.0,
        width: MediaQuery.of(context).size.width / numOfPages,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(80.0),
          shape: BoxShape.rectangle,
          color: CustomColors.of(context).activeIndicatorColor,
        ),
      ),
    );
  }
}
