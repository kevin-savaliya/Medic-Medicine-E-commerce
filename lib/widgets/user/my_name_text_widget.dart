//Responsive

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medic/controller/home_controller.dart';
import 'package:medic/theme/colors.dart';
import 'package:medic/utils/app_font.dart';
import 'package:medic/widgets/circular_profile_avatar.dart';
import 'package:medic/widgets/custom_widget.dart';

class MyNameTextWidget extends GetWidget<HomeController> {
  final TextStyle? textStyle;

  const MyNameTextWidget({super.key, this.textStyle});

  @override
  Widget build(BuildContext context) {
    return Obx(() => TextWidget(
          controller.loggedInUser.value?.name ?? '',
          style: textStyle ??
              Theme.of(context).textTheme.labelLarge!.copyWith(
                  fontFamily: AppFont.fontSemiBold,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.3,
                  fontSize: 15),
        ));
  }
}

//flutter pub add cloud_firestore

class MyNumberTextWidget extends GetWidget<HomeController> {
  final TextStyle? textStyle;

  const MyNumberTextWidget({super.key, this.textStyle});

  @override
  Widget build(BuildContext context) {
    return Obx(() => TextWidget(
          getMobileNo(),
          style: textStyle ??
              Theme.of(context).textTheme.labelLarge!.copyWith(
                  fontFamily: AppFont.fontSemiBold,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.3,
                  fontSize: 15),
        ));
  }

  String getMobileNo() {
    if (controller.loggedInUser.value?.mobileNo == null) {
      return '';
    }

    int? countryCode = controller.loggedInUser.value?.countryCode;
    String? mobileNo = controller.loggedInUser.value?.mobileNo ?? '';
    return '+${countryCode ?? ''} $mobileNo';
  }
}

class MyProfilePicWidget extends GetWidget<HomeController> {
  final Size? size;

  const MyProfilePicWidget({super.key, this.size});

  @override
  Widget build(BuildContext context) {
    return Obx(() => SizedBox(
          height: size?.height ?? 40,
          width: size?.width ?? 40,
          child: ClipOval(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: CircularProfileAvatar(
              controller.loggedInUser.value?.profilePicture ?? '',
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
              radius: 10,
              errorWidget: (context, url, error) =>
                  Icon(Icons.error, color: AppColors.primaryColor),
            ),
          ),
        ));
  }
}
