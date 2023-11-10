import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:kendamanomics_mobile/extensions/custom_colors.dart';
import 'package:kendamanomics_mobile/extensions/custom_text_styles.dart';
import 'package:kendamanomics_mobile/models/company.dart';
import 'package:kendamanomics_mobile/widgets/damx_points.dart';

class ProfileHeader extends StatelessWidget {
  final int damxPoints;
  final String? profileImageUrl;
  final Company? company;
  final String name;
  final VoidCallback onProfilePicturePressed;
  final bool canPickTeam;
  final void Function() onCompanyPressed;
  const ProfileHeader({
    super.key,
    required this.damxPoints,
    required this.profileImageUrl,
    required this.company,
    required this.name,
    required this.onProfilePicturePressed,
    required this.onCompanyPressed,
    this.canPickTeam = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const DamxPoints(
                damxPoints: 0,
                placeholder: true,
              ),
              GestureDetector(
                onTap: () => onProfilePicturePressed(),
                child: ClipOval(child: _getImage(context)),
              ),
              if (canPickTeam)
                GestureDetector(
                  onTap: onCompanyPressed,
                  child: _getCompanyWidget(context),
                ),
              if (!canPickTeam) _getCompanyWidget(context),
            ],
          ),
          const SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                name,
                style: CustomTextStyles.of(context).regular20.apply(color: CustomColors.of(context).primaryText),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Image _getImage(BuildContext context) {
    if (profileImageUrl == null) {
      return Image.asset(
        'assets/images/user_image_placeholder.png',
        height: MediaQuery.of(context).size.width / 2.7,
        width: MediaQuery.of(context).size.width / 2.7,
      );
    }

    return Image.network(
      profileImageUrl!,
      height: MediaQuery.of(context).size.width / 2.7,
      width: MediaQuery.of(context).size.width / 2.7,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(
          'assets/images/user_image_placeholder.png',
          height: MediaQuery.of(context).size.width / 2.7,
          width: MediaQuery.of(context).size.width / 2.7,
        );
      },
    );
  }

  Widget _getCompanyWidget(BuildContext context) {
    if (company != null) {
      if (company?.imageUrl != null && !company!.imageUrl!.endsWith('company_images/')) {
        return Image.network(
          company!.imageUrl!,
          height: MediaQuery.of(context).size.width / 5.5,
          width: MediaQuery.of(context).size.width / 5.5,
          errorBuilder: (p1, p2, p3) {
            return SizedBox(
              width: MediaQuery.of(context).size.width / 5.5,
              child: Center(
                child: Text(company!.name, style: CustomTextStyles.of(context).regular18),
              ),
            );
          },
        );
      } else {
        return SizedBox(
          width: MediaQuery.of(context).size.width / 5.5,
          child: Center(
            child: Text(company!.name, style: CustomTextStyles.of(context).regular18),
          ),
        );
      }
    }

    if (canPickTeam) {
      return SizedBox(
        width: MediaQuery.of(context).size.width / 5.5,
        child: Center(
          child: Text(
            'profile_page.pick_team',
            style: CustomTextStyles.of(context).regular18,
            textAlign: TextAlign.center,
          ).tr(),
        ),
      );
    } else {
      return SizedBox(width: MediaQuery.of(context).size.width / 5.5);
    }
  }
}
