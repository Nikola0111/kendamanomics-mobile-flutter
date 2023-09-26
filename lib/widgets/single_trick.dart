import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kendamanomics_mobile/extensions/custom_colors.dart';
import 'package:kendamanomics_mobile/extensions/custom_text_styles.dart';
import 'package:kendamanomics_mobile/models/tama_trick_progress.dart';
import 'package:kendamanomics_mobile/pages/upload_trick.dart';

class SingleTrick extends StatelessWidget {
  final TamaTrickProgress trickProgress;
  const SingleTrick({super.key, required this.trickProgress});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(UploadTrick.pageName, extra: trickProgress.trick?.id);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 0.5, color: Colors.black.withOpacity(0.3)))),
        child: Row(
          children: [
            Expanded(
              child: Text(
                '${trickProgress.trickPosition}. ${trickProgress.trick?.name}',
                style: CustomTextStyles.of(context).regular16.apply(color: CustomColors.of(context).primaryText),
              ),
            ),
            if (trickProgress.trickStatus != TrickStatus.none) ...[
              const SizedBox(width: 8.0),
              _getStatusImage(),
              const SizedBox(width: 8.0),
            ],
          ],
        ),
      ),
    );
  }

  Widget _getStatusImage() {
    switch (trickProgress.trickStatus) {
      case TrickStatus.approved:
        return Image.asset('assets/icon/icon_trick_approved.png', height: 18, width: 18);
      case TrickStatus.denied:
        return Image.asset('assets/icon/icon_trick_denied.png', height: 18, width: 18);
      case TrickStatus.pending:
        return Image.asset('assets/icon/icon_trick_pending.png', height: 18, width: 18);
      default:
        return Container();
    }
  }
}
