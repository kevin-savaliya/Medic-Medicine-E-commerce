// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:medic/controller/intro_controller.dart';
import 'package:medic/screen/phone_login_screen.dart';
import 'package:medic/theme/colors.dart';
import 'package:medic/utils/assets.dart';
import 'package:medic/utils/string.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: IntroController(),
      builder: (controller) {
        return Obx(() => Scaffold(
            backgroundColor: controller.selectedPageIndex.value == 3
                ? AppColors.primaryColor
                : Colors.white,
            body: SafeArea(
              child: Stack(
                children: [
                  SizedBox(
                      width: double.infinity,
                      child: Image.asset(AppImages.pattern, fit: BoxFit.fill)),
                  Positioned(
                    child: Column(
                      children: [
                        Expanded(
                          flex: 4,
                          child: PageView.builder(
                            controller: controller.pageController.value,
                            onPageChanged: (value) =>
                                onPageChanged(controller, value),
                            itemCount: controller.introList.length,
                            itemBuilder: (context, index) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 420,
                                  ),
                                  Text(
                                    controller.introList[index].title!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayLarge!
                                        .copyWith(
                                          color: controller.selectedPageIndex
                                                      .value ==
                                                  3
                                              ? AppColors.white
                                              : AppColors.darkPrimaryColor,
                                        ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    controller.introList[index].description!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall!
                                        .copyWith(
                                            color: controller.selectedPageIndex
                                                        .value ==
                                                    3
                                                ? AppColors.decsGrey
                                                    .withOpacity(0.7)
                                                : AppColors.txtGrey),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        Obx(() => Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                for (int i = 0;
                                    i < controller.introList.length;
                                    i++)
                                  controller.selectedPageIndex.value == i
                                      ? Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: ClipOval(
                                            child: Container(
                                              height: 5,
                                              width: 5,
                                              color: controller
                                                          .selectedPageIndex
                                                          .value ==
                                                      3
                                                  ? AppColors.white
                                                  : AppColors.primaryColor,
                                            ),
                                          ),
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: ClipOval(
                                            child: Container(
                                              height: 5,
                                              width: 5,
                                              color: controller
                                                          .selectedPageIndex
                                                          .value ==
                                                      3
                                                  ? Colors.black12
                                                  : AppColors.indGrey,
                                            ),
                                          ),
                                        )
                              ],
                            )),
                        const SizedBox(height: 40),
                        ElevatedButton(
                            onPressed: () async {
                              if (controller.selectedPageIndex.value == 0) {
                                controller.pageController.value.animateToPage(1,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeIn);
                              } else if (controller.selectedPageIndex.value ==
                                  1) {
                                controller.pageController.value.animateToPage(2,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeIn);
                              } else if (controller.selectedPageIndex.value ==
                                  2) {
                                controller.pageController.value.animateToPage(3,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeIn);
                              } else {
                                await controller.redirectToLogin();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    controller.selectedPageIndex.value == 3
                                        ? AppColors.white
                                        : AppColors.primaryColor,
                                fixedSize: const Size(200, 50),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30))),
                            child: Text(
                              controller.selectedPageIndex.value == 3
                                  ? ConstString.getstarted
                                  : ConstString.next,
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium!
                                  .copyWith(
                                    color:
                                        controller.selectedPageIndex.value == 3
                                            ? AppColors.primaryColor
                                            : Colors.white,
                                  ),
                            )),
                        const SizedBox(
                          height: 50,
                        )
                      ],
                    ),
                  ),
                  Positioned(
                      height: 50,
                      child: Obx(() => Visibility(
                          visible: controller.selectedPageIndex.value != 0,
                          child: IconButton(
                            onPressed: () {
                              if (controller.selectedPageIndex.value == 1) {
                                controller.pageController.value.animateToPage(0,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeOut);
                              } else if (controller.selectedPageIndex.value ==
                                  2) {
                                controller.pageController.value.animateToPage(1,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeOut);
                              } else if (controller.selectedPageIndex.value ==
                                  3) {
                                controller.pageController.value.animateToPage(2,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeOut);
                              }
                            },
                            icon: SvgPicture.asset(
                              AppIcons.back_icon,
                              color: controller.selectedPageIndex.value == 3
                                  ? AppColors.white
                                  : AppColors.lightGrey,
                            ),
                          )))),
                  Positioned(
                      right: 0,
                      child: Obx(() => Visibility(
                            visible: controller.selectedPageIndex.value != 3,
                            child: TextButton(
                                onPressed: () {
                                  if (controller.selectedPageIndex.value == 0) {
                                    controller.pageController.value
                                        .animateToPage(1,
                                            duration: const Duration(
                                                milliseconds: 300),
                                            curve: Curves.easeIn);
                                  } else if (controller
                                          .selectedPageIndex.value ==
                                      1) {
                                    controller.pageController.value
                                        .animateToPage(2,
                                            duration: const Duration(
                                                milliseconds: 300),
                                            curve: Curves.easeIn);
                                  } else if (controller
                                          .selectedPageIndex.value ==
                                      2) {
                                    controller.pageController.value
                                        .animateToPage(3,
                                            duration: const Duration(
                                                milliseconds: 300),
                                            curve: Curves.easeIn);
                                  } else {
                                    Get.offAll(() => const PhoneLoginScreen());
                                  }
                                },
                                child: Text(
                                  "Skip",
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall!
                                      .copyWith(color: AppColors.skipGrey),
                                )),
                          )))
                ],
              ),
            )));
      },
    );
  }

  void onPageChanged(IntroController controller, int? value) {
    controller.selectedPageIndex.value = value ?? 0;
  }
}
