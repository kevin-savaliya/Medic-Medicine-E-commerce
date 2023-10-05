import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:medic/screen/myaddress_screen.dart';
import 'package:medic/screen/notification_screen.dart';
import 'package:medic/screen/order_history.dart';
import 'package:medic/theme/colors.dart';
import 'package:medic/utils/app_font.dart';
import 'package:medic/utils/assets.dart';
import 'package:medic/utils/string.dart';
import 'package:medic/widgets/app_dialogue.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: Text(ConstString.profile,
            style: Theme.of(context).textTheme.titleLarge),
        elevation: 1.5,
        shadowColor: AppColors.txtGrey.withOpacity(0.2),
      ),
      body: profileWidget(context),
    );
  }

  Container profileWidget(BuildContext context) {
    return Container(
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipOval(
                child: Container(
                  height: 90,
                  width: 90,
                  color: AppColors.primaryColor,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SvgPicture.asset(AppImages.medic_white_text),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Henry, Arthur",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontFamily: AppFont.fontBold),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "+91 2847456342",
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: AppColors.txtGrey.withOpacity(0.8),
                    fontFamily: AppFont.fontMedium),
              ),
              SizedBox(
                height: 25,
              ),
              ListTile(
                onTap: () {
                  Get.to(() => MyAddressScreen());
                },
                horizontalTitleGap: 0,
                leading: SvgPicture.asset(AppIcons.pin, height: 22),
                trailing: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 15,
                  color: AppColors.txtGrey,
                ),
                title: Text(
                  ConstString.myAddress,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontFamily: AppFont.fontBold, color: AppColors.txtGrey),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Container(
                  height: 1,
                  width: double.infinity,
                  color: AppColors.lineGrey,
                ),
              ),
              ListTile(
                onTap: () {
                  Get.to(() => OrderHistory());
                },
                horizontalTitleGap: 0,
                leading: SvgPicture.asset(AppIcons.timer, height: 22),
                trailing: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 15,
                  color: AppColors.txtGrey,
                ),
                title: Text(
                  ConstString.orderHistory,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontFamily: AppFont.fontBold, color: AppColors.txtGrey),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Container(
                  height: 1,
                  width: double.infinity,
                  color: AppColors.lineGrey,
                ),
              ),
              ListTile(
                onTap: () {},
                horizontalTitleGap: 0,
                leading: SvgPicture.asset(
                  AppIcons.reminder,
                  height: 21,
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 15,
                  color: AppColors.txtGrey,
                ),
                title: Text(
                  ConstString.reminder,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontFamily: AppFont.fontBold, color: AppColors.txtGrey),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Container(
                  height: 1,
                  width: double.infinity,
                  color: AppColors.lineGrey,
                ),
              ),
              ListTile(
                onTap: () {},
                horizontalTitleGap: 0,
                leading: SvgPicture.asset(
                  AppIcons.file,
                  color: AppColors.txtGrey,
                  height: 21,
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 15,
                  color: AppColors.txtGrey,
                ),
                title: Text(
                  ConstString.prescription,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontFamily: AppFont.fontBold, color: AppColors.txtGrey),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Container(
                  height: 1,
                  width: double.infinity,
                  color: AppColors.lineGrey,
                ),
              ),
              ListTile(
                onTap: () {
                  Get.to(() => NotificationScreen());
                },
                horizontalTitleGap: 0,
                leading: SvgPicture.asset(
                  AppIcons.notification,
                  height: 21,
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 15,
                  color: AppColors.txtGrey,
                ),
                title: Text(
                  ConstString.notification,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontFamily: AppFont.fontBold, color: AppColors.txtGrey),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Container(
                  height: 1,
                  width: double.infinity,
                  color: AppColors.lineGrey,
                ),
              ),
              ListTile(
                onTap: () {
                  logoutDialogue(context);
                },
                horizontalTitleGap: 0,
                leading: SvgPicture.asset(
                  AppIcons.logout,
                  height: 21,
                ),
                title: Text(
                  ConstString.logout,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontFamily: AppFont.fontBold, color: AppColors.red),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
