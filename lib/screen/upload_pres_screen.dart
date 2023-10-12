// ignore_for_file: unrelated_type_equality_checks, must_be_immutable

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:medic/theme/colors.dart';
import 'package:medic/utils/app_font.dart';
import 'package:medic/utils/assets.dart';
import 'package:medic/utils/string.dart';
import 'package:medic/widgets/pick_image.dart';

class UploadPrescription extends StatelessWidget {
  PickImageController pickImageController = Get.put(PickImageController());

  UploadPrescription({super.key});

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
        title: Text(ConstString.uploadPres,
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontFamily: AppFont.fontBold)),
        elevation: 1.5,
        shadowColor: AppColors.txtGrey.withOpacity(0.2),
      ),
      body: uploadPresWidget(context),
    );
  }

  Widget uploadPresWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Column(
        children: [
          Container(
            height: 170,
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.decsGrey),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        ConstString.quickOrder,
                        style: Theme.of(context)
                            .textTheme
                            .displayLarge!
                            .copyWith(
                                fontFamily: AppFont.fontBold,
                                fontSize: 16,
                                height: 1.4),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        ConstString.uploadphoto,
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(height: 1.4, fontSize: 11),
                      ),
                      const Spacer(),
                      ElevatedButton(
                          onPressed: () {
                            pickImage(context);
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColor,
                              fixedSize: const Size(150, 18),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30))),
                          child: Text(
                            ConstString.uploadPres,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                    color: AppColors.white,
                                    fontFamily: AppFont.fontMedium),
                          ))
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      SvgPicture.asset(
                        AppImages.presIcon,
                        height: 80,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        ConstString.howwork,
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(color: AppColors.primaryColor),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Obx(
            () => pickImageController.selectedImage != ""
                ? Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          ConstString.presUploadedByYou,
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(
                                color: AppColors.darkPrimaryColor,
                                fontFamily: AppFont.fontSemiBold,
                                fontSize: 15.5,
                              ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Stack(
                          children: [
                            SizedBox(
                              height: 150,
                              width: 130,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  File(pickImageController.selectedImage.value),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                                bottom: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    pickImageController.selectedImage.value =
                                        "";
                                  },
                                  child: Container(
                                    height: 30,
                                    width: 130,
                                    decoration: BoxDecoration(
                                        color: AppColors.darkPrimaryColor
                                            .withOpacity(0.7),
                                        borderRadius: const BorderRadius.only(
                                            bottomRight: Radius.circular(10),
                                            bottomLeft: Radius.circular(10))),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            ConstString.remove,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall!
                                                .copyWith(
                                                    color: AppColors.white),
                                          ),
                                          SvgPicture.asset(
                                            AppIcons.closeRed,
                                            height: 16,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ))
                          ],
                        ),
                      ),
                    ],
                  )
                : const SizedBox(),
          ),
          const Spacer(),
          Obx(
            () => ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                    backgroundColor: pickImageController.selectedImage == ""
                        ? AppColors.indGrey
                        : AppColors.primaryColor,
                    fixedSize: const Size(200, 50),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30))),
                child: Text(
                  ConstString.btnContinue,
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        color: pickImageController.selectedImage == ""
                            ? AppColors.skipGrey
                            : AppColors.white,
                      ),
                )),
          ),
          const SizedBox(
            height: 40,
          )
        ],
      ),
    );
  }

  void pickImage(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Container(
          height: 300,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), color: AppColors.white),
          child: Column(
            children: [
              Container(
                height: 50,
                decoration: BoxDecoration(
                    color: AppColors.decsGrey,
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20))),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        ConstString.uploadPres,
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            fontFamily: AppFont.fontMedium, fontSize: 13),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: GestureDetector(
                            onTap: () {
                              Get.back();
                            },
                            child: Icon(
                              Icons.close,
                              color: AppColors.txtGrey,
                              size: 18,
                            )),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              Get.back();
                              await pickImageController.pickImageFromCamera();
                              // print(
                              //     "Image : ${pickImageController.selectedImage}");
                            },
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                  color: AppColors.decsGrey,
                                  borderRadius: BorderRadius.circular(5)),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(AppIcons.camera),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      ConstString.camera,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(
                                              fontFamily: AppFont.fontMedium,
                                              fontSize: 14),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              await pickImageController.pickImageFromGallery();
                              // print(
                              //     "Image : ${pickImageController.selectedImage}");
                            },
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                  color: AppColors.decsGrey,
                                  borderRadius: BorderRadius.circular(5)),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(AppIcons.gallery),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      ConstString.gallery,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(
                                              fontFamily: AppFont.fontMedium,
                                              fontSize: 14),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: AppColors.decsGrey),
                          alignment: Alignment.center,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: SvgPicture.asset(AppIcons.file),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    ConstString.pastPres,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .copyWith(
                                            fontFamily: AppFont.fontMedium,
                                            fontSize: 14),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    ConstString.loginView,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .copyWith(
                                            fontSize: 12,
                                            color: AppColors.txtGrey),
                                  ),
                                ],
                              )
                            ],
                          )),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: AppColors.decsGrey),
                          alignment: Alignment.center,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: SvgPicture.asset(AppIcons.file),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    ConstString.presUpload,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .copyWith(
                                            fontFamily: AppFont.fontMedium,
                                            fontSize: 14),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    ConstString.loginView,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .copyWith(
                                            fontSize: 12,
                                            color: AppColors.txtGrey),
                                  ),
                                ],
                              )
                            ],
                          )),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
