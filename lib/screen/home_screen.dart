// ignore_for_file: deprecated_member_use, must_be_immutable

import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:medic/controller/auth_controller.dart';
import 'package:medic/controller/cart_controller.dart';
import 'package:medic/controller/home_controller.dart';
import 'package:medic/controller/medicine_controller.dart';
import 'package:medic/model/category_data.dart';
import 'package:medic/model/medicine_data.dart';
import 'package:medic/screen/add_review_screen.dart';
import 'package:medic/screen/cart_screen.dart';
import 'package:medic/screen/favourite_screen.dart';
import 'package:medic/screen/medicine_category.dart';
import 'package:medic/screen/medicine_details.dart';
import 'package:medic/screen/medicine_screen.dart';
import 'package:medic/screen/notification_screen.dart';
import 'package:medic/screen/phone_login_screen.dart';
import 'package:medic/screen/popular_medicine.dart';
import 'package:medic/screen/profile_screen.dart';
import 'package:medic/screen/reminder_screen.dart';
import 'package:medic/screen/search_screen.dart';
import 'package:medic/screen/upload_pres_screen.dart';
import 'package:medic/theme/colors.dart';
import 'package:medic/utils/app_font.dart';
import 'package:medic/utils/assets.dart';
import 'package:medic/utils/string.dart';
import 'package:medic/utils/utils.dart';
import 'package:medic/widgets/shimmer_widget.dart';
import 'package:medic/widgets/user/my_name_text_widget.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

class HomeScreen extends StatelessWidget {
  HomeController controller = Get.put(HomeController());

