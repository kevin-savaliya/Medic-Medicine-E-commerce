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
  HomeController controller = Get.put(HomeController());

  SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.white,
        toolbarHeight: 70,
        leading: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Image.asset("asset/dummy1.png"),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SvgPicture.asset(AppIcons.fillpin),
                const SizedBox(
                  width: 3,
                ),
                Text(
                  "Santa, Illinois 85486",
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(color: AppColors.primaryColor),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            MyNameTextWidget(
              textStyle: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontFamily: AppFont.fontMedium),
            ),
          ],
        ),
        actions: [
          controller.firebaseUser != null
              ? IconButton(
                  onPressed: () async {
                    await Get.to(() => const NotificationScreen());
                  },
                  icon: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: SvgPicture.asset(AppIcons.notification),
                  ))
              : SizedBox()
        ],
      ),
      body: searchWidget(context, controller),
    );
  }

  Widget searchWidget(BuildContext context, HomeController controller) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextFormField(
                style: Theme.of(context).textTheme.titleMedium,
                decoration: InputDecoration(
                  filled: true,
                  enabled: true,
                  prefixIcon: Padding(
                    padding:
                        const EdgeInsets.only(top: 16, bottom: 16, left: 10),
                    child: SvgPicture.asset(
                      AppIcons.search,
                      height: 18,
                    ),
                  ),
                  fillColor: AppColors.transparentDetails,
                  hintText: "Search Drugs, Reviews, and Ratings...",
                  hintStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
                      fontFamily: AppFont.fontMedium,
                      fontSize: 14,
                      color: AppColors.skipGrey),
                  border: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.transparent, width: 0.5),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.transparent, width: 0.5),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.transparent, width: 0.5),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.transparent, width: 0.5),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 17,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
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
                                Get.to(() => UploadPrescription());
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryColor,
                                  fixedSize: const Size(150, 18),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
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
                          fontFamily: AppFont.fontMedium,
                          fontSize: 15.5,
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
                                        // child: CachedNetworkImage(
                                        //   height: 60,
                                        //   width: 60,
                                        //   imageUrl: categoryList[index].image!,
                                        //   errorWidget: (context, url, error) =>
                                        //       const Icon(Icons.error),
                                        //   progressIndicatorBuilder: (context,
                                        //           url, downloadProgress) =>
                                        //       SizedBox(
                                        //     width: 30,
                                        //     height: 30,
                                        //     child: Center(
                                        //         child: LoadingIndicator(
                                        //       colors: [AppColors.primaryColor],
                                        //       indicatorType:
                                        //           Indicator.ballScale,
                                        //       strokeWidth: 1,
                                        //     )),
                                        //   ),
                                        //   fit: BoxFit.cover,
                                        // ),
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
            Divider(
              height: 10,
              color: AppColors.lineGrey,
              thickness: 1,
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
