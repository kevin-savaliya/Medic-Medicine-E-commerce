// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:medic/controller/address_controller.dart';
import 'package:medic/model/user_address.dart';
import 'package:medic/screen/add_address_detail.dart';
import 'package:medic/theme/colors.dart';
import 'package:medic/utils/app_font.dart';
import 'package:medic/utils/assets.dart';
import 'package:medic/utils/string.dart';
import 'package:medic/widgets/shimmer_widget.dart';

class MyAddressScreen extends StatelessWidget {
  AddressController controller = Get.put(AddressController());

  MyAddressScreen({super.key});

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
        title: Text(ConstString.myAddress,
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontFamily: AppFont.fontBold)),
        elevation: 1.5,
        shadowColor: AppColors.txtGrey.withOpacity(0.2),
      ),
      body: addressWidget(context),
    );
  }

  Widget addressWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                Get.to(() => AddAddressDetail());
              },
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.primaryColor),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 15,
                    ),
                    SvgPicture.asset(AppIcons.fillAdd),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      ConstString.addAddress,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: AppColors.white,
                          fontFamily: AppFont.fontMedium),
                    )
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              ConstString.savedAddress,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: AppColors.txtGrey, fontFamily: AppFont.fontMedium),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            flex: 10,
            child: StreamBuilder(
              stream: controller.fetchAddress(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return AddressShimmer(itemCount: snapshot.data?.length);
                } else if (snapshot.hasError) {
                  return Text("Error : ${snapshot.error}");
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  List<UserAddress> addressList = snapshot.data!;
                  List<UserAddress> reverseList = addressList.reversed.toList();
                  return ListView.builder(
                    itemCount: addressList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: GestureDetector(
                          onTap: () {
                            controller.updateAddressStatus(
                                reverseList[index].id, true);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: reverseList[index].isActive!
                                        ? AppColors.txtGrey.withOpacity(0.6)
                                        : AppColors.decsGrey,
                                    width: 1.5),
                                color: AppColors.decsGrey),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              leading: SvgPicture.asset(AppIcons.fillpinround),
                              title: Text(
                                "${reverseList[index].title}",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(
                                        fontFamily: AppFont.fontMedium,
                                        color:
                                            AppColors.txtGrey.withOpacity(0.7)),
                              ),
                              subtitle: Text(
                                "${reverseList[index].address}, ${reverseList[index].area}, ${reverseList[index].landmark}",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                        color: AppColors.txtGrey,
                                        fontSize: 13,
                                        fontFamily: AppFont.fontMedium),
                              ),
                              trailing: PopupMenuButton(
                                elevation: 3,
                                shadowColor: AppColors.txtGrey.withOpacity(0.1),
                                icon: SvgPicture.asset(AppIcons.more),
                                onSelected: (value) async {},
                                padding: EdgeInsets.zero,
                                itemBuilder: (context) => <PopupMenuEntry>[
                                  PopupMenuItem(
                                    onTap: () {
                                      Get.to(() => AddAddressDetail(
                                            address: reverseList[index],
                                          ));
                                    },
                                    height: 35,
                                    value: "Edit",
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(AppIcons.edit),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "Edit",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall!
                                              .copyWith(
                                                  fontFamily:
                                                      AppFont.fontMedium,
                                                  fontSize: 14,
                                                  color: AppColors.txtGrey),
                                        ),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    onTap: () {
                                      controller.deleteAddress(
                                          reverseList[index].id!);
                                    },
                                    height: 35,
                                    value: "Delete",
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          AppIcons.delete,
                                          height: 14,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "Delete",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall!
                                              .copyWith(
                                                  fontFamily:
                                                      AppFont.fontMedium,
                                                  fontSize: 14,
                                                  color: AppColors.txtGrey),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.tilePrimaryColor),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(AppIcons.noData, height: 50),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          ConstString.noAddress,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(
                                  color: AppColors.primaryColor,
                                  fontSize: 15,
                                  fontFamily: AppFont.fontMedium),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
