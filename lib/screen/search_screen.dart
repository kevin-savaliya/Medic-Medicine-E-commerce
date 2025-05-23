// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:medic/controller/home_controller.dart';
import 'package:medic/controller/medicine_controller.dart';
import 'package:medic/model/category_data.dart';
import 'package:medic/screen/medicine_category.dart';
import 'package:medic/screen/notification_screen.dart';
import 'package:medic/screen/upload_pres_screen.dart';
import 'package:medic/theme/colors.dart';
import 'package:medic/utils/app_font.dart';
import 'package:medic/utils/assets.dart';
import 'package:medic/utils/string.dart';
import 'package:medic/widgets/shimmer_widget.dart';
import 'package:medic/widgets/user/my_name_text_widget.dart';

class SearchScreen extends StatelessWidget {
  MedicineController controller = Get.put(MedicineController());

  SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.white,
        toolbarHeight: 70,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SvgPicture.asset(
                    AppIcons.back,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: SizedBox(
                height: 50,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: TextFormField(
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(fontFamily: AppFont.fontRegular),
                    decoration: InputDecoration(
                      filled: true,
                      enabled: true,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(
                            top: 15, bottom: 15, left: 10),
                        child: SvgPicture.asset(
                          AppIcons.search,
                          height: 18,
                        ),
                      ),
                      suffixIcon: GestureDetector(
                          onTap: () {},
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(Icons.close, size: 22),
                          )),
                      fillColor: AppColors.transparentDetails,
                      hintText: "Search Drugs, Reviews, and Ratings...",
                      hintStyle: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(
                              fontFamily: AppFont.fontRegular,
                              fontSize: 14,
                              color: AppColors.skipGrey),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Colors.transparent, width: 0.5),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Colors.transparent, width: 0.5),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Colors.transparent, width: 0.5),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Colors.transparent, width: 0.5),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 17,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            )
          ],
        ),
      ),
      body: searchWidget(context, controller),
    );
  }

  Widget searchWidget(BuildContext context, MedicineController controller) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  ConstString.recentSearches,
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        color: AppColors.darkPrimaryColor,
                        fontFamily: AppFont.fontSemiBold,
                        fontSize: 15,
                      ),
                ),
              ),
            ),
            ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ListTile(
                    onTap: () {},
                    horizontalTitleGap: -8,
                    leading: SvgPicture.asset(controller.searchCategory[index],
                        height: 18),
                    title: Text(
                      controller.recentSearchList[index],
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: AppColors.darkPrimaryColor,
                          fontFamily: AppFont.fontMedium),
                    ),
                    subtitle: Text(
                      "in allergies",
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(color: AppColors.skipGrey),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: AppColors.arrGrey,
                      size: 15,
                    ),
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    ConstString.medicineCategory,
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                          color: AppColors.darkPrimaryColor,
                          fontFamily: AppFont.fontSemiBold,
                          fontSize: 15,
                        ),
                  ),
                  TextButton(
                      onPressed: () {
                        Get.to(() => MedicineCategory());
                      },
                      child: Text(
                        ConstString.viewAll,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: AppColors.primaryColor,
                            fontFamily: AppFont.fontMedium,
                            fontSize: 14),
                      ))
                ],
              ),
            ),
            GetBuilder(
              init: MedicineController(),
              builder: (controller) {
                return SizedBox(
                    height: 100,
                    child: StreamBuilder<List<CategoryData>>(
                      stream: controller.fetchCategory(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CategoryShimmer(
                              itemCount: snapshot.data?.length,
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Container(
                            alignment: Alignment.center,
                            height: 100,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: AppColors.tilePrimaryColor),
                            child: Text(
                              "Error : ${snapshot.error}",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(
                                      color: AppColors.primaryColor,
                                      fontSize: 13,
                                      fontFamily: AppFont.fontMedium),
                            ),
                          );
                        } else if (snapshot.hasData &&
                            snapshot.data!.isNotEmpty) {
                          List<CategoryData>? categoryList = snapshot.data!;

                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 6,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        clipBehavior:
                                            Clip.antiAliasWithSaveLayer,
                                        child: SvgPicture.network(
                                            categoryList[index].image!,
                                            height: 50),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "${categoryList[index].name}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .copyWith(
                                                color: AppColors.txtGrey,
                                                fontFamily: AppFont.fontMedium),
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),
                          );
                        } else {
                          return Container(
                            alignment: Alignment.center,
                            height: 100,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: AppColors.tilePrimaryColor),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(AppIcons.noData, height: 40),
                                Text(
                                  "No Category Found!",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(
                                          color: AppColors.primaryColor,
                                          fontSize: 14,
                                          fontFamily: AppFont.fontMedium),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    ));
              },
            ),
            const SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  ConstString.popularSearches,
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        color: AppColors.darkPrimaryColor,
                        fontFamily: AppFont.fontSemiBold,
                        fontSize: 15,
                      ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.searchList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        controller.searchList[index],
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(color: AppColors.txtGrey, fontSize: 13.5),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: AppColors.primaryColor,
                        size: 15,
                      )
                    ],
                  ),
                );
              },
            ),
            const SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }
}
