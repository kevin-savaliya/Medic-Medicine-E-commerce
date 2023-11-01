// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:medic/controller/auth_controller.dart';
import 'package:medic/screen/phone_login_screen.dart';
import 'package:medic/theme/colors.dart';
import 'package:medic/utils/app_font.dart';
import 'package:medic/utils/string.dart';
import 'package:medic/utils/utils.dart';
import 'package:medic/widgets/custom_widget.dart';

Future logoutDialogue(BuildContext context, AuthController authController) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        backgroundColor: AppColors.white,
        shape: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(12)),
        alignment: Alignment.center,
        title: Column(
          children: [
            Text(
              ConstString.logoutDialogue,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: AppColors.darkPrimaryColor,
                    fontFamily: AppFont.fontBold,
                  ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Are you sure you want to logout?",
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
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              color: AppColors.txtGrey,
                            ),
                      )),
                ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: ElevatedButton(
                      onPressed: () async {
                        Get.back();
                        showProgressDialogue(context);
                        await authController.signOut();
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          fixedSize: const Size(200, 45),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30))),
                      child: Text(
                        ConstString.logoutDialogue,
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              color: Colors.white,
                            ),
                      )),
                ),
              ],
            ),
            const SizedBox(height: 5),
          ],
        ),
      );
    },
  );
}

Future deleteAccountDialogue(
    BuildContext context, AuthController authController) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        backgroundColor: AppColors.white,
        shape: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(12)),
        alignment: Alignment.center,
        title: Column(
          children: [
            Text(
              ConstString.deleteAccountDialogue,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: AppColors.darkPrimaryColor,
                    fontFamily: AppFont.fontBold,
                  ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Please be aware that this action is irreversible, and all tasks and progress in Buckets will be permanently lost.",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayMedium!.copyWith(
                    fontSize: 14, color: AppColors.txtGrey, letterSpacing: 0),
              ),
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () async {
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
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.red,
                      fixedSize: const Size(double.infinity, 45),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30))),
                  child: Text(
                    ConstString.deleteAccount,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: Colors.white,
                        ),
                  )),
            ),
          ],
        ),
      );
    },
  );
}

Future progressDialogue({required String title}) {
  return Get.dialog(
    AlertDialog(
      content: SizedBox(
        height: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 30,
              width: 30,
              child: LoadingIndicator(
                colors: [AppColors.primaryColor],
                indicatorType: Indicator.ballScale,
                strokeWidth: 1,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextWidget(
              title,
              style: Theme.of(Get.context!).textTheme.labelLarge!.copyWith(
                  color: AppColors.black,
                  fontSize: 16,
                  fontFamily: AppFont.fontMedium,
                  letterSpacing: 0.5),
            )
          ],
        ),
      ),
    ),
    barrierDismissible: false,
  );
}

Future deleteDialogue(BuildContext context, Function() callback) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 25),
        backgroundColor: AppColors.white,
        shape: const OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(8))),
        alignment: Alignment.center,
        title: Column(
          children: [
            const Icon(
              CupertinoIcons.delete,
              size: 40,
              color: Colors.red,
            ),
            const SizedBox(height: 25),
            Text(
              ConstString.deleteAccountDialogue,
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    color: AppColors.darkPrimaryColor,
                    fontFamily: AppFont.fontSemiBold,
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: TextWidget(
                "Please be aware that this action is irreversible, and all tasks and progress in Buckets will be permanently lost.",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayMedium!.copyWith(
                    fontSize: 14,
                    color: AppColors.txtGrey,
                    fontWeight: FontWeight.w400,
                    fontFamily: AppFont.fontRegular,
                    height: 1.5,
                    letterSpacing: 0),
              ),
            ),
            const SizedBox(height: 25),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      callback();
                    },
                    style: ElevatedButton.styleFrom(
                        fixedSize: const Size(20, 50),
                        backgroundColor: AppColors.red,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        elevation: 0),
                    child: Text(
                      "Yes",
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium!
                          .copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.w500,
                              fontFamily: AppFont.fontMedium,
                              fontSize: 15),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                        fixedSize: const Size(20, 50),
                        backgroundColor: AppColors.splashdetail,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        elevation: 0),
                    child: TextWidget(
                      "NO",
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium!
                          .copyWith(
                              color: AppColors.dark,
                              fontWeight: FontWeight.w500,
                              fontFamily: AppFont.fontMedium,
                              fontSize: 15),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}

FirebaseFirestore instance() => FirebaseFirestore.instance;

Future<void> deleteUserFirestoreData() async {
  String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  /// Delete user
  await deleteUser(currentUserId);

  /// Delete user favorites
  await deleteUserFavouriteMedicines(currentUserId);

  /// Delete user addresses
  await deleteUserAddresses(currentUserId);

  /// Delete user reminders
  await deleteUserReminders(currentUserId);
}

Future<void> deleteUserFavouriteMedicines(String currentUserId) async {
  await instance().collection("favourites").doc(currentUserId).delete();
}

Future<void> deleteUserAddresses(String currentUserId) async {
  await instance().collection("addresses").doc(currentUserId).delete();
}

Future<void> deleteUserReminders(String currentUserId) async {
  await instance().collection("reminders").doc(currentUserId).delete();
}

Future<void> deleteUser(String currentUserId) async {
  await instance().collection("users").doc(currentUserId).delete();
  await FirebaseAuth.instance.currentUser!.delete();
}

// show progress dialog
Future showProgressDialogue(BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 120,
            width: 250,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                )
              ],
            ),
            child: SizedBox(
                height: 50,
                width: 50,
                child: SizedBox(
                  height: 10,
                  width: 10,
                  child: LoadingIndicator(
                    colors: [AppColors.primaryColor],
                    indicatorType: Indicator.ballScaleMultiple,
                    strokeWidth: 0,
                  ),
                )),
          ),
        ],
      );
    },
  );
}
