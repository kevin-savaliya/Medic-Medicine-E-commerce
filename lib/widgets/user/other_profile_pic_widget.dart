import 'package:flutter/material.dart';
import 'package:medic/theme/colors.dart';
import 'package:medic/utils/app_font.dart';
import 'package:medic/widgets/circular_profile_avatar.dart';

class OtherProfilePicWidget extends StatelessWidget {
  final Size? size;
  final String? profilePictureUrl;
  const OtherProfilePicWidget(
      {super.key, this.size, required this.profilePictureUrl});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size?.height ?? 40,
      width: size?.width ?? 40,
      child: ClipOval(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: CircularProfileAvatar(
          profilePictureUrl ?? '',
          cacheImage: true,
          animateFromOldImageOnUrlChange: true,
          placeHolder: (context, url) => Container(
            color: AppColors.dark.withOpacity(0.3),
            child: Center(
              child: Text("MEDIC",
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      color: AppColors.white,
                      fontFamily: AppFont.fontSemiBold,
                      fontWeight: FontWeight.w500,
                      fontSize: 8)),
            ),
          ),
          radius: 24,
          errorWidget: (context, url, error) =>
              Icon(Icons.error, color: AppColors.primaryColor),
        ),
      ),
    );
  }
}
