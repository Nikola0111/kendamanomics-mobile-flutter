import 'package:flutter/material.dart';
import 'package:kendamanomics_mobile/extensions/custom_colors.dart';
import 'package:kendamanomics_mobile/extensions/custom_text_styles.dart';

class PlayerEntry extends StatelessWidget {
  const PlayerEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //context.pushNamed(ProfilePage.pageName);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 0.5, color: Colors.black.withOpacity(0.3)))),
        child: Row(
          children: [
            Expanded(
              child: Text(
                'Player name',
                style: CustomTextStyles.of(context).regular16.apply(color: CustomColors.of(context).primaryText),
              ),
            ),
            const SizedBox(width: 8.0),
            Text('234234'),
            const SizedBox(width: 8.0),
          ],
        ),
      ),
    );
  }
}