  final AuthController _authController = Get.find();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    CartController cartController = Get.put(CartController());
    return GetBuilder(
      init: HomeController(),
      builder: (controller) {
        if (!controller.initialized) {
          return Container();
        }
        if (controller.pageIndex.value == 0) {
          return Scaffold(
            body: homeWidget(context, controller, cartController),
            bottomNavigationBar: bottomNavigationBar(context),
          );
        } else if (controller.pageIndex.value == 1) {
          return Scaffold(
            body: const Center(child: Text("Explore")),
            bottomNavigationBar: bottomNavigationBar(context),
          );
        } else if (controller.pageIndex.value == 2) {
          return Scaffold(
            body: CartScreen(),
            bottomNavigationBar: bottomNavigationBar(context),
          );
        } else if (controller.pageIndex.value == 3) {
          return Scaffold(
            body: FavouriteScreen(),
            bottomNavigationBar: bottomNavigationBar(context),
          );
        } else if (controller.pageIndex.value == 4) {
          return Scaffold(
            body: ProfileScreen(),
            bottomNavigationBar: bottomNavigationBar(context),
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget homeWidget(BuildContext context, HomeController controller,
      CartController cartController) {
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
                controller.firebaseUser != null
                    ? SvgPicture.asset(AppIcons.fillpin)
                    : BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                        child: SvgPicture.asset(AppIcons.fillpin),
                      ), // TODO: change icon when user is not logged In
                const SizedBox(
                  width: 3,
                ),
                Text(
                  // TODO: add condition for location
                  "Santa, Illinois 85486",
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(color: AppColors.primaryColor),
                ),
              ],
            ),
            if (controller.firebaseUser != null) ...[
              const SizedBox(
                height: 5,
              ),
              MyNameTextWidget(
                textStyle: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontFamily: AppFont.fontMedium),
              )
            ] else
              Container(),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        mini: false,
        spaceBetweenChildren: 4,
        activeIcon: Icons.close,
        closeDialOnPop: true,
        overlayColor: AppColors.darkPrimaryColor,
        childrenButtonSize: const Size(60, 60),
        iconTheme: IconThemeData(color: AppColors.white),
        backgroundColor: AppColors.primaryColor,
        children: [
          SpeedDialChild(
              onTap: () {
                Get.to(() => ReminderScreen());
              },
              child: SvgPicture.asset(
                AppIcons.addReminder,
                color: AppColors.primaryColor,
              ),
              backgroundColor: AppColors.white,
              label: "Add Reminders",
              labelStyle: Theme.of(context).textTheme.titleMedium),
          SpeedDialChild(
              onTap: () {
                Get.to(() => UploadPrescription());
              },
              child: SvgPicture.asset(AppIcons.uploadPres),
              backgroundColor: AppColors.white,
              label: "Upload Prescription",
              labelStyle: Theme.of(context).textTheme.titleMedium),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 30),
          child: Column(
            children: [
              TextFormField(
                readOnly: true,
                onTap: () async {
                  await Get.to(() => SearchScreen());
                },
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
              const SizedBox(
                height: 10,
              ),
              Row(
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
              GetBuilder<MedicineController>(
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

                            return ListView.builder(
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
                                    ConstString.noCategory,
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
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    ConstString.popularMedicine,
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                          color: AppColors.darkPrimaryColor,
                          fontFamily: AppFont.fontMedium,
                          fontSize: 15.5,
                        ),
                  ),
                  TextButton(
                      onPressed: () {
                        Get.to(() => PopularMedicine());
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
              GetBuilder<MedicineController>(
                init: MedicineController(),
                builder: (controller) {
                  return SizedBox(
                    height: 130,
                    child: StreamBuilder(
                      stream: controller.fetchPopularMedicines(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return PopularMedicineShimmer(
                              itemCount: snapshot.data?.length);
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
                          List<MedicineData> medicinelist = snapshot.data!;
                          return SizedBox(
                            height: 130,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: medicinelist.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: 120,
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: controller.popularColorList[index %
                                          (controller.popularColorList.length)],
                                    ),
                                    child: Stack(
                                      children: [
                                        SvgPicture.asset(
                                            AppImages.designVector),
                                        Positioned(
                                            top: 20,
                                            left: 15,
                                            child: Text(
                                              medicinelist[index].genericName ??
                                                  "",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium!
                                                  .copyWith(
                                                      color: AppColors.white),
                                            )),
                                        Positioned(
                                            bottom: 0,
                                            right: 0,
                                            child: Image.asset(
                                              controller.medicineImageList[
                                                  index %
                                                      (controller
                                                          .medicineImageList
                                                          .length)],
                                              height: 60,
                                            ))
                                      ],
                                    ),
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
                                  ConstString.noMedicine,
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
                    ),
                  );
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    ConstString.recommended,
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                          color: AppColors.darkPrimaryColor,
                          fontFamily: AppFont.fontMedium,
                          fontSize: 15.5,
                        ),
                  ),
                  TextButton(
                      onPressed: () {
                        Get.to(() => MedicineScreen());
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
              GetBuilder<MedicineController>(
                init: MedicineController(),
                builder: (controller) {
                  return SizedBox(
                    height: 260,
                    child: StreamBuilder(
                      stream: controller.fetchMedicines(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return MedicineShimmer(
                              itemCount: snapshot.data?.length);
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
                          List<MedicineData> medicineList = snapshot.data!;
                          return SizedBox(
                            height: 260,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 4,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    Get.to(() => MedicineDetails(
                                        medicineData: medicineList[index]));
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 5),
                                    width: 200,
                                    decoration: BoxDecoration(
                                        color: AppColors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                            color: AppColors.decsGrey)),
                                    child: Column(
                                      children: [
                                        Expanded(
                                            flex: 5,
                                            child: SizedBox(
                                              width: double.infinity,
                                              child: Center(
                                                child: Stack(
                                                  fit: StackFit.expand,
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .only(
                                                              topLeft: Radius
                                                                  .circular(10),
                                                              topRight: Radius
                                                                  .circular(
                                                                      10)),
                                                      child: CachedNetworkImage(
                                                        height: 30,
                                                        width: 30,
                                                        imageUrl:
                                                            medicineList[index]
                                                                    .image ??
                                                                "",
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            const Icon(
                                                                Icons.error),
                                                        progressIndicatorBuilder:
                                                            (context, url,
                                                                    downloadProgress) =>
                                                                SizedBox(
                                                          width: 30,
                                                          height: 30,
                                                          child: Center(
                                                              child:
                                                                  LoadingIndicator(
                                                            colors: [
                                                              AppColors
                                                                  .primaryColor
                                                            ],
                                                            indicatorType:
                                                                Indicator
                                                                    .ballScale,
                                                            strokeWidth: 1,
                                                          )),
                                                        ),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                    Obx(() {
                                                      String medicineId =
                                                          medicineList[index]
                                                              .id!;
                                                      bool isFav = controller
                                                          .isFavourite(
                                                              medicineId);
                                                      return Positioned(
                                                          top: 10,
                                                          right: 10,
                                                          child:
                                                              GestureDetector(
                                                            onTap: () async {
                                                              await markFavourite(
                                                                  controller,
                                                                  context,
                                                                  isFav,
                                                                  medicineId);
                                                            },
                                                            child: isFav
                                                                ? SvgPicture
                                                                    .asset(
                                                                    AppIcons
                                                                        .favFillRed,
                                                                    height: 22,
                                                                  )
                                                                : SvgPicture
                                                                    .asset(
                                                                    AppIcons
                                                                        .like,
                                                                    height: 22,
                                                                  ),
                                                          ));
                                                    })
                                                  ],
                                                ),
                                              ),
                                            )),
                                        Expanded(
                                          flex: 6,
                                          child: Container(
                                            padding: const EdgeInsets.all(10),
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                                color: AppColors.white,
                                                borderRadius:
                                                    const BorderRadius.only(
                                                        bottomLeft:
                                                            Radius.circular(12),
                                                        bottomRight:
                                                            Radius.circular(
                                                                12))),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  medicineList[index]
                                                      .genericName!,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleSmall!
                                                      .copyWith(
                                                          fontFamily: AppFont
                                                              .fontMedium,
                                                          color: AppColors
                                                              .darkPrimaryColor,
                                                          fontSize: 13.5),
                                                ),
                                                const SizedBox(
                                                  height: 3,
                                                ),
                                                Text(
                                                  medicineList[index]
                                                          .brandName ??
                                                      "",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleSmall!
                                                      .copyWith(
                                                          fontFamily: AppFont
                                                              .fontRegular,
                                                          color:
                                                              AppColors.txtGrey,
                                                          fontSize: 12),
                                                ),
                                                const SizedBox(
                                                  height: 3,
                                                ),
                                                SmoothStarRating(
                                                  rating: double.parse(
                                                      medicineList[index]
                                                                  .ratings ==
                                                              ""
                                                          ? "5"
                                                          : medicineList[index]
                                                              .ratings!),
                                                  allowHalfRating: true,
                                                  defaultIconData: Icons.star,
                                                  filledIconData: Icons.star,
                                                  halfFilledIconData:
                                                      Icons.star_half,
                                                  starCount: 5,
                                                  spacing: 2,
                                                  onRatingChanged: (rating) {},
                                                  size: 15,
                                                  color:
                                                      AppColors.secondaryColor,
                                                  borderColor:
                                                      AppColors.indGrey,
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "SLE 120",
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .displayMedium!
                                                              .copyWith(
                                                                  color: AppColors
                                                                      .darkPrimaryColor,
                                                                  fontFamily:
                                                                      AppFont
                                                                          .fontMedium),
                                                        ),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        Text(
                                                          "30% Off",
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .titleSmall!
                                                              .copyWith(
                                                                  fontSize: 10,
                                                                  color: AppColors
                                                                      .primaryColor,
                                                                  fontFamily:
                                                                      AppFont
                                                                          .fontMedium),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Expanded(
                                                      child: ElevatedButton(
                                                          onPressed: () async {
                                                            await _addToCart(
                                                                cartController,
                                                                medicineList
                                                                    .elementAt(
                                                                        index));
                                                            await Get.to(() =>
                                                                CartScreen());
                                                          },
                                                          style: ElevatedButton.styleFrom(
                                                              backgroundColor:
                                                                  AppColors
                                                                      .tilePrimaryColor,
                                                              fixedSize:
                                                                  const Size(
                                                                      110, 20),
                                                              elevation: 0,
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              30))),
                                                          child: Text(
                                                            "Add to cart",
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .titleSmall!
                                                                .copyWith(
                                                                    color: AppColors
                                                                        .primaryColor,
                                                                    fontFamily:
                                                                        AppFont
                                                                            .fontMedium),
                                                          )),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
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
                                  ConstString.noMedicine,
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
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> markFavourite(MedicineController controller,
      BuildContext context, bool isFav, String medicineId) async {
    if (controller.firebaseuser == null) {
      Utils().showAlertDialog(
          context: context,
          title: "Login Required!",
          content:
              "Ready to Get Started? \nConfirm with 'Yes' and Login Your Account.",
          onPressed: () {
            Get.back();
            Get.to(() => PhoneLoginScreen());
          });
      return;
    }
    if (isFav) {
      await controller.removeFavourite(medicineId);
    } else {
      await controller.addFavourite(medicineId);
    }
  }

  Future<void> _addToCart(
      CartController cartController, MedicineData medicineData) async {
    await cartController.addToCart(medicineData);
  }

  Widget bottomNavigationBar(BuildContext context) {
    return GetBuilder<HomeController>(
      id: 'pageUpdate',
      builder: (controller) {
        return SizedBox(
          // alignment: Alignment.topCenter,
          height: 80,
          child: BottomNavigationBar(
              // backgroundColor: _authController.appStorage.getUserData() == null
              //     ? controller.pageIndex.value == 4
              //         ? AppColors.darkPrimaryColor.withOpacity(0.78)
              //         : AppColors.white
              //     : AppColors.white,
              currentIndex: controller.pageIndex.value,
              type: BottomNavigationBarType.fixed,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              selectedLabelStyle: TextStyle(
                  fontSize: 12,
                  fontFamily: AppFont.fontMedium,
                  color: AppColors.primaryColor),
              unselectedLabelStyle: TextStyle(
                  fontSize: 12,
                  fontFamily: AppFont.fontMedium,
                  color: AppColors.txtGrey),
              elevation: 0,
              onTap: (value) {
                controller.pageUpdateOnHomeScreen(value);
              },
              items: [
                BottomNavigationBarItem(
                    icon: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: SvgPicture.asset(
                        controller.pageIndex.value == 0
                            ? AppIcons.homeIcon
                            : AppIcons.homeHome,
                        color: controller.pageIndex.value == 0
                            ? AppColors.primaryColor
                            : AppColors.txtGrey,
                      ),
                    ),
                    label: "Home"),
                BottomNavigationBarItem(
                    icon: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: SvgPicture.asset(
                        controller.pageIndex.value == 1
                            ? AppIcons.exploreFill
                            : AppIcons.explore,
                        color: controller.pageIndex.value == 1
                            ? AppColors.primaryColor
                            : AppColors.txtGrey,
                      ),
                    ),
                    label: "Explore"),
                BottomNavigationBarItem(
                    icon: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: SvgPicture.asset(
                        controller.pageIndex.value == 2
                            ? AppIcons.cartFill
                            : AppIcons.cartIcon,
                        color: controller.pageIndex.value == 2
                            ? AppColors.primaryColor
                            : AppColors.txtGrey,
                      ),
                    ),
                    label: "Cart"),
                BottomNavigationBarItem(
                    icon: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: SvgPicture.asset(
                        controller.pageIndex.value == 3
                            ? AppIcons.favFill
                            : AppIcons.favourite,
                        color: controller.pageIndex.value == 3
                            ? AppColors.primaryColor
                            : AppColors.txtGrey,
                      ),
                    ),
                    label: "Favourite"),
                BottomNavigationBarItem(
                    icon: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: SvgPicture.asset(
                        controller.pageIndex.value == 4
                            ? AppIcons.profileFillIcon
                            : AppIcons.profileIcon,
                        color: controller.pageIndex.value == 4
                            ? AppColors.primaryColor
                            : AppColors.txtGrey,
                      ),
                    ),
                    label: "Profile"),
              ]),
        );
      },
    );
  }
}
