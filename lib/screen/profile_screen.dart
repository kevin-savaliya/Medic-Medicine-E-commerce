// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medic/_dart/_init.dart';
import 'package:medic/model/user_model.dart';
import 'package:medic/screen/cards_screen.dart';
import 'package:medic/screen/edit_profile.dart';
import 'package:medic/screen/myaddress_screen.dart';
import 'package:medic/screen/notification_screen.dart';
import 'package:medic/screen/order_history.dart';
import 'package:medic/screen/phone_login_screen.dart';
import 'package:medic/screen/prescription_list.dart';
import 'package:medic/screen/reminder_screen.dart';
import 'package:medic/utils/app_font.dart';
import 'package:medic/utils/assets.dart';
import 'package:medic/utils/string.dart';
import 'package:medic/utils/utils.dart';
import 'package:medic/widgets/app_dialogue.dart';
import 'package:medic/widgets/user/my_name_text_widget.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final AuthController _authController = Get.find();

  UserController controller = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: _authController.appStorage.getUserData() == null
            ? AppColors.darkPrimaryColor.withOpacity(0.775)
            : AppColors.white,
        title: Text(ConstString.profile,
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontFamily: AppFont.fontBold)),
        elevation: 1.5,
        shadowColor: AppColors.txtGrey.withOpacity(0.2),
        actions: [
          Visibility(
            visible: _authController.appStorage.getUserData() != null,
            child: IconButton(
                onPressed: () {
                  {
                    bool isUserLoggedIn =
                        _authController.appStorage.getUserData() != null;
                    if (isUserLoggedIn) {
                      deleteDialogue(context, () async {
                        Get.back();
                        progressDialogue(title: "Delete Account");
                        bool hasInternet = await Utils.hasInternetConnection();
                        if (!hasInternet) {
                          showInSnackBar(ConstString.noConnection);
                          return;
                        }

                        await deleteUserFirestoreData();
                        Get.back();
                        Get.offAll(() => const PhoneLoginScreen());
                        return;
                      });
                      /*
                      await deleteAccountDialogue(context, _authController, (bool value) async {
                        if (value) {
                          showProgressDialogue(context);
                          await _authController.signOut();
                          Get.offAll(() => const PhoneLoginScreen());
                        }
                      });*/
                    }
                  }
                },
                icon: SvgPicture.asset(
                  AppIcons.delete,
                  height: 21,
                  color: AppColors.red,
                )),
          )
        ],
      ),
      body: Stack(
        children: [
          profileWidget(context),
          NoLoginUI(context),
        ],
      ),
    );
  }

  Visibility NoLoginUI(BuildContext context) {
    return Visibility(
      visible: _authController.appStorage.getUserData() == null,
      child: Container(
        color: AppColors.darkPrimaryColor.withOpacity(0.8),
        child: AlertDialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          backgroundColor: AppColors.white,
          shape: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(12)),
          alignment: Alignment.center,
          title: Column(
            children: [
              Text(
                ConstString.login,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: AppColors.darkPrimaryColor,
                      fontFamily: AppFont.fontBold,
                    ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Please Login to your account",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      fontSize: 14, color: AppColors.txtGrey, letterSpacing: 0),
                ),
              ),
              const SizedBox(height: 25),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                        onPressed: () {
                          Get.back();
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.indGrey.withOpacity(0.5),
                            fixedSize: const Size(200, 45),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30))),
                        child: Text(
                          ConstString.cancle,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(
                                  color: AppColors.txtGrey,
                                  fontSize: 14,
                                  fontFamily: AppFont.fontMedium),
                        )),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: ElevatedButton(
                        onPressed: () async {
                          Get.to(() => const PhoneLoginScreen());
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            fixedSize: const Size(200, 45),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30))),
                        child: Text(
                          ConstString.login,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontFamily: AppFont.fontMedium),
                        )),
                  ),
                ],
              ),
              const SizedBox(height: 5),
            ],
          ),
        ),
      ),
    );
  }

  Widget profileWidget(BuildContext context) {
    return StreamBuilder(
      stream: controller.streamUser(controller.currentUserId!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CupertinoActivityIndicator(
            color: AppColors.primaryColor,
            radius: 12,
          ));
        } else if (snapshot.hasData) {
          UserModel user = snapshot.data!;
          return Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Stack(
                    children: [
                      user.profilePicture != "" && user.profilePicture != null
                          ? ClipOval(
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                height: 110,
                                width: 110,
                                imageUrl: user.profilePicture!,
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) =>
                                        SizedBox(
                                  width: 120,
                                  child: Center(
                                    child: CupertinoActivityIndicator(
                                      color: AppColors.primaryColor,
                                      animating: true,
                                      radius: 14,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : ClipOval(
                              child: Container(
                                  height: 110,
                                  width: 110,
                                  color: AppColors.primaryColor,
                                  child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SvgPicture.asset(
                                          AppImages.medic_white_text)))),
                      Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                              onTap: () {
                                Get.to(() => EditProfile(user));
                              },
                              child: SvgPicture.asset(
                                AppIcons.editProfile,
                                height: 35,
                              )))
                    ],
                  ),
                  const SizedBox(height: 10),
                  MyNameTextWidget(
                      textStyle: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontFamily: AppFont.fontBold)),
                  const SizedBox(height: 5),
                  MyNumberTextWidget(
                      textStyle: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(
                              color: AppColors.txtGrey.withOpacity(0.8),
                              fontFamily: AppFont.fontMedium)),
                  const SizedBox(height: 25),
                  ListTile(
                    onTap: () {
                      bool isUserLoggedIn =
                          _authController.appStorage.getUserData() != null;
                      if (isUserLoggedIn) {
                        Get.to(() => MyAddressScreen());
                      }
                    },
                    horizontalTitleGap: 5,
                    leading: SvgPicture.asset(AppIcons.pin, height: 22),
                    trailing: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 15,
                      color: AppColors.txtGrey,
                    ),
                    title: Text(
                      ConstString.myAddress,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontFamily: AppFont.fontBold,
                          color: AppColors.txtGrey),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
                    child: Container(
                      height: 1,
                      width: double.infinity,
                      color: AppColors.lineGrey,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      bool isUserLoggedIn =
                          _authController.appStorage.getUserData() != null;
                      if (isUserLoggedIn) {
                        Get.to(() => OrderHistory());
                      }
                    },
                    horizontalTitleGap: 5,
                    leading: SvgPicture.asset(AppIcons.timer, height: 22),
                    trailing: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 15,
                      color: AppColors.txtGrey,
                    ),
                    title: Text(
                      ConstString.orderHistory,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontFamily: AppFont.fontBold,
                          color: AppColors.txtGrey),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
                    child: Container(
                      height: 1,
                      width: double.infinity,
                      color: AppColors.lineGrey,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      bool isUserLoggedIn =
                          _authController.appStorage.getUserData() != null;
                      if (isUserLoggedIn) {
                        Get.to(() => ReminderScreen());
                      }
                    },
                    horizontalTitleGap: 5,
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
                          fontFamily: AppFont.fontBold,
                          color: AppColors.txtGrey),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
                    child: Container(
                      height: 1,
                      width: double.infinity,
                      color: AppColors.lineGrey,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      bool isUserLoggedIn =
                          _authController.appStorage.getUserData() != null;
                      if (isUserLoggedIn) {
                        Get.to(() => PrescriptionList());
                      }
                    },
                    horizontalTitleGap: 5,
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
                          fontFamily: AppFont.fontBold,
                          color: AppColors.txtGrey),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
                    child: Container(
                      height: 1,
                      width: double.infinity,
                      color: AppColors.lineGrey,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      bool isUserLoggedIn =
                          _authController.appStorage.getUserData() != null;
                      if (isUserLoggedIn) {
                        Get.to(() => const NotificationScreen());
                      }
                    },
                    horizontalTitleGap: 5,
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
                          fontFamily: AppFont.fontBold,
                          color: AppColors.txtGrey),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
                    child: Container(
                      height: 1,
                      width: double.infinity,
                      color: AppColors.lineGrey,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Get.to(() => CardsScreen());
                    },
                    horizontalTitleGap: 5,
                    leading: SvgPicture.asset(
                      AppIcons.creditCard,
                      height: 21,
                      color: AppColors.txtGrey,
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 15,
                      color: AppColors.txtGrey,
                    ),
                    title: Text(
                      ConstString.payment,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontFamily: AppFont.fontBold,
                          color: AppColors.txtGrey),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
                    child: Container(
                      height: 1,
                      width: double.infinity,
                      color: AppColors.lineGrey,
                    ),
                  ),
                  Visibility(
                    visible: _authController.appStorage.getUserData() != null,
                    child: ListTile(
                      onTap: () async {
                        bool isUserLoggedIn =
                            _authController.appStorage.getUserData() != null;
                        if (isUserLoggedIn) {
                          await logoutDialogue(context, _authController);
                        }
                      },
                      horizontalTitleGap: 5,
                      leading: SvgPicture.asset(
                        AppIcons.logout,
                        height: 21,
                      ),
                      title: Text(
                        ConstString.logout,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                                fontFamily: AppFont.fontBold,
                                color: AppColors.red),
                      ),
                    ),
                  ),
                  // Visibility(
                  //   visible: _authController.appStorage.getUserData() != null,
                  //   child: Padding(
                  //     padding: const EdgeInsets.symmetric(
                  //         horizontal: 20, vertical: 5),
                  //     child: Container(
                  //       height: 1,
                  //       width: double.infinity,
                  //       color: AppColors.lineGrey,
                  //     ),
                  //   ),
                  // ),
                  // Visibility(
                  //   visible: _authController.appStorage.getUserData() != null,
                  //   child: ListTile(
                  //     onTap: () async {
                  //       bool isUserLoggedIn =
                  //           _authController.appStorage.getUserData() != null;
                  //       if (isUserLoggedIn) {
                  //         deleteDialogue(context, () async {
                  //           Get.back();
                  //           progressDialogue(title: "Delete Account");
                  //           bool hasInternet =
                  //               await Utils.hasInternetConnection();
                  //           if (!hasInternet) {
                  //             showInSnackBar(ConstString.noConnection);
                  //             return;
                  //           }
                  //
                  //           await deleteUserFirestoreData();
                  //           Get.back();
                  //           Get.offAll(() => const PhoneLoginScreen());
                  //           return;
                  //         });
                  //         /*
                  //   await deleteAccountDialogue(context, _authController, (bool value) async {
                  //     if (value) {
                  //       showProgressDialogue(context);
                  //       await _authController.signOut();
                  //       Get.offAll(() => const PhoneLoginScreen());
                  //     }
                  //   });*/
                  //       }
                  //     },
                  //     horizontalTitleGap: 5,
                  //     leading: SvgPicture.asset(
                  //       AppIcons.delete,
                  //       height: 21,
                  //       color: AppColors.red,
                  //     ),
                  //     title: Text(
                  //       ConstString.deleteAccount,
                  //       style: Theme.of(context)
                  //           .textTheme
                  //           .titleMedium!
                  //           .copyWith(
                  //               fontFamily: AppFont.fontBold,
                  //               color: AppColors.red),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          );
        } else {
          return SizedBox();
        }
      },
    );
  }
}
