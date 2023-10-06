import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kendamanomics_mobile/extensions/custom_colors.dart';
import 'package:kendamanomics_mobile/extensions/custom_text_styles.dart';
import 'package:kendamanomics_mobile/providers/tricks_provider.dart';
import 'package:kendamanomics_mobile/widgets/single_trick.dart';
import 'package:provider/provider.dart';

class TricksPage extends StatelessWidget {
  static const pageName = 'tricks-page';
  final String? tamaId;
  const TricksPage({super.key, required this.tamaId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.of(context).backgroundColor,
      body: SafeArea(
        child: ChangeNotifierProvider(
          create: (context) => TricksProvider(tamaId: tamaId!),
          child: Consumer<TricksProvider>(
            builder: (context, provider, child) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Column(
                  children: [
                    Text(
                      _formatTitle(provider),
                      style: CustomTextStyles.of(context).regular25.apply(color: CustomColors.of(context).primary),
                    ),
                    Expanded(
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: provider.tricks.length,
                        itemBuilder: (context, index) => SingleTrick(trickProgress: provider.tricks[index]),
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  String _formatTitle(TricksProvider provider) {
    if (provider.tamaName != null && provider.tamaGroupName != null) {
      return '${provider.tamaName} ${provider.tamaGroupName} ${'tricks_page.tricks'.tr()}';
    }

    if (provider.tamaGroupName != null) {
      return '${provider.tamaGroupName} ${'tricks_page.tricks'.tr()}';
    }

    if (provider.tamaName != null) {
      return '${provider.tamaName} ${'tricks_page.tricks'.tr()}';
    }

    return 'default_titles.tama'.tr();
  }
}
