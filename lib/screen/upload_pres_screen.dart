import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:medic/theme/colors.dart';
import 'package:medic/utils/app_font.dart';
import 'package:medic/utils/assets.dart';
import 'package:medic/utils/string.dart';

class UploadPrescription extends StatelessWidget {
  const UploadPrescription({super.key});

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

  Container uploadPresWidget(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
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
                        SizedBox(
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
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          ConstString.uploadphoto,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(height: 1.4, fontSize: 11),
                        ),
                        Spacer(),
                        ElevatedButton(
                            onPressed: () {
                              pickImage(context);
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryColor,
                                fixedSize: Size(150, 18),
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
                        SizedBox(
                          height: 10,
                        ),
                        SvgPicture.asset(
                          AppImages.presIcon,
                          height: 80,
                        ),
                        SizedBox(
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
          ),
          Spacer(),
          ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.indGrey,
                  fixedSize: Size(200, 50),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30))),
              child: Text(
                ConstString.btnContinue,
                style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      color: AppColors.skipGrey,
                    ),
              )),
          SizedBox(
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
                    borderRadius: BorderRadius.only(
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
                            onTap: () {},
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
                                    SizedBox(
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
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {},
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
                                    SizedBox(
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
                    SizedBox(
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
                                  SizedBox(height: 5),
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
                    SizedBox(
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
                                  SizedBox(height: 5),
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
