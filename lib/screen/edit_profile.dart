import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:medic/_dart/_init.dart';
import 'package:medic/controller/upload_pres_controller.dart';
import 'package:medic/controller/user_repository.dart';
import 'package:medic/model/user_model.dart';
import 'package:medic/theme/colors.dart';
import 'package:medic/utils/app_font.dart';
import 'package:medic/utils/assets.dart';
import 'package:medic/utils/string.dart';
import 'package:medic/utils/utils.dart';
import 'package:medic/widgets/app_dialogue.dart';

class EditProfile extends StatefulWidget {
  UserModel? user;

  EditProfile(this.user);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  UploadPresController presController = Get.put(UploadPresController());
  UserController controller = Get.put(UserController());
  UserModel? userModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userModel = widget.user;

    controller.nameController.text = userModel!.name ?? '';
    controller.emailController.text = userModel!.email ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SvgPicture.asset(
              AppIcons.back,
            ),
          ),
        ),
        titleSpacing: 0,
        title: Text(ConstString.editProfile,
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontFamily: AppFont.fontBold)),
        elevation: 1.5,
        shadowColor: AppColors.txtGrey.withOpacity(0.2),
      ),
      body: editProfileWidget(context, presController, controller),
    );
  }

  Widget editProfileWidget(BuildContext context,
      UploadPresController presController, UserController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Center(
              child: Obx(() => Stack(
                    children: [
                      presController.selectedProfileImage.isEmpty
                          ? ClipOval(
                              child: Container(
                                  height: 110,
                                  width: 110,
                                  color: AppColors.primaryColor,
                                  child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SvgPicture.asset(
                                          AppImages.medic_white_text))))
                          : Obx(() => ClipOval(
                                child: Container(
                                  height: 110,
                                  width: 110,
                                  child: Image.file(
                                    File(presController.selectedProfileImage),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )),
                      Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                              onTap: () {
                                presController.pickImage(context);
                              },
                              child: SvgPicture.asset(
                                AppIcons.editProfile,
                                height: 35,
                              )))
                    ],
                  )),
            ),
            const SizedBox(
              height: 30,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                ConstString.enterUrName,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: AppColors.txtGrey,
                    fontFamily: AppFont.fontMedium,
                    fontSize: 13),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: SizedBox(
                height: 60,
                child: TextFormField(
                  textCapitalization: TextCapitalization.words,
                  controller: controller.nameController,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: AppColors.txtGrey, fontSize: 14),
                  cursorColor: AppColors.txtGrey,
                  decoration: InputDecoration(
                      hintText: "Enter Your Name",
                      hintStyle: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(
                              fontFamily: AppFont.fontMedium,
                              color: AppColors.phoneGrey,
                              fontSize: 13.5),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                          borderSide: BorderSide(color: AppColors.decsGrey)),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: AppColors.decsGrey, width: 1),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: AppColors.decsGrey, width: 1),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: AppColors.decsGrey, width: 1),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 20)),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                ConstString.enterUrEmail,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: AppColors.txtGrey,
                    fontFamily: AppFont.fontMedium,
                    fontSize: 13),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: SizedBox(
                height: 60,
                child: TextFormField(
                  controller: controller.emailController,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: AppColors.txtGrey, fontSize: 14),
                  cursorColor: AppColors.txtGrey,
                  decoration: InputDecoration(
                      hintText: "Enter Your E-mail Address",
                      hintStyle: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(
                              fontFamily: AppFont.fontMedium,
                              color: AppColors.phoneGrey,
                              fontSize: 13.5),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                          borderSide: BorderSide(color: AppColors.decsGrey)),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: AppColors.decsGrey, width: 1),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: AppColors.decsGrey, width: 1),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: AppColors.decsGrey, width: 1),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 20)),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            ElevatedButton(
                onPressed: () async {
                  String name = controller.nameController.text.trim();
                  String email = controller.emailController.text.trim();
                  String userid = FirebaseAuth.instance.currentUser!.uid;

                  if (name.isNotEmpty && email.isNotEmpty) {
                    showProgressDialogue(context);
                    try {
                      final ref =
                          FirebaseStorage.instance.ref('profiles/$userid');
                      final picFile = File(presController.selectedProfileImage);
                      if (await picFile.exists()) {
                        UploadTask uploadTask = ref.putFile(picFile);

                        await Future.value(uploadTask).then((value) async {
                          var newUrl = await ref.getDownloadURL();
                          await UserRepository.instance
                              .updateUser(userModel!.copyWith(
                                  id: userid,
                                  name: name,
                                  email: email,
                                  profilePicture: newUrl.toString()))
                              .then((value) {
                            Get.find<UserController>;
                            Get.back();
                            Get.back();
                            showInSnackBar("Profile data edited successfully",
                                isSuccess: true, title: "The Medic");
                            controller.nameController.clear();
                            controller.emailController.clear();
                            presController.selectedProfileImage = "";
                          }).onError((error, stackTrace) {
                            showInSnackBar("$error", isSuccess: false);
                          });
                        }).onError((error, stackTrace) {
                          showInSnackBar("$error", isSuccess: false);
                        });
                      } else {
                        UserModel? userModel =
                            await controller.getLoggedInUserData();
                        await UserRepository.instance.updateUser(userModel!
                            .copyWith(
                                name: name,
                                email: FirebaseAuth.instance.currentUser!.email,
                                profilePicture: userModel.profilePicture,
                                id: FirebaseAuth.instance.currentUser!.uid));
                      }
                    } catch (e) {
                      print("Exception Thrown : $e");
                    }
                  } else {
                    showInSnackBar("Please fill all the fields!!",
                        isSuccess: false, title: "The Medic");
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    fixedSize: const Size(200, 50),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30))),
                child: Text(
                  ConstString.saveDetails,
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        color: Colors.white,
                      ),
                )),
          ],
        ),
      ),
    );
  }
}
