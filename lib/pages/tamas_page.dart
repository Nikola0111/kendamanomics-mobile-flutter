import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kendamanomics_mobile/extensions/custom_colors.dart';
import 'package:kendamanomics_mobile/extensions/custom_text_styles.dart';
import 'package:kendamanomics_mobile/providers/tamas_provider.dart';
import 'package:kendamanomics_mobile/widgets/tama_widget.dart';
import 'package:provider/provider.dart';

class TamasPage extends StatelessWidget {
  static const pageName = 'tamas';
  const TamasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.of(context).backgroundColor,
      body: ChangeNotifierProvider(
        create: (context) => TamasProvider(),
        builder: (context, child) => Consumer<TamasProvider>(
          builder: (context, provider, child) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: PageView.builder(
                  onPageChanged: (index) {
                    provider.currentPage = index;
                  },
                  itemCount: provider.tamasGroup.length,
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            provider.tamasGroup[index].name ?? 'default_titles.tama_group'.tr(),
                            style: CustomTextStyles.of(context).regular25.apply(color: CustomColors.of(context).primary),
                          ),
                        ),
                        const SizedBox(height: 32),
                        Expanded(
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                              children: [
                                for (int tamaIndex = 0;
                                    tamaIndex < provider.tamasGroup[index].playerTamas.length;
                                    tamaIndex++) ...[
                                  TamaWidget(playerTama: provider.tamasGroup[index].playerTamas[tamaIndex]),
                                  if (tamaIndex != provider.tamasGroup[index].playerTamas.length - 1)
                                    const SizedBox(height: 24),
                                ],
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                      ],
                    );
                  },
                ),
              ),
              if (provider.tamasGroup.length > 1) buildIndicator(context, provider.currentPage, provider.tamasGroup.length),
              const SizedBox(height: 8),
            ],
          ),
        ),
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
