// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/progress_bar/gf_progress_bar.dart';
import 'package:medic/controller/medicine_controller.dart';
import 'package:medic/model/medicine_data.dart';
import 'package:medic/screen/order_placement_screen.dart';
import 'package:medic/screen/upload_pres_screen.dart';
import 'package:medic/theme/colors.dart';
import 'package:medic/utils/app_font.dart';
import 'package:medic/utils/assets.dart';
import 'package:medic/utils/string.dart';
import 'package:medic/widgets/shimmer_widget.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

class MedicineDetails extends GetView<MedicineController> {
  MedicineData? medicineData;

  MedicineDetails({this.medicineData});

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
          Container(
            color: AppColors.primaryColor,
            height: 55,
            child: ListTile(
              contentPadding: const EdgeInsets.only(left: 15, right: 5),
              horizontalTitleGap: 5,
              leading: SvgPicture.asset(AppImages.rxBar),
              title: Text(
                ConstString.prescriptionRequirement,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
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
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: AppColors.white, fontFamily: AppFont.fontMedium),
                  )),
            ),
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
                      width: 180,
                      imageUrl: medicineData?.image ?? "",
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) => SizedBox(
                        width: 30,
                        height: 30,
                        child: Center(
                          child: CupertinoActivityIndicator(
                            color: AppColors.primaryColor,
                            animating: true,
                            radius: 10,
                          ),
                        ),
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                      top: 10,
                      right: 10,
                      child: SvgPicture.asset(AppIcons.like))
                ],
              ),
            ),
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
                          rating: medicineData!.ratings!,
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
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
                          height: 3,
                        ),
                        Text(
                          "30% Off",
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(
                                  fontSize: 11,
                                  color: AppColors.primaryColor,
                                  fontFamily: AppFont.fontMedium),
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        decoration: BoxDecoration(
                            color: AppColors.decsGrey,
                            borderRadius: BorderRadius.circular(5)),
                        height: 28,
                        width: 28,
                        child: Icon(
                          Icons.remove,
                          color: AppColors.phoneGrey,
                          size: 18,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      "0",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        decoration: BoxDecoration(
                            color: AppColors.decsGrey,
                            borderRadius: BorderRadius.circular(5)),
                        height: 28,
                        width: 28,
                        child: Icon(
                          Icons.add,
                          color: AppColors.primaryColor,
                          size: 18,
                        ),
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
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
                Text(medicineData?.benefits ?? "",
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
                Text(medicineData?.uses ?? ""
                  ,style: Theme.of(context)
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
                  medicineData?.directionForUse ?? ""
                  ,style: Theme.of(context)
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
                  medicineData?.safetyInformation ?? ""
                  ,style: Theme.of(context)
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
                  medicineData?.about ?? ""
                  ,style: Theme.of(context)
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
          Padding(
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
                          .copyWith(fontSize: 30, fontFamily: AppFont.fontBold),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    SmoothStarRating(
                      rating: medicineData?.ratings ?? 5,
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
                      "45,683",
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontSize: 12, fontFamily: AppFont.fontMedium),
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
                            percentage: 0.8,
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
                            percentage: 0.6,
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
                            percentage: 0.4,
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
                            percentage: 0.2,
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
                            percentage: 0.1,
                            width: 180,
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Container(
              height: 1,
              color: AppColors.lineGrey,
              width: double.infinity,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: Image.asset("asset/dummy1.png", height: 35),
                  title: Text(
                    "Brandie",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontFamily: AppFont.fontBold, fontSize: 14),
                  ),
                  subtitle: Text(
                    "June,2023",
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(),
                  ),
                  horizontalTitleGap: 8,
                  contentPadding: EdgeInsets.zero,
                ),
                SmoothStarRating(
                  rating: 4,
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
                  height: 10,
                ),
                Text(
                  "I've had the pleasure of using the Iconic Remidies for a few months now, and I couldn't be happier with my purchase. This device has genuinely transformed the way I manage my daily tasks and entertainment needs.",
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(height: 1.5, color: AppColors.txtGrey),
                )
              ],
            ),
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
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
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
                    onPressed: () {},
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
          SizedBox(
            height: 260,
            child: StreamBuilder(
              stream: controller.fetchMedicines(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
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
                  return ListView.builder(
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
                                          CachedNetworkImage(
                                            height: 30,
                                            width: 30,
                                            imageUrl:
                                            medicineList[index]
                                                .image ?? "",
                                            errorWidget: (context, url,
                                                error) =>
                                            const Icon(Icons.error),
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
                                            // fit: BoxFit.cover,
                                          ),
                                          Positioned(
                                              top: 10,
                                              right: 10,
                                              child: SvgPicture.asset(
                                                  AppIcons.like))
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
                                        medicineList[index].brandName ?? "",
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
                                        rating: medicineList[index]
                                            .ratings!,
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
                                                onPressed: () {
                                                  Get.to(() =>
                                                      OrderPlacement());
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
          const SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
