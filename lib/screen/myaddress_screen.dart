import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:medic/screen/add_address_detail.dart';
import 'package:medic/theme/colors.dart';
import 'package:medic/utils/app_font.dart';
import 'package:medic/utils/assets.dart';
import 'package:medic/utils/string.dart';

class MyAddressScreen extends StatelessWidget {
  const MyAddressScreen({super.key});

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
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(
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
          Expanded(
            flex: 10,
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.decsGrey),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: SvgPicture.asset(AppIcons.fillpinround),
                      ),
                      title: Text(
                        "HomeTown",
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(
                                fontFamily: AppFont.fontMedium,
                                color: AppColors.txtGrey.withOpacity(0.7)),
                      ),
                      subtitle: Text(
                        "6391 Elgin St, Delaware 10299",
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
                                          fontFamily: AppFont.fontMedium,
                                          fontSize: 14,
                                          color: AppColors.txtGrey),
                                ),
                              ],
                            ),
                          ),
                          PopupMenuItem(
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
                                          fontFamily: AppFont.fontMedium,
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
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
