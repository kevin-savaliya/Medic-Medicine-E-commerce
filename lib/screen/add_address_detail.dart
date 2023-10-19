// ignore_for_file: unrelated_type_equality_checks, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:medic/controller/address_controller.dart';
import 'package:medic/model/user_address.dart';
import 'package:medic/theme/colors.dart';
import 'package:medic/utils/app_font.dart';
import 'package:medic/utils/assets.dart';
import 'package:medic/utils/string.dart';
import 'package:medic/widgets/app_dialogue.dart';

class AddAddressDetail extends StatelessWidget {
  final AddressController addressController = Get.put(AddressController());

  AddAddressDetail({super.key});

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
        title: Text(ConstString.enterAddressDetail,
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontFamily: AppFont.fontBold)),
        elevation: 1.5,
        shadowColor: AppColors.txtGrey.withOpacity(0.2),
      ),
      body: addAddressWidget(context, addressController),
    );
  }

  Widget addAddressWidget(BuildContext context, AddressController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                ConstString.saveAddAs,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: AppColors.txtGrey,
                    fontFamily: AppFont.fontMedium,
                    fontSize: 13),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 35,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.addressList.length,
                itemBuilder: (context, index) {
                  return Obx(() => GestureDetector(
                        onTap: () {
                          controller.selectAdd.value =
                              controller.addressList[index];
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: controller.selectAdd ==
                                            controller.addressList[index]
                                        ? AppColors.primaryColor
                                        : AppColors.lineGrey),
                                color: controller.selectAdd ==
                                        controller.addressList[index]
                                    ? AppColors.primaryColor
                                    : AppColors.white),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    controller.addressImgList[index],
                                    color: controller.selectAdd ==
                                            controller.addressList[index]
                                        ? AppColors.white
                                        : AppColors.txtGrey,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    controller.addressList[index],
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .copyWith(
                                            color: controller.selectAdd ==
                                                    controller
                                                        .addressList[index]
                                                ? AppColors.white
                                                : AppColors.txtGrey,
                                            fontFamily: AppFont.fontMedium),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ));
                },
              ),
            ),
            const SizedBox(height: 20),
            Obx(() => controller.selectAdd.value == "Other"
                ? SizedBox(
                    height: 60,
                    child: TextFormField(
                      controller: controller.saveAsController,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: AppColors.txtGrey),
                      cursorColor: AppColors.txtGrey,
                      decoration: InputDecoration(
                          hintText: "Save as",
                          hintStyle: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                  fontFamily: AppFont.fontMedium,
                                  color: AppColors.phoneGrey,
                                  fontSize: 13.5),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                              borderSide:
                                  BorderSide(color: AppColors.decsGrey)),
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
                  )
                : const SizedBox()),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                ConstString.address,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: AppColors.txtGrey,
                    fontFamily: AppFont.fontMedium,
                    fontSize: 13),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: SizedBox(
                height: 60,
                child: TextFormField(
                  textCapitalization: TextCapitalization.words,
                  controller: controller.addController,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: AppColors.txtGrey),
                  cursorColor: AppColors.txtGrey,
                  decoration: InputDecoration(
                      hintText: "Enter Flat / house no / floor / building",
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
                ConstString.area,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: AppColors.txtGrey,
                    fontFamily: AppFont.fontMedium,
                    fontSize: 13),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: SizedBox(
                height: 60,
                child: TextFormField(
                  textCapitalization: TextCapitalization.words,
                  controller: controller.areaController,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: AppColors.txtGrey),
                  cursorColor: AppColors.txtGrey,
                  decoration: InputDecoration(
                      hintText: "Enter area, sector, locality",
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
                ConstString.landmark,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: AppColors.txtGrey,
                    fontFamily: AppFont.fontMedium,
                    fontSize: 13),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: SizedBox(
                height: 60,
                child: TextFormField(
                  textCapitalization: TextCapitalization.words,
                  controller: controller.landmarkController,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: AppColors.txtGrey),
                  cursorColor: AppColors.txtGrey,
                  decoration: InputDecoration(
                      hintText: "Nearby Landmark (Optional)",
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
              height: 180,
            ),
            ElevatedButton(
                onPressed: () {
                  showProgressDialogue(context);
                  if (controller.validateData()) {
                    String id = controller.addRef.doc().id;
                    UserAddress address = UserAddress(
                        id: id,
                        title: controller.selectAdd.value,
                        address: controller.addController.text.trim(),
                        area: controller.areaController.text.trim(),
                        landmark: controller.landmarkController.text.trim(),
                        isActive: true);
                    controller.addAddress(address);
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
