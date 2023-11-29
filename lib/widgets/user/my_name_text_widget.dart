//Responsive

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medic/_dart/_init.dart';
import 'package:medic/controller/home_controller.dart';
import 'package:medic/model/user_model.dart';
import 'package:medic/theme/colors.dart';
import 'package:medic/utils/app_font.dart';
import 'package:medic/widgets/circular_profile_avatar.dart';
import 'package:medic/widgets/custom_widget.dart';

class MyNameTextWidget extends StatelessWidget {
  final TextStyle? textStyle;

  UserController userController = Get.put(UserController());

  MyNameTextWidget({super.key, this.textStyle});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: userController.streamUser(userController.currentUserId!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CupertinoActivityIndicator());
        } else if (snapshot.hasData) {
          UserModel user = snapshot.data!;
          return TextWidget(
            user.name ?? "Medic User",
            style: textStyle ??
                Theme.of(context).textTheme.labelLarge!.copyWith(
                    fontFamily: AppFont.fontSemiBold,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.3,
                    fontSize: 15),
          );
        } else {
          return SizedBox();
        }
      },
    );
  }
}

//flutter pub add cloud_firestore

class MyNumberTextWidget extends StatelessWidget {
  final TextStyle? textStyle;

  UserController userController = Get.put(UserController());

  MyNumberTextWidget({super.key, this.textStyle});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: userController.streamUser(userController.currentUserId!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CupertinoActivityIndicator());
        } else if (snapshot.hasData) {
          UserModel user = snapshot.data!;
          return TextWidget(
            getMobileNo(user),
            style: textStyle ??
                Theme.of(context).textTheme.labelLarge!.copyWith(
                    fontFamily: AppFont.fontSemiBold,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.3,
                    fontSize: 15),
          );
        } else {
          return SizedBox();
        }
      },
    );
  }

  String getMobileNo(UserModel user) {
    if (user.mobileNo == null) {
      return '';
    }

    int? countryCode = user.countryCode;
    // int? countryCode = controller.loggedInUser.value?.countryCode;
    String? mobileNo = user.mobileNo ?? '';
    // String? mobileNo = controller.loggedInUser.value?.mobileNo ?? '';
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
