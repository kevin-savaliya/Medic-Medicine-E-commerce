import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
                    fontSize: 14,
                    color: AppColors.txtGrey,
                    // fontFamily: AppFont.fontMedium,
                    letterSpacing: 0),
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
                          backgroundColor: AppColors.decsGrey,
                          fixedSize: const Size(200, 45),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30))),
                      child: Text(
                        ConstString.cancle,
                        style:
                            Theme.of(context).textTheme.displayMedium!.copyWith(
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
                        return await deleteDialogue(context, () async {
                          Get.back();
                          bool hasInternet =
                              await Utils.hasInternetConnection();
                          if (!hasInternet) {
                            showInSnackBar(ConstString.noConnection);
                            return;
                          }
                          // show loading dialog while deleting user
                          progressDialogue(context, title: "Deleting Account");
                          await authController.deleteAccount();
                          await deleteUserFirestoreData();
                          Get.back();
                          Get.offAll(() => const PhoneLoginScreen());
                          return;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          fixedSize: const Size(200, 50),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30))),
                      child: Text(
                        ConstString.deleteAccount,
                        style:
                            Theme.of(context).textTheme.displayMedium!.copyWith(
                                  color: Colors.white,
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
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          fixedSize: const Size(200, 50),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30))),
                      child: Text(
                        ConstString.logoutDialogue,
                        style:
                            Theme.of(context).textTheme.displayMedium!.copyWith(
                                  color: Colors.white,
                                ),
                      )),
                ),
              ],
            )
          ],
        ),
      );
    },
  );
}

Future progressDialogue(context, {required String title}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        content: Container(
          height: 100,
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              TextWidget(
                title,
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    color: AppColors.black,
                    fontSize: 14,
                    fontFamily: AppFont.fontMedium,
                    letterSpacing: 0.5),
              )
            ],
          ),
        ),
      );
    },
  );
}

Future deleteDialogue(BuildContext context, Function() callback) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 25),
        backgroundColor: AppColors.white,
        shape: const OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(8))),
        alignment: Alignment.center,
        title: Column(
          children: [
            Icon(
              CupertinoIcons.delete,
              size: 40,
              color: Colors.red,
            ),
            SizedBox(height: 25),
            Text(
              ConstString.deleteAccount,
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    color: AppColors.darkPrimaryColor,
                    fontFamily: AppFont.fontSemiBold,
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
            ),
            SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextWidget(
                "Are you sure you want to delete your account?\nAll information will be deleted. That can't be UNDONE",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayMedium!.copyWith(
                    fontSize: 14,
                    color: AppColors.phoneGrey.withOpacity(0.9),
                    fontWeight: FontWeight.w400,
                    fontFamily: AppFont.fontRegular,
                    height: 1.5,
                    letterSpacing: 0),
              ),
            ),
            SizedBox(height: 25),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      callback();
                    },
                    style: ElevatedButton.styleFrom(
                        fixedSize: Size(20, 55),
                        backgroundColor: AppColors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        elevation: 0),
                    child: Text(
                      "Yes",
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium!
                          .copyWith(
                              color: AppColors.alertBoxTextColot,
                              fontWeight: FontWeight.w500,
                              fontFamily: AppFont.fontMedium,
                              fontSize: 15),
                    ),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                        fixedSize: Size(20, 55),
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

Future<void> deleteUserFirestoreData() async {
  String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  // TODO: remove all data related to user from firestore

  // Delete user favorites

  // await deleteUserFavouriteMedicines(currentUserId);

  // await deleteUser(currentUserId);
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
              height: 100,
              width: 150,
              child: CupertinoActivityIndicator(
                radius: 15,
                animating: true,
                color: AppColors.primaryColor,
              ),
            ),
          ),
        ],
      );
    },
  );
}
