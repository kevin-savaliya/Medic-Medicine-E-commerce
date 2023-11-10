// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/progress_bar/gf_progress_bar.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:medic/controller/cart_controller.dart';
import 'package:medic/controller/medicine_controller.dart';
import 'package:medic/model/medicine_data.dart';
import 'package:medic/model/review_data_model.dart';
import 'package:medic/model/user_model.dart';
import 'package:medic/screen/cart_screen.dart';
import 'package:medic/screen/medicine_screen.dart';
import 'package:medic/screen/order_placement_screen.dart';
import 'package:medic/screen/phone_login_screen.dart';
import 'package:medic/screen/upload_pres_screen.dart';
import 'package:medic/theme/colors.dart';
import 'package:medic/utils/app_font.dart';
import 'package:medic/utils/assets.dart';
import 'package:medic/utils/string.dart';
import 'package:medic/utils/utils.dart';
import 'package:medic/widgets/shimmer_widget.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

class MedicineDetails extends StatelessWidget {
  final MedicineData? medicineData;

  MedicineDetails({super.key, this.medicineData});

  final MedicineController controller = Get.put(MedicineController());
  final CartController cartController = Get.put(CartController());

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
        elevation: 1.5,
        shadowColor: AppColors.txtGrey.withOpacity(0.2),
        actions: [
          GestureDetector(
              onTap: () {},
              child: SvgPicture.asset(
                AppIcons.search,
                width: 20,
              )),
          const SizedBox(
            width: 12,
          ),
          GestureDetector(
              onTap: () {},
              child: SvgPicture.asset(
                AppIcons.bag,
                width: 22,
              )),
          const SizedBox(
            width: 15,
          ),
        ],
      ),
      body: medicineDetailWidget(context),
    );
  }

  Widget medicineDetailWidget(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          FutureBuilder(
            future: cartController.checkPrescriptionStatus(
                medicineData!.id!, context),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(
                    height: 50,
                    child: Center(child: CupertinoActivityIndicator()));
              } else if (snapshot.hasData) {
                bool isCheck = snapshot.data ?? false;
                return Visibility(
                    visible: isCheck,
                    child: Container(
                      color: AppColors.primaryColor,
                      height: 55,
                      child: ListTile(
                        contentPadding:
                            const EdgeInsets.only(left: 15, right: 5),
                        horizontalTitleGap: 5,
                        leading: SvgPicture.asset(AppImages.rxBar),
                        title: Text(
                          ConstString.prescriptionRequirement,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                  color: AppColors.white,
                                  fontFamily: AppFont.fontRegular,
                                  height: 1.4,
                                  fontSize: 12.5),
                        ),
                        trailing: TextButton(
                            onPressed: () {
                              Get.to(() => UploadPrescription());
                            },
                            child: Text(
                              ConstString.upload,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                      color: AppColors.white,
                                      fontFamily: AppFont.fontMedium),
                            )),
                      ),
                    ));
              } else {
                return const SizedBox();
              }
            },
          ),
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SizedBox(
              width: double.infinity,
              child: Stack(
                children: [
                  Center(
                    child: CachedNetworkImage(
                      height: 160,
                      width: double.infinity,
                      imageUrl: medicineData?.image ?? "",
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) => SizedBox(
                        width: 30,
                        height: 30,
                        child: Center(
                            child: LoadingIndicator(
                          colors: [AppColors.primaryColor],
                          indicatorType: Indicator.ballScale,
                          strokeWidth: 1,
                        )),
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  Obx(() {
                    String medicineId = medicineData!.id!;
                    bool isFav = controller.isFavourite(medicineId);
                    return Positioned(
                        top: 5,
                        right: 5,
                        child: GestureDetector(
                          onTap: () async {
                            if (controller.firebaseuser == null) {
                              Utils().showAlertDialog(
                                  context: context,
                                  title: "Login Required!",
                                  content:
                                      "Ready to Get Started? \nConfirm with 'Yes' and Login Your Account.",
                                  onPressed: () {
                                    Get.back();
                                    Get.to(() => const PhoneLoginScreen());
                                  });
                              return;
                            }
                            if (isFav) {
                              await controller.removeFavourite(medicineId);
                            } else {
                              controller.addFavourite(medicineId);
                            }
                          },
                          child: isFav
                              ? SvgPicture.asset(
                                  AppIcons.favFillRed,
                                  height: 25,
                                )
                              : SvgPicture.asset(
                                  AppIcons.like,
                                  height: 25,
                                ),
                        ));
                  })
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          medicineData!.genericName!,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(
                                  fontFamily: AppFont.fontBold,
                                  color: AppColors.darkPrimaryColor,
                                  fontSize: 13.5),
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Text(
                          medicineData?.brandName ?? "",
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(
                                  fontFamily: AppFont.fontRegular,
                                  color: AppColors.txtGrey,
                                  fontSize: 12),
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        SmoothStarRating(
                          rating: double.parse(medicineData!.ratings == ""
                              ? "5"
                              : medicineData!.ratings!),
                          allowHalfRating: true,
                          defaultIconData: Icons.star,
                          filledIconData: Icons.star,
                          halfFilledIconData: Icons.star_half,
                          starCount: 5,
                          spacing: 2,
                          onRatingChanged: (rating) {},
                          size: 15,
                          color: AppColors.secondaryColor,
                          borderColor: AppColors.indGrey,
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "SLE 120",
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium!
                          .copyWith(
                              color: AppColors.darkPrimaryColor,
                              fontFamily: AppFont.fontMedium),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      "30% Off",
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          fontSize: 11,
                          color: AppColors.primaryColor,
                          fontFamily: AppFont.fontMedium),
                    ),
                    const Spacer(),
                    ElevatedButton(
                        onPressed: () async {
                          await cartController.addToCart(medicineData!,
                              qty: cartController.qty.value);
                          Get.to(() => CartScreen());
                          cartController.qty.value = 1;
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                            backgroundColor: AppColors.primaryColor,
                            fixedSize: const Size(110, 20),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30))),
                        child: Text(
                          "Add to cart",
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(
                            fontSize: 11,
                                  color: AppColors.white,
                                  fontFamily: AppFont.fontMedium),
                        ))
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Container(
              height: 1,
              color: AppColors.lineGrey,
              width: double.infinity,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: ExpansionTileCard(
              contentPadding: EdgeInsets.zero,
              baseColor: AppColors.white,
              elevation: 0,
              title: Text(
                ConstString.description,
                textAlign: TextAlign.start,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontFamily: AppFont.fontBold, fontSize: 14),
              ),
              children: [
                Container(
                  height: 1,
                  color: AppColors.lineGrey,
                  width: double.infinity,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  medicineData?.description ?? "",
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(height: 1.5, color: AppColors.txtGrey),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              height: 1,
              color: AppColors.lineGrey,
              width: double.infinity,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: ExpansionTileCard(
              contentPadding: EdgeInsets.zero,
              baseColor: AppColors.white,
              elevation: 0,
              title: Text(
                ConstString.benefits,
                textAlign: TextAlign.start,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontFamily: AppFont.fontBold, fontSize: 14),
              ),
              children: [
                Container(
                  height: 1,
                  color: AppColors.lineGrey,
                  width: double.infinity,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  medicineData?.benefits ?? "",
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(height: 1.5, color: AppColors.txtGrey),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              height: 1,
              color: AppColors.lineGrey,
              width: double.infinity,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: ExpansionTileCard(
              contentPadding: EdgeInsets.zero,
              baseColor: AppColors.white,
              elevation: 0,
              title: Text(
                ConstString.uses,
                textAlign: TextAlign.start,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontFamily: AppFont.fontBold, fontSize: 14),
              ),
              children: [
                Container(
                  height: 1,
                  color: AppColors.lineGrey,
                  width: double.infinity,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  medicineData?.uses ?? "",
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(height: 1.5, color: AppColors.txtGrey),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              height: 1,
              color: AppColors.lineGrey,
              width: double.infinity,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: ExpansionTileCard(
              contentPadding: EdgeInsets.zero,
              baseColor: AppColors.white,
              elevation: 0,
              title: Text(
                ConstString.direction,
                textAlign: TextAlign.start,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontFamily: AppFont.fontBold, fontSize: 14),
              ),
              children: [
                Container(
                  height: 1,
                  color: AppColors.lineGrey,
                  width: double.infinity,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  medicineData?.directionForUse ?? "",
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(height: 1.5, color: AppColors.txtGrey),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              height: 1,
              color: AppColors.lineGrey,
              width: double.infinity,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: ExpansionTileCard(
              contentPadding: EdgeInsets.zero,
              baseColor: AppColors.white,
              elevation: 0,
              title: Text(
                ConstString.safety,
                textAlign: TextAlign.start,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontFamily: AppFont.fontBold, fontSize: 14),
              ),
              children: [
                Container(
                  height: 1,
                  color: AppColors.lineGrey,
                  width: double.infinity,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  medicineData?.safetyInformation ?? "",
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(height: 1.5, color: AppColors.txtGrey),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              height: 1,
              color: AppColors.lineGrey,
              width: double.infinity,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: ExpansionTileCard(
              contentPadding: EdgeInsets.zero,
              baseColor: AppColors.white,
              elevation: 0,
              title: Text(
                ConstString.FAQ,
                textAlign: TextAlign.start,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontFamily: AppFont.fontBold, fontSize: 14),
              ),
              children: [
                Container(
                  height: 1,
                  color: AppColors.lineGrey,
                  width: double.infinity,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  medicineData?.about ?? "",
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(height: 1.5, color: AppColors.txtGrey),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Container(
              height: 1,
              color: AppColors.lineGrey,
              width: double.infinity,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                ConstString.rating_review,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontFamily: AppFont.fontBold),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          StreamBuilder(
            stream: controller.streamRatingCounts(medicineData!.id!),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CupertinoActivityIndicator());
              } else if (snapshot.hasData) {
                Map<int, int> ratingCount = snapshot.data!;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            medicineData!.ratings!.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge!
                                .copyWith(
                                    fontSize: 30, fontFamily: AppFont.fontBold),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          SmoothStarRating(
                            rating: double.parse(medicineData!.ratings == ""
                                ? "5"
                                : medicineData!.ratings!),
                            allowHalfRating: true,
                            defaultIconData: Icons.star,
                            filledIconData: Icons.star,
                            halfFilledIconData: Icons.star_half,
                            starCount: 5,
                            spacing: 4,
                            onRatingChanged: (rating) {},
                            size: 16,
                            color: AppColors.secondaryColor,
                            borderColor: AppColors.indGrey,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            "12345",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                    fontSize: 12,
                                    fontFamily: AppFont.fontMedium),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Text(
                                "5",
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              SizedBox(
                                width: 200,
                                child: GFProgressBar(
                                  backgroundColor: AppColors.lineGrey,
                                  lineHeight: 7,
                                  progressBarColor: AppColors.secondaryColor,
                                  percentage: ratingCount[5]!.toDouble() / 100,
                                  width: 180,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Text(
                                "4",
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              SizedBox(
                                width: 200,
                                child: GFProgressBar(
                                  backgroundColor: AppColors.lineGrey,
                                  lineHeight: 7,
                                  progressBarColor: AppColors.secondaryColor,
                                  percentage: ratingCount[4]!.toDouble() / 100,
                                  width: 180,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Text(
                                "3",
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              SizedBox(
                                width: 200,
                                child: GFProgressBar(
                                  backgroundColor: AppColors.lineGrey,
                                  lineHeight: 7,
                                  progressBarColor: AppColors.secondaryColor,
                                  percentage: ratingCount[3]!.toDouble() / 100,
                                  width: 180,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Text(
                                "2",
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              SizedBox(
                                width: 200,
                                child: GFProgressBar(
                                  backgroundColor: AppColors.lineGrey,
                                  lineHeight: 7,
                                  progressBarColor: AppColors.secondaryColor,
                                  percentage: ratingCount[2]!.toDouble() / 100,
                                  width: 180,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Text(
                                "1",
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              SizedBox(
                                width: 200,
                                child: GFProgressBar(
                                  backgroundColor: AppColors.lineGrey,
                                  lineHeight: 7,
                                  progressBarColor: AppColors.secondaryColor,
                                  percentage: ratingCount[1]!.toDouble() / 100,
                                  width: 180,
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                );
              } else {
                return Text("No Review!");
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Container(
              height: 1,
              color: AppColors.lineGrey,
              width: double.infinity,
            ),
          ),
          StreamBuilder(
            stream: controller.getReview(medicineData!.id!),
            builder: (context, snapshot) {
              List<ReviewDataModel>? reviewList;
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CupertinoActivityIndicator();
              } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                reviewList = snapshot.data;
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: reviewList!.length,
                  separatorBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      child: Divider(
                        color: AppColors.lineGrey,
                        height: 1,
                        thickness: 1,
                      ),
                    );
                  },
                  itemBuilder: (context, index) {
                    ReviewDataModel review = reviewList![index];
                    UserModel user =
                        controller.findSingleUserFromAllUser(review.userId!);
                    String formattedDate =
                        controller.formatDateTime(review.createdTime!);
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            leading: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.primaryColor),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: SvgPicture.asset(
                                    AppImages.medic_white_text),
                              ),
                            ),
                            title: Text(
                              "${user.name}",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                      fontFamily: AppFont.fontBold,
                                      fontSize: 14),
                            ),
                            subtitle: Text(
                              formattedDate,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(),
                            ),
                            horizontalTitleGap: 8,
                            contentPadding: EdgeInsets.zero,
                          ),
                          SmoothStarRating(
                            rating: review.rating!,
                            allowHalfRating: true,
                            defaultIconData: Icons.star_border,
                            filledIconData: Icons.star,
                            halfFilledIconData: Icons.star_half,
                            starCount: 5,
                            spacing: 2,
                            onRatingChanged: (rating) {},
                            size: 15,
                            color: AppColors.secondaryColor,
                            borderColor: AppColors.secondaryColor,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "${review.review}",
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                    height: 1.5, color: AppColors.txtGrey),
                          )
                        ],
                      ),
                    );
                  },
                );
              } else {
                return Text(
                  "No Reviews Found",
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: AppColors.secondaryColor,
                      fontFamily: AppFont.fontMedium),
                );
              }
            },
          ),
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Container(
              height: 1,
              color: AppColors.lineGrey,
              width: double.infinity,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: SizedBox(
              height: 320,
              child: StreamBuilder(
                stream: controller.fetchMedicines(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return MedicineShimmer(itemCount: snapshot.data?.length);
                  } else if (snapshot.hasError) {
                    return Container(
                      alignment: Alignment.center,
                      height: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: AppColors.tilePrimaryColor),
                      child: Text(
                        "Error : ${snapshot.error}",
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: AppColors.primaryColor,
                            fontSize: 13,
                            fontFamily: AppFont.fontMedium),
                      ),
                    );
                  } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    List<MedicineData> medicineList = snapshot.data!;
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              ConstString.recommended,
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium!
                                  .copyWith(
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
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                          color: AppColors.primaryColor,
                                          fontFamily: AppFont.fontMedium,
                                          fontSize: 14),
                                ))
                          ],
                        ),
                        SizedBox(
                          height: 260,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: medicineList.length,
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
                                                        const BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    10),
                                                            topRight:
                                                                Radius.circular(
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
                                                              CupertinoActivityIndicator(
                                                            color: AppColors
                                                                .primaryColor,
                                                            animating: true,
                                                            radius: 10,
                                                          ),
                                                        ),
                                                      ),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  Obx(() {
                                                    String medicineId =
                                                        medicineList[index].id!;
                                                    bool isFav =
                                                        controller.isFavourite(
                                                            medicineId);
                                                    return Positioned(
                                                        top: 10,
                                                        right: 10,
                                                        child: GestureDetector(
                                                          onTap: () async {
                                                            if (controller
                                                                    .firebaseuser ==
                                                                null) {
                                                              Utils()
                                                                  .showAlertDialog(
                                                                      context:
                                                                          context,
                                                                      title:
                                                                          "Login Required!",
                                                                      content:
                                                                          "Ready to Get Started? \nConfirm with 'Yes' and Login Your Account.",
                                                                      onPressed:
                                                                          () {
                                                                        Get.back();
                                                                        Get.to(() =>
                                                                            PhoneLoginScreen());
                                                                      });
                                                              return;
                                                            }
                                                            if (isFav) {
                                                              await controller
                                                                  .removeFavourite(
                                                                      medicineId);
                                                            } else {
                                                              await controller
                                                                  .addFavourite(
                                                                      medicineId);
                                                            }
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
                                                                  AppIcons.like,
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
                                                          Radius.circular(12))),
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
                                                        fontFamily:
                                                            AppFont.fontMedium,
                                                        color: AppColors
                                                            .darkPrimaryColor,
                                                        fontSize: 13.5),
                                              ),
                                              const SizedBox(
                                                height: 3,
                                              ),
                                              Text(
                                                medicineList[index].brandName ??
                                                    "",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleSmall!
                                                    .copyWith(
                                                        fontFamily:
                                                            AppFont.fontRegular,
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
                                                color: AppColors.secondaryColor,
                                                borderColor: AppColors.indGrey,
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
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .displayMedium!
                                                            .copyWith(
                                                                color: AppColors
                                                                    .darkPrimaryColor,
                                                                fontFamily: AppFont
                                                                    .fontMedium),
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                        "30% Off",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleSmall!
                                                            .copyWith(
                                                                fontSize: 10,
                                                                color: AppColors
                                                                    .primaryColor,
                                                                fontFamily: AppFont
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
                                                          await cartController
                                                              .addToCart(
                                                                  medicineList[
                                                                      index],
                                                                  qty: cartController
                                                                      .qty
                                                                      .value);
                                                          Get.to(() =>
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
                                                            fontSize: 11.5,
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
                        ),
                      ],
                    );
                  } else {
                    return Container(
                      alignment: Alignment.center,
                      height: 150,
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
            ),
          ),
          const SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
