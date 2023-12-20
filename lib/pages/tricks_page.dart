import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kendamanomics_mobile/extensions/custom_colors.dart';
import 'package:kendamanomics_mobile/providers/tricks_provider.dart';
import 'package:kendamanomics_mobile/widgets/single_trick.dart';
import 'package:kendamanomics_mobile/widgets/title_widget.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

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
                    TitleWidget(
                      angle: pi / 2,
                      title: _formatTitle(provider),
                    ),
                    Expanded(child: _getContent(context, provider: provider)),
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

  Widget _getContent(BuildContext context, {required TricksProvider provider}) {
    if (provider.state == TrickState.loading) {
      return Column(
        children: [
          _shimmer(context),
          _shimmer(context),
          _shimmer(context),
          _shimmer(context),
        ],
      );
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: provider.tricks.length,
      itemBuilder: (context, index) => SingleTrick(
        trickProgress: provider.tricks[index],
        index: index + 1,
        onReturn: () {
          provider.fetchTricksProgress();
        },
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

  Container _shimmer(BuildContext context) {
    return Container(
      height: 19 + 2 * 16 - 0.5,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 0.5,
            color: Colors.black.withOpacity(0.3),
          ),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width - 2 * 18,
            height: 19, // height of text
            child: Shimmer.fromColors(
              baseColor: Colors.transparent,
              highlightColor: Colors.grey.withOpacity(0.5),
              child: SizedBox(
                width: MediaQuery.of(context).size.width - 2 * 18,
                height: 19,
                child: Container(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
